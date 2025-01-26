**Custom providers**
```hcl
terraform {
    <LOCAL_NAME> = {
        source = "<URL>"
        version = "<VERSION>"
    }
}
```

**How to configure `required_providers {}` in a multi-provider setup with modules?**

- Setting up duplicate provider blocks in all modules, would increase the number of API calls and could easily cause performance issues (Imagine a setup with 100+ accounts working in 25+ regions).
- Best practice: Never declare provider configurations in the reusable child module, but always allow the user to set it up at the root module using _configuration_aliases_ attribute.
    ```hcl
    terraform {
        required_providers {
            aws = {
                source = "hashicorp/aws"
                version = "~> 5.0"
                configuration_aliases = [aws.prod, aws.dev] # DECLARE Provider aliases
            }
        }
    }
    ```

