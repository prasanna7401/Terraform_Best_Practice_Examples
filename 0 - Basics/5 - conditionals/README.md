- **if** directive:
    - Syntax: `%{ if <CONDITION> } <TRUE_VAL> %{ else } <FALSE_VAL> %{ endif }`

- **for** expressions
    ```hcl
    # SYNTAX - for <ITEM> in <LIST>: <OUTPUT>
    user_name = [for user_info in users: use_info.name]
    ```
    - Use to loop over lists, maps, etc.
- **for** string directive
    - Syntax: `%{ for <INDEX>, <ITEM> in <COLLECTION> } <BODY> %{ endfor }` 
    - Uses `%{}` to have loop statements within a string. Helpful in output statements.
    - Normally, when you have a single value, you use `${}`. For example, `"Hello ${var.name}"`
    ```hcl
        output "user_name" {
            value = "%{ for name in var.names } ${name}, %{ endfor }"
        }
    ```
    - If you would like to remove the extra space, comma being printed, you can use _if string_ directive along with _strip_ markers. For example,
    ```hcl
    output "usernames" {
        value = <<EOF
        %{~ for i, name in var.names ~ }
        ${name} %{ if i < length(var.names)-1 }, %{ endif }
        %{~ endfor ~}
        EOF
    }
    ```