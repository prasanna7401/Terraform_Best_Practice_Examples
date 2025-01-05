# Learn Terraform
Contains terraform scripts used for learning the Terraform Associate exam.

## Topics:

1. [Variables and operations](https://developer.hashicorp.com/terraform/language/values): `for_each`, `splat` & basics
2. [Expressions](https://developer.hashicorp.com/terraform/language/expressions): `dynamic` block, `data` source, `terraform import`.
3. Complex types - Collections (`list`, `set`, `map`) and Structural (`object`, `tuple`)
4. [Built-in functions](https://developer.hashicorp.com/terraform/language/functions/): Numeric, String, Collection(list, tuple, set, map), Encoding/decoding, Filesystem, Datetime, IP network, Hash, and Type conversion functions.
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

1. **State BACKUP:** You can always find the `tfstate.backup` file containing the previous terraform apply results.

2. **FIND Resource Attributes**: Use `terraform state show <resource_name>` to show all available outputs of a created resource.

3. **[IMPORT Real-world resources](https://developer.hashicorp.com/terraform/language/import)**:
  _3.1. How to import a resource configuration for managing via terraform_
   - Step-1: Create an empty resource block in the terraform file 
    ```hcl
        resource "aws_security_group" "to_be_imported" {
        # fill later after import
        }
    ```
    - Step-2: Run `terraform import <resource_type>.<resource_name> <resource_id>` (For example, aws_security_group.example sg-12345)
    - Step-3: After the configurations get imported into your state file, run `terraform show` or `terraform state show <resource_type>.<resource_name>`
    - Step-4: Clean up the output-only attributes like `id`, `arn`, `timestamp`, etc. and add the code block the terraform configuration file.

4. **Avoid Resource modification/deletion (useful for imported/critical resources)**:
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

5. **[Schematize/Validate Input variables:](https://developer.hashicorp.com/terraform/language/values/)** Use `object` structural type to enfore schema to the variable. For example: 
   ```hcl
   variable <name> {
     type = object({
         name = string
         age = number
         })
     default = {
         ...
     }
   }
   ```

6. Isolating environments (based on environments and resource lifecycle): An example for AWS Infrastructure is shown below
<img src="https://miro.medium.com/v2/resize:fit:1100/format:webp/1*L9BTyj0M9j7ANsXeyFOctw.png" width="656">
<sub><sup>Source: Y. Brikman, "_Terraform Up and Running_," 3rd ed. O'Reilly Media, 2022, ch. 3.</sup></sub>

### Useful tools

1. [Gruntwork](https://docs.gruntwork.io/library/reference/) - Contains battle-tested codes for different use cases.