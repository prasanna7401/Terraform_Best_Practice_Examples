# Learn Terraform
Contains terraform scripts used for learning the Terraform Associate exam.

## Topics:



5. Terraform Cloud - Features and test config run screenshots. Contains `backend` code blocks
6. [Sentinel](./6%20-%20sentinel%20policies/) - Policy as a code (ex. enfore tagging resources, restrict public storage accounts, etc.)
7. [Packer](./7%20-%20packer/) - VM Image builder tool: can use config management tools like Shell, Ansible, Chef, etc. alongside. Also contains `lifecycle`, `terraform import` examples to build an apache http server
8. Vault - Terraform Secret Server deployment process and usage in code.
<details>
<summary>Labs - Click here</summary>

- [Auto-scaling Web server deployment fronted by Application Load Balancer](./9%20-%20lab/1%20-%20web%20server%20asg%20with%20elb/)
- [Private EC2 Instance with a jump server and a NAT Gateway](./9%20-%20lab/2%20-%20ec2%20with%20jump%20server%20(nat%20gateway)/)

</details>

## Useful items:

1. **Statefile Backup**: 
    - If stored _**locally**_, the `tfstate.backup` file contains the previous terraform apply results. 
    - if storing in a _**remote backend**_, make sure to enable versioning to be able to roll back..


2. **[Import Real-world resources](https://developer.hashicorp.com/terraform/language/import)**:
  _2.1. How to import a resource configuration for managing via terraform_
   - Step-1: Create an empty resource block in the terraform file 
    ```hcl
        resource "aws_security_group" "to_be_imported" {
        # fill later after import
        }
    ```
    - Step-2: Run `terraform import <resource_type>.<resource_name> <resource_id>` (For example, aws_security_group.example sg-12345)
    - Step-3: After the configurations get imported into your state file, run `terraform show` or `terraform state show <resource_type>.<resource_name>`
    - Step-4: Clean up the output-only attributes like `id`, `arn`, `timestamp`, etc. and add the code block the terraform configuration file.

> Other options: For bulk import of resources, you can use tools like `terraformer` & `terracognita`

3. **Avoid Resource modification/deletion (useful for imported/critical resources)**:
    - Option-1: Add a lifecycle block to your code:
        ```hcl
        lifecycle {
            ignore_changes = [cidr_block] # or any specific resource config
            prevent_destroy = true
        }
        ```
    - Option-2: Manually remove the resource configuration from the state file.
        ```sh
            terraform state rm aws_instance.example
        ```

4. **[Schematize/Validate Input variables:](https://developer.hashicorp.com/terraform/language/values/)** Use `validation` block
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

6. Instructions before refactoring existing code:
    - Modifying the names of the existing resource/module block may trigger changes causing downtime. So, follow appropriate procedures to _move_ the statefile resource configurations using one of below mentioned steps:
    1. State move command: 
    ```sh
    terraform state mv <OLD_BLOCK_REFEERENCE> <NEW_REFERENCE>
    ```
    2. Use moved block:
    ```hcl
    moved {
        from = aws_instance.something
        to = aws_instance.myserver
    }
    ```

### Useful Supporting tools

1. [Gruntwork](https://docs.gruntwork.io/library/reference/) - Contains battle-tested codes for different use cases.
2. Terrascan
3. Terratest
4. Terraformer & Terracognita - To handle bulk import of existing resource configuration
5. 