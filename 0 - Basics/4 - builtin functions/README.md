### More Function Types
- Numeric functions
- String functions
- Collection functions
- Encoding & Decoding functions
- Filesystem functions
- Datetime functions
- Hashing & Crypto functions
- IP Network functions
- Type conversion functions
- Random functions

**Absolute Path**
  ```hcl
  abspath(path.root)
  ---
  "C:/Users/prasa/OneDrive/Desktop/DevOps/Terraform/Terrraform lab/Learn_Terraform/4 - builtin functions"
  ```
**Chomp**: Trim newline character
  ```hcl
  chomp(var.some_value)
  ---
  <<EOT
  Hello, World!

  EOT
  ```
**Trim Space**: Trim extra spaces at start and end.
```hcl
trimspace(var.some_value)
---
"Hello, World!"
```

```hcl
split(" ",trimspace(var.some_value))
---
tolist([
  "Hello,",
  "World!",
])
```

```hcl
bcrypt("Prasanna")
---
"$2a$10$0ntt/bHJpCywBrzfKwypwuTG6rI.7GASu7EURgrJ5PvrJQ7qAoMqG"
```
```hcl
base64encode("Prasanna")
---
"UHJhc2FubmE="
```

```hcl
keys(var.students)
---
tolist([
  "Alice",
  "Bob",
  "Charlie",
])
```
```hcl
values(var.students)
---
tolist([
  20,
  21,
  22,
])
```

```hcl
sort([54,234,678,234,67,23])
---
tolist([
  "23",
  "234",
  "234",
  "54",
  "67",
  "678",
])
```

## More

- jsondecode
- templatefile
- urlencode