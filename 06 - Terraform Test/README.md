# Terraform Testing

This section covers two approaches to testing Terraform configurations: the built-in `terraform test` framework and Go-based Terratest.

## Approaches

| Feature | Built-in (`terraform test`) | Terratest (Go) |
|---------|----------------------------|----------------|
| **Language** | HCL (`.tftest.hcl`) | Go |
| **Setup** | None — ships with Terraform >= 1.6 | Go toolchain + test dependencies |
| **Speed** | Fast — plan-mode tests run in seconds | Slower — compiles Go, manages real resources |
| **Mocking** | Native (`mock_provider`, `override_resource/data`) | Manual or helper libraries |
| **Best for** | Input validation, plan assertions, unit tests | Integration tests, HTTP checks, multi-step workflows |
| **CI/CD output** | `-json`, `-junit-xml` | Standard Go test output |
| **AWS credentials** | Not needed for mock-based tests | Required for most tests |

## When to Use Which

- **Built-in tests** — fast feedback on variable validation, resource configuration, tagging, and module composition. Start here for most unit-level testing.
- **Terratest** — end-to-end validation that provisions real infrastructure and runs assertions against it (HTTP responses, DNS, database connectivity). Use when you need to verify actual cloud behavior.
- **Both together** — mock-based built-in tests in CI for every PR (fast, free), Terratest integration tests on a schedule or before releases (thorough, costly).

## Directory Layout

```
06 - Terraform Test/
├── 1 - Built-in/          # terraform test framework (.tftest.hcl)
│   ├── 1 - basics/
│   ├── 2 - mocking-and-overrides/
│   ├── 3 - multi-resource-and-composition/
│   └── 4 - production-patterns/
│
└── 2 - Terratest with Go/  # Go-based testing with Terratest library
    ├── 1 - Unit testing/
    ├── 2 - Integration testing/
    ├── 3 - OPA based testing/
    ├── examples/
    ├── live/
    └── modules/
```

## Quick Start

### Built-in Tests

```bash
cd "06 - Terraform Test/1 - Built-in/1 - basics/s3-bucket"
terraform init
terraform test
```

### Terratest

```bash
cd "06 - Terraform Test/2 - Terratest with Go/1 - Unit testing"
go mod init test
go mod tidy
go test -v -timeout 30m
```
