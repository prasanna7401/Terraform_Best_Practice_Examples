Terraform Cloud - Features and test config run screenshots. Contains `backend` code blocks

**Backend Setup when using Terraform Cloud Workspaces**

```hcl
terraform {
    cloud {
        organization = "<your-org>"
        # hostname = "app.terraform.io"
        workspaces {
            # tags = ["my-company"] # shows a list of workspaces with this tag
            # name = "prod" # targets your run in specific workspace
            # prefix = "my-" # show a list of workspaces with this prefix
        }
    }
}
```

- In this case, all workspaces 



Note:
1. Cost estimation is supported only for limited resources