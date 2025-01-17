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