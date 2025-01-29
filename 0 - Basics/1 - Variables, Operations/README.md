You can set up variables using the default `terraform.tfvars` file, or any `.tfvars` file, or as environmental variable in format `TF_VAR_something=valueofsomething`

Example run:

```hcl
> var.name
---
 prasanna
```

For loop:
```hcl
[for game in var.games: game]
---
```

Maps:
```hcl
 > var.game_map["god of war"]
 norse
```
Splat:
```hcl
var.games[*]
---
 [
   "ghost of tsushima",
   "god of war",
   "uncharted 4",
 ]
```
- More examples on splat:
  - You could use splat to shorten longer expressions like `[for item in var.list: item.properties[0].name]` as  `var[*].properties[0].name`

**Notes**:
- String Templates:
  - Interpolation: `something = "Hello, ${var.name}"`
  - Directives using conditionals: `something = "Hello, %{if var.name == null} No name %{else} ${var.name}%{endif}"`
