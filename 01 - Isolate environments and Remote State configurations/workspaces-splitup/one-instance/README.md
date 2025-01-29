- Create a new workspace: `terraform workspace new example`
- Switch to the another workspace: `terraform workspace switch <workspace_name>`

**Notes**:

- Local workspace state files are stored in `.terraform.tfstate.d` directory.
- You can access the workspace details using string interpolation `${terraform.workspace}`

- **Use different backends for different workspace**:
    You can use different backend configurations for each workspace using partial configuration. For example,

    ```sh
    # Create and switch to the dev workspace
    terraform workspace new dev

    # Initialize the backend
    terraform init -backend-config="dev-backend.tf"

    # Apply the configuration
    terraform apply -var-file="dev.tfvars"
    ```

- **Use workspace as condition for varying deployments**:

    ```hcl
    resource "aws_s3_bucket" "example_bucket" {
    count  = terraform.workspace == "prod" ? 1 : 0
    bucket = terraform.workspace == "prod" ? "prod-bucket" : "non-prod-bucket"
    acl    = "private"
    }

    resource "null_resource" "example_resource" {
    count = terraform.workspace == "dev" ? 1 : 0

    provisioner "local-exec" {
        command = "echo 'This resource exists only in the dev workspace'"
    }
    }

    ```