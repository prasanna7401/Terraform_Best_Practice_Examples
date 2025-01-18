Loops - Basics:
- `count`
    ```hcl
        resource "aws_something" "example" {
            count = 3 
            # or
            # count = var.workspace == "prod" ? 3 : 1 
            # count = length(var.device_names) 
            name = "somename-${count.index}"
            # name = var.device_names[count.index]
        }
    ```
    When to use: Only to create multiple instances of a resource with same lifecycle and attributes
- `for_each`
- `for` expressions
- `for` string directive