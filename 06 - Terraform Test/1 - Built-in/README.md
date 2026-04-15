# Terraform Built-in Test Framework

Terraform's native testing framework (`terraform test`) lets you write tests in HCL alongside your modules. Available since Terraform 1.6, with mocking support added in 1.7.

## Requirements

- Terraform >= 1.7.0 (for `mock_provider` support)
- AWS provider `~> 5.0` (referenced but not called in mock-based tests)
- **No AWS credentials needed** for sections 1-3 (all mock-based)

## `.tftest.hcl` File Structure

```hcl
# Provider mocking — replaces real provider with fake responses
mock_provider "aws" {
  mock_data "aws_vpc" {
    defaults = {
      id = "vpc-mock123"
    }
  }
}

# Standalone variables — apply to all runs unless overridden
variables {
  environment = "dev"
}

# Test block — each run is an independent test case
run "descriptive_test_name" {
  command = plan       # or "apply" for real resources

  # Per-run variable overrides
  variables {
    environment = "prod"
  }

  # Assertions
  assert {
    condition     = aws_instance.this.tags["Environment"] == "prod"
    error_message = "Expected prod environment tag"
  }
}

# Expected failure — validates that bad input is rejected
run "rejects_invalid_input" {
  command = plan

  variables {
    environment = "invalid"
  }

  expect_failures = [
    var.environment,
  ]
}
```

## Plan vs Apply Mode

| Mode | `command = plan` | `command = apply` |
|------|-----------------|-------------------|
| **Creates resources** | No | Yes |
| **Speed** | Seconds | Minutes |
| **Credentials needed** | No (with mocks) | Yes |
| **Best for** | Validation, config checks | End-to-end verification |

## Mocking & Overrides

| Mechanism | Scope | Use Case |
|-----------|-------|----------|
| `mock_provider` | All resources/data of a provider | Unit tests without credentials |
| `mock_data` | All instances of a data source type | Fake VPC lookups, AMI lookups |
| `mock_resource` | All instances of a resource type | Fake resource attributes |
| `override_data` | One specific data source reference | Targeted override of `data.aws_vpc.selected` |
| `override_resource` | One specific resource reference | Targeted override of `aws_instance.web` |

## Expected Failures

Test that validation rules reject bad input:

```hcl
run "rejects_bad_cidr" {
  command = plan
  variables { vpc_cidr = "not-a-cidr" }
  expect_failures = [var.vpc_cidr]
}
```

## CLI Reference

```bash
terraform test                                     # Run all tests
terraform test -verbose                            # Show all run blocks
terraform test -filter=tests/specific.tftest.hcl   # Run one test file
terraform test -json                               # JSON output
terraform test -junit-xml=results.xml              # JUnit XML for CI
terraform test -parallelism=4                      # Parallel test files
```

## Directory Layout

Tests are organized by progressive complexity:

```
1 - Built-in/
├── 1 - basics/                          # run/assert, mock_provider, variables, outputs
│   ├── s3-bucket/                       # S3 with tags and versioning
│   └── ec2-instance/                    # EC2 with AMI data source
│
├── 2 - mocking-and-overrides/           # mock_data, override_data, expect_failures
│   ├── security-group/                  # SG with VPC data source mocking
│   └── iam-role/                        # IAM with validation testing
│
├── 3 - multi-resource-and-composition/  # Multi-resource, count, state sharing
│   ├── vpc-network/                     # VPC + subnets + IGW + routes
│   └── alb/                             # ALB + listener + SG composition
│
└── 4 - production-patterns/             # Apply-mode, full stack, CI/CD
    ├── rds-database/                    # RDS with comprehensive validation
    └── web-app-stack/                   # Full VPC + SG + ALB + EC2 stack
```

## How to Run

```bash
# Pick any module directory
cd "1 - basics/s3-bucket"

# Initialize providers (downloads mock stubs)
terraform init

# Run all tests in the module
terraform test

# Run with verbose output
terraform test -verbose
```

## AWS Services Covered

S3, EC2, Security Groups, VPC, Subnets, Route Tables, Internet Gateways, IAM Roles/Policies, RDS, Application Load Balancers
