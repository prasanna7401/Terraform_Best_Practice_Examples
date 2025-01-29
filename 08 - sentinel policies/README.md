[Sentinel](./6%20-%20sentinel%20policies/) - Policy as a code (ex. enfore tagging resources, restrict public storage accounts, etc.).

This set up needs an upgraded plan to perform (teams or organization plan).

Reference: https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/policy-quickstart

You can either have the sentinel policy sets in your code base, or directly in your Terraform cloud workspace/ organization policy settings.

- If you want to run using CLI, then form a CLI/API connection first.
- Else, if your code is stored in a VCS (github.com), then form a connection to the repository from Policy settings.