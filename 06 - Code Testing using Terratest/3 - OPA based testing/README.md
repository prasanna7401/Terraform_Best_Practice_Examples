**Steps to detect violations using OPA**
1. Generate the plan output as json
```sh
terraform plan -out tfplan
terraform show -json tfplan > tfplan.json
```

2. Run the _opa eval_ command against the _rego_ file.
```sh
opa eval --data enforce_tagging.rego \
    --input tfplan.json \
    --format pretty \
    data.terraform.allow
```
- If output is `undefined`: Policy violation
- If output is `true`: Adheres to policy
