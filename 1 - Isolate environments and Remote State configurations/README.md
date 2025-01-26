**Isolating environments** (based on environments and resource lifecycle): An example for AWS Infrastructure is shown below
<p  align="center">
<img src="https://miro.medium.com/v2/resize:fit:1100/format:webp/1*L9BTyj0M9j7ANsXeyFOctw.png" width="400">
</p>

- Splitting components into separate folders avoids the risk of destroying your entire infrastructure with one command but complicates creating your entire infrastructure at once. With a single Terraform configuration, you can spin up everything with one terraform apply command. With components in separate folders, you must run terraform apply in each folder individually. The solution: use Terragrunt's `run-all` command to execute commands across multiple folders concurrently.
- Breaking the code into multiple folders complicates using resource dependencies. If your app and database code were in the same Terraform configuration files, the app could directly access database attributes (e.g., `aws_db_instance.foo.address`). In separate folders, this direct access isn’t possible. The solution: use `dependency {}`blocks in Terragrunt.

    <sub><sup>Source: Y. Brikman, "_Terraform Up and Running_," 3rd ed. O'Reilly Media, 2022, ch. 3.</sup></sub>

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