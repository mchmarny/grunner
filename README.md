# grunner

Self-hosted GitHub Actions runner on GCP using GCE.

![](assets/overview.png)

* GCE VMs in Managed Instance Groups (MIGs)
* Customizable runner:
  * VMs (image type, CPU, memory)
  * MIG (size of runner group)
* Configurable tooling (custom image, startup/shutdown script)
* User-defined IAM service account
* Unique GitHub token for each runner

## prerequisites

Since you are interested in self-hosted runners on GCP, you probably already have GCP account and a project. If not, review [creating projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects).

You will also need `gcloud`. You can find instructions on how to install it [here](https://cloud.google.com/sdk/docs/install). Mak sure to authenticate and set the default project:
  
```shell
gcloud auth application-default login
gcloud config set project $PROJECT_ID
```

## setup

Start by forking this repo using this `Use this template` button at the top of this page:

> When prompted, make sure to use private repo. Forks of a public repository could potentially run dangerous code on your machine by creating a pull request that executes the code in a workflow. More on self-hosted runner security [here](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners#self-hosted-runner-security).

Next, clone your own repo locally and initialize it: 

> This will update all repo specific names from the template to your new repo name. 

```shell
scripts/repo-init
```

Next, create the custom GCE VM image:

> See [scripts/img-startup](scripts/img-startup) for the content of the script that's used to configure the image. Pretty minimal for this demo, you can customize to your needs. 

```shell
scripts/img
```

The final response will include the version of your new image that will be used to underpin the runner VMs looking something like this:

```shell
image created: <your-project-id>/grunner-<version>
```

Next, create Terraform variables file: `deployments/terraform.tfvars`:

> Update as necessary. The Personal Access Tokens (PAT) is only needed to query the GitHub API to obtain registration token for each VM. You can find more about PATs [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens).

```shell
name    = "grunner"
project = "<your-project-id>"
region  = "us-west1"
repo    = "mchmarny/grunner"
token   = "<github-pat>"
image   = "<your-project>/<your-custom-image-name>"
```

> For complete list of the variables you can define see [deployments/variables.tf](deployments/variables.tf).

Create GCS bucket to store Terraform state. Couple of things to keep in mind: 

* Bucket name has to be globally unique
* The `project` flag value should match the values from `deployments/terraform.tfvars` 
* Bucket name must match the name in `deployments/backend.tf`. 

```shell
gcloud storage buckets create \
    gs://grunner-terraform-state \
    --project $PROJECT_ID \
    --location us-west1
```

When done, navigate into the [./deployments](./deployments) directory, and initialize Terraform:

```shell
cd deployments
terraform init
```

## deploy

Assuming you completed the above `setup`, you can now `apply` the configuration to deploy your private GitHub runners:

```shell
terraform apply
```

Check that at least one runner is registered by navigating to: https://github.com/$OWNER/$REPO/settings/actions/runners 

![](assets/runners.png)

> It may take up to 1 min after Terraform completed for all the runners to register in GitHub UI.

## usage

Your GitHub Actions workflows are same as with the managed runner. The only update is the `runs-on` value, which is not set to `self-hosted`

```yaml
jobs:
  demo:
    name: Test runner
    permissions:
      contents: read
    runs-on: self-hosted
    ...
```

## slsa

Even though the runner is different, you can still use the [SLSA Generator](https://github.com/slsa-framework/slsa-github-generator) as is. See the example workload [here](.github/workflows/slsa.yaml), and the resulting SLSA attestation [here](samples/cosign-att-payload.json).

## debug

If VM starts, but you do not see the runners registered in GitHub settings, start by listing the instances: 

```shell
gcloud compute instances list --filter "tags.items=grunner" --project $PROJECT_ID
```

The response should look something like this: 

```shell
NAME          ZONE        MACHINE_TYPE  INTERNAL_IP  EXTERNAL_IP  STATUS
grunner-5hdz  us-west1-b  e2-medium     10.138.0.55  *.*.*.*      RUNNING
grunner-98c6  us-west1-c  e2-medium     10.138.0.50  *.*.*.*      RUNNING
...
```

Pick one of the VMs and connect to it using SSH: 

```shell
gcloud compute ssh grunner-5hdz \
  --tunnel-through-iap \
  --zone us-west1-b \
  --project $PROJECT_ID
```

Check the output of the startup script:

```shell
sudo journalctl -u google-startup-scripts.service
```

The last few lines should confirm that the runner service has started: 

```shell
...
google_metadata_script_runner[1450]: Finished running startup scripts.
systemd[1]: google-startup-scripts.service: Deactivated successfully.
systemd[1]: Finished Google Compute Engine Startup Scripts.
```

If not, you can re-run the script, to find the issue: 

```shell
sudo google_metadata_script_runner startup
```

## cleanup

To destroy all resources created by this demo:

> Note, make sure to enter `yes` when prompted.

```shell
terraform destroy
```

## disclaimer

This is my personal project and it does not represent my employer. While I do my best to ensure that everything works, I take no responsibility for issues caused by this code.
