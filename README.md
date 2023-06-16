# grunner

Private runner for GitHub Actions on GCP

![](assets/runners.png)

## setup 

Create Terraform variables file: `deployments/terraform.tfvars`:

> Update as necessary, the GitHub PAT is only needed for obtain registration token for each VM. See [scripts/startup](scripts/startup) for usage.

```shell
name     = "grunner"
project  = "s3cme1"
region   = "us-west1"
zone     = "c"
machine  = "e2-medium"
vms      = 2
repo     = "mchmarny/grunner"
token    = "<github-pat>"
```

Create GCS bucket to store Terraform state:

> Note, the `project` and `location` flag values should match the values from `deployments/terraform.tfvars`. Also, the name of the bucket must match the name in deployments/backend.tf

```shell
gcloud storage buckets create \
    gs://grunner-terraform-state \
    --project s3cme1 \
    --location us-west1
```

When done, initialize Terraform:

```shell
make init
```

## deploy

Assuming the above `setup` has been configured, you can now deploy the private GitHub Runner:

```shell
make apply
```

Check that at least one runner is registered by navigating to: https://github.com/<owner>/<repo>/settings/actions/runners 

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

## cleanup

To destroy all resources created by this demo:

> Note, make sure to enter `yes` when prompted.

```shell
make destroy
```

## Disclaimer

This is my personal project and it does not represent my employer. While I do my best to ensure that everything works, I take no responsibility for issues caused by this code.
