# grunner

GitHub Actions private runner on GCP

## setup 

Create GCS bucket to store Terraform state:

> Note, must match the name in deployments/backend.tf

```shell
gcloud storage buckets create \
    gs://grunner-terraform-state \
    --project $PROJECT_ID \
    --location $REGION
```




