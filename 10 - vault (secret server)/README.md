Vault - Terraform Secret Server deployment process and usage in code.

Uses:
- You can the Vault server to store important key-value pairs in a server and reference it as a backend in your configuration code.
- As a good practice, regularly take snapshots of your vault.

Vault installation steps:
- Install Vault in your local machine (in developer mode)
```sh
vault server -dev -dev-root-token-id="learning"
```
- open in your browser and go to http://127.0.0.1:8200
- Enter your token (`learning` in this case).
- If you plan on using CLI for managing secrets, export the URL as your environmental variable.
- Add your Secrets by clicking on `Secrets Engine` > `secrets` > Create secret
  or
  Using CLI, enter `vault kv put secret/aws hello=world`
![Sample secret in Vault](./Screenshots/1%20-%20Create%20secret.jpg)
- Fetch secrets using cli by entering `vault kv get secret/aws`