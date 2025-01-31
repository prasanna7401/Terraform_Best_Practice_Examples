[Code reference](https://github.com/samgabrail/env0-terragrunt)

Instructions to try lab:

- Go to any one of the environment directory (say, `env/dev/`) and create a key pair with an empty passphrase:

    ```bash
    ssh-keygen -f mykey-pair
    sudo chmod 400 mykey-pair
    ```

- You can either create a new remote backend using terragrunt, or use an existing remote backend. Now, in one of the environment directory, run the following:

    ```bash
    terragrunt init
    terragrunt plan
    terragrunt apply
    ###### After confirming that it works, run
    terragrunt destroy
    ```
**Note**:
- If you don't want to run the above comments at every environment, you can use `run-all` option in terragrunt to do the work. For example, `terragrunt run-all destroy`