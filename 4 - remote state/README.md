## Important Notes:

- Use S3 bucket to store statefiles: We first create an S3 bucket using TF, and use that bucket as a backend by later migrating the local state files to this bucket.
- Use DynamoDB to enable state locking
- When you define a remote-state using a data source, it is always fetched in **READ-ONLY** mode.
    
    ```hcl
    data "terraform_remote_state" "db" {
    backend = "s3"
    config = {
        bucket = var.db_remote_state_bucket
        key    = var.db_remote_state_key
        region = "<YOUR-REGION>"
        }
    }
    ```