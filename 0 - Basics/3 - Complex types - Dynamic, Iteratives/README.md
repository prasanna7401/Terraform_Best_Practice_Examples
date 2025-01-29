**dynamic** block:
 - Can use to parse through a **_list of arrays_**.
 - For example,
 ```hcl
 locals {
  ingress_rules = [
    {
      port = 443
      description = "https"
    },
    {
      port = 80
      description = "http"
    },
  ]
 }

  ### Parse using `dynamic` and `for_each` combination

  resource "aws_something" "example" {
    name = var.name
    # normally, you mention
    # rule { ... }
    # rule { ... }
    # rule { ... }

    # Instead, you mention
    dynamic "rule" {
      for_each = local.ingress_rules
      content {
        port = rule.value.port # note that it is parsing value of rule now
        description = rule.value.description
        protocol = "tcp"
      }
    }

  }
 ```

## Complex types

**Map**:
```hcl
var.plans
---
tomap({
  "Basic" = 25
  "Premium" = 100
  "Standard" = 50
})
```

Map element values:
```hcl
var.plans["Premium"]
100
```

**List**:
```hcl
var.planets
---
tolist([
  "Mercury",
  "Venus",
  "Earth",
  "Mars",
  "Jupiter",
  "Saturn",
  "Uranus",
  "Neptune",
])
```
List element based on index:
```hcl
var.planets[3]
"Mars"
```

**Set**: Contains elements of same type (ordered)
```hcl
toset(["a","b",3])
> ["a","b","3"]
```

**Tuple** (variable type controlled):
```hcl
var.random
---
[
  "Hello", # string
  42, # number
  false, # bool
]
```

## Structural Type (schematized)

**Object**:
```hcl
variable "something" {
  type = object(
    {
      name = string
      age = number
    }
  )
}
```

**Tuple**:
```hcl
variable "something" {
  type = tuple([string, number, bool])
}
```