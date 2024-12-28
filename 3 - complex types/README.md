Map:
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

List:
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


String functions:
```hcl
[for planet in var.planets: upper(planet)]
---
[
  "MERCURY",
  "VENUS",
  "EARTH",
  "MARS",
  "JUPITER",
  "SATURN",
  "URANUS",
  "NEPTUNE",
]
```

Tuple (variable type controlled)
```hcl
var.random
---
[
  "Hello",
  42,
  false,
]
```