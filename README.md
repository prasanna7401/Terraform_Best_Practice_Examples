# Learn Terraform

## Useful items:

1. **Statefile Backup**: 
    - If stored _**locally**_, the `tfstate.backup` file contains the previous terraform apply results. 
    - If storing in a _**remote backend**_, make sure to enable versioning to be able to roll back.
    - If your _apply_ operation fails without saving the state file to the remote backend, terraform will save the file locally under the name `errored.tfstate`. You can set up appropriate steps to save this file from your pipeline or CI Server. Alternatively, you can push this state file to the remote backend by `terraform state push errored.tfstate`
    - If your pipeline crashes during the process, the state file may remain locked. In this case, you can run `terraform force-unlock <LOCK_ID>`

2. **[Import existing resources or Handle Manual changes to managed resources](https://developer.hashicorp.com/terraform/language/import)**:
  _2.1. How to import a resource configuration for managing via terraform_
   - Step-1: Create an empty resource block in the terraform file 
    ```hcl
        resource "aws_security_group" "to_be_imported" {
        # fill later after import
        }
    ```
    - Step-2: Run `terraform import <resource_type>.<resource_name> <resource_id>` (For example, aws_security_group.example sg-12345)
    - Step-3: After the configurations get imported into your state file, run `terraform show` or `terraform state show <resource_type>.<resource_name>`
    - Step-4: Clean up the output-only attributes like `id`, `arn`, `timestamp`, etc., and add the code block to the terraform configuration file.

- If you had made manual changes to your terraform-managed resource, you could update your statefile by running `terraform apply --refresh-only` or `terraform refresh`

> Other options: For bulk import of resources, you can use tools like `terraformer` & `terracognita`

3. **Avoid Resource modification/deletion (useful for imported/critical resources)**:
    - Option 1: Add a lifecycle block to your code:
        ```hcl
        lifecycle {
            ignore_changes = [cidr_block] # or any specific resource config
            prevent_destroy = true
        }
        ```
    - Option 2: Manually remove the resource configuration from the state file.
        ```sh
            terraform state rm aws_instance.example
        ```

4. **[Schematize/Validate Input variables:](https://developer.hashicorp.com/terraform/language/values/)** 
- Basic Input Validation: Use `validation` block
   ```hcl
        variable "public_ip" { 
        description = "Public IP address for the service" 
        type = string 
        validation { 
            condition = can(regex("^(([0-9]{1,3}\\.){3}[0-9]{1,3})$", var.public_ip)) && length(split(".", var.public_ip)) == 4 && alltrue([for octet in split(".", var.public_ip) : tonumber(octet) <= 255]) 
            error_message = "The Public IP address must be in the format x.x.x.x where x is a number between 0 and 255." 
            } 
        }

   ```
- For complex conditions on created resource: Use `condition` block under `lifecycle` block.
- For more examples, check [here](./05%20-%20Production%20Use%20cases/1%20-%20Input%20validation/).

5. **Enforce Default Tags**: You can set up default tags during the provider configuration.
    ```hcl
    provider "aws" {
        region = "something"
        default_tags {
            tags = {
                deployment = "terraform"
            }
        }
    }
    ```
    - This adds the mentioned tag if no tag is specified in your resource or module.
    - Alternatively, you can use policy as code like _OPA_, _terratest_ to check your code. For reference, click [here](./06%20-%20Code%20Testing%20using%20Terratest/3%20-%20OPA%20based%20testing)

6. **Instructions before refactoring existing code**:
    - Modifying the names of the existing resource/module block may trigger changes causing downtime. So, follow appropriate procedures to _move_ the state file resource configurations using one of the below-mentioned steps:
    1. State move command: 
    ```sh
    terraform state mv <OLD_BLOCK_REFEERENCE> <NEW_REFERENCE>
    ```
    2. Use `moved` block:
    ```hcl
    moved {
        from = aws_instance.something
        to = aws_instance.myserver
    }
    ```

7. **Force Re-creation of resource**: Use either -`-replace` flag with plan or apply step. For ex: `terraform apply -replace="aws_something.example"`

8. **Troubleshooting**: Check `TF_LOG` environment variable output.

9. **Reference to another state file**:
- Use case: Access outputs and resource attributes of another terraform deployment.
- Example:
    ```hcl
    data "terraform_remote_state" "example" {
        # For locally stored state files
        # backend = "local"
        # config = {
        #     path = "..."
        # }
        # For remote backends:
        backend = "s3"
        config = {
            bucket = "my-bucket"
            key = "example/firewalls/terraform.tfstate"
            region = "us-east-1"
        }

    }
    ```

### Useful Supporting tools

1. [Gruntwork](https://docs.gruntwork.io/library/reference/) - Contains battle-tested codes for different use cases.
2. Terrascan - to scan for vulnerabilities.
3. Terratest - To perform IaC code testing (unit, integration).
4. Terraformer & Terracognita - To handle bulk import of existing resource configuration.
5. tfenv - To manage terraform versions
6. tfsec & tflint - Enforce policies
7. [Atlantis](https://www.runatlantis.io/) - Adds plan output automatically to the PR. Also capable of performing commit, plan, and apply operations.
