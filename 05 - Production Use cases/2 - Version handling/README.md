## Manage Terraform Core version

**Tool: tfenv**
    - Can also look for `.terraform-version` files in parent/child folders.

**Use-case**:
- Use different versions across environments for testing purposes

Commands:

- To install specific version of terraform
```sh 
tfenv install <VERSION_NUMBER>
```

- To list all installed terraform versions
```sh
tfenv list
```

- To use a specific terraform version
```sh
tfenv use <VERSION_NUMBER>
```

## Manage Provider version

- `terraform init` may have to be re-run if the code is run in a different operating system due to varying checksum values of provider versions.