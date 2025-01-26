File operations

1. **Pass variables into a templated file**:
    - main.tf
    ```hcl
    
    resource "aws_ec2_instance" "myserver" {
        # ... configs ...
        user_data = templatefile("{path.module}/user_data.sh", {
            name = var.name
            age = var.age
        })
    }
    ```
    - user_data.sh
    ```sh
    #!/bin/bash
    
    cat > index.html <<EOF
    <h1> My name is ${name} </h1>
    <p> I am ${age} years old </p>
    ```

