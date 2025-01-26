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