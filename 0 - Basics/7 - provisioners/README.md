Provisioners:

- `local-exec` - Runs command in the machine running terraform
- `remote-exec` - Runs command in the remote instance
- `file` - copies files to remote instance
- `connection` - to connect to the instance using a specified protocol

Other options in Provisioner:

- `null_resource` - 
    -  Use this to run provisioner block without creating any resource,.
    - this has an argument called `triggers` to trigger the block execution based on any attribute change. For example, if we want the provisioner block to run at every apply, we can use the `uuid`.
    ```hcl
    resource "null_resource" "something" {
        triggers = {
            uuid = uuid() # unique for every apply run
        }

        provisioner "remote_exec" {
            command = "echo 'This code was run on $(date)'"

        }
    }
    ```

- If you set `when = destroy` in the provisioner block, it will become a **destroy-time** provisioner. But default, they are create-time provisioner. So, we can make a specific provisioner block to be run based on the action. In this case, the block will run after `terraform destroy`.

- If you set up `onfailure = continue` in the provisioner block, even in case of error, terraform will continue to run.

For sample use-case: [Click here](../../Other%20Labs/2%20-%20ec2%20with%20jump%20server%20(nat%20gateway)/)