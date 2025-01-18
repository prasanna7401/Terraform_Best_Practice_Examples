Here, the provider configurations are provided in both the Child module (module/..) and the root module (prod/..).

Generally, it is a best practice to declare the providers in the root module, and then pass it to the child module.

- Root module (main.tf):

    ```hcl
    provider "aws" {
    region = "us-west-2"
    }

    module "my_module" {
    source = "./modules/my_module"
    # other module inputs
    }
    ```

- Child Module (modules/my_module/main.tf):

    ```hcl
    resource "aws_instance" "example" {
    ami           = "ami-123456"
    instance_type = "t2.micro"
    # other resource arguments
    }
    ```


## Path commands

- `path.module` - returns the filesystem path of the module where the expression is defined
- `path.root` - returns path of the root module
- `path.cwd` - returns the path of the current working directory


- How to handle Inline blocks inside a resource block?
    Certain providers will provide some dedicated resource block for the inline blocks in certain resources. Example, you can add rules to a security group both as an inline block and as a separate resource.

## Module versioning

If the modules are stored in a version control system, you can make use of specific versions of your code. In this scenario, it is recommended to use a separate git repository for modules. 

Note: To easen the work, by avoiding repeated provider and backend configurations, use **terragrunt**. This tool is also helpful in avoiding the burden of running the `init` and `apply` commands at each directory path.
