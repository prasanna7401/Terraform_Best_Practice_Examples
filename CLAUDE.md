# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Educational/reference repository demonstrating Terraform best practices — from basics through production patterns. Based on "Terraform: Up and Running" by Yevgeniy Brikman. Not a deployable project; each numbered directory is a standalone example.

## Structure

Numbered directories follow a progressive learning path:

| Directory | Topic |
|-----------|-------|
| `0 - Basics/` | Variables, imports, data sources, complex types, functions, conditionals, provisioners, state management |
| `01 - Isolate environments...` | Environment isolation via folder structure and workspaces, S3 remote state with DynamoDB locking |
| `02 - Modules/` | Reusable modules with prod/stage consumers (`modules/` → `prod/` & `stage/`) |
| `03 - Zero-downtime...` | Blue-green and rolling deployments using conditionals & loops |
| `04 - Multi-provider...` | Multi-region (RDS replicas), multi-account (cross-account IAM), multi-provider (EKS + K8s) |
| `05 - Production Use cases/` | Input validation, version pinning, repo structuring |
| `06 - Terraform Test/` | Built-in `terraform test` (.tftest.hcl) + Terratest (Go): unit, integration, OPA, and mock-based tests |
| `07 - Terraform cloud/` | Remote execution and state in TFC |
| `08 - Sentinel/` | Policy-as-code enforcement rules |
| `09 - Packer/` | AMI building with HCL2 |
| `10 - Vault/` | Secret management integration |
| `11 - Terragrunt/` | DRY backend config, `run-all` workflows |
| `Other Labs/` | Standalone practical labs (ASG + ALB) |

## Key Patterns

- **Environment isolation**: Two approaches shown — folder-based (`01/.../folder-splitup/`) and workspace-based (`01/.../workspaces-splitup/`)
- **Module consumption**: Modules defined in `modules/` directory, consumed by `prod/` and `stage/` with different variable values
- **Remote state references**: `terraform_remote_state` data source to share outputs across deployments
- **Provider aliases**: Used for multi-region and multi-account patterns in `04 - Multi-provider/`
- **Terragrunt hierarchy**: `root.hcl` → environment-level `terragrunt.hcl` → component-level `terragrunt.hcl`

## Running Tests

### Built-in Terraform Tests

Tests live in `06 - Terraform Test/1 - Built-in/`. Mock-based tests need no AWS credentials:

```bash
cd "06 - Terraform Test/1 - Built-in/1 - basics/s3-bucket"
terraform init
terraform test
```

### Terratest (Go Tests)

Tests live in `06 - Terraform Test/2 - Terratest with Go/`. No root-level go.mod exists — each test directory needs its own:

```bash
cd "06 - Terraform Test/2 - Terratest with Go/1 - Unit testing"
go mod init test
go mod tidy
go test -v -timeout 30m
```

Test files: `alb_test.go`, `webapp_test.go`, `my_app-integration.go`, `sample_test.go`

## Terraform Versions

- Terraform: `>= 1.0.0` (built-in tests require `>= 1.7.0`)
- AWS provider: `~> 5.0`
- Packer amazon plugin: `>= 1.0.0`

## CI/CD

- `.github/workflows/pr_label.yml`: Auto-labels PRs — "Documentation" for .md changes, "code update" for .tf/.hcl changes
- `.github/labeler.yml`: Label rules config

## Conventions

- Each example directory is self-contained with its own `providers.tf`, `variables.tf`, `outputs.tf`
- User data scripts are `.sh` or `.tpl` files alongside Terraform configs
- Sentinel policies use helper functions from `tfplan-functions.sentinel`
- No centralized backend — each example can use its own state configuration
