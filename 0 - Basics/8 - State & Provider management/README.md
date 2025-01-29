## Statefile management Commands:

- `terraform state list`: To display managed resource name
- `terraform state pull`: Pull your remote state file and view as output
- `terraform show`: View the local state file contents.
- `terraform push`: Push your local state file to remote.
- `terraform state rm <resource_id>`: Unmanage the specified resource
- `terraform state replace_provider <old_provider> <new_custom_provider>`: To update your provider.

## Provider Commands and tips:

- `terraform init -upgrade`
- `terraform get`: To update the modules with the remote changes
- `terraform init -get_plugins-false`
- `terraform init -plugin-dir=PATH`

**Lock files**
- `.terraform.lock.hcl`: Dependency lock file
- `.terraform.tfstate.lock.hcl`: State lock file