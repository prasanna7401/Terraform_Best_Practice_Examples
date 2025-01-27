Notes:
- `condition` :
    - can ONLY reference the surrounding input variable.
    - added to `variable{}` block.
    - Useful for basic input sanitization (static checks).

- `precondition`:
    - to run checks before `apply` step.
    - added to `lifecycle{}` block.

- `postcondition`:
    - to run checks after `apply` step.
    - added to `lifecycle{}` block.

---
---

- `self.<ATTRIBUTE>`:
    - This can be used only in `postcondition{}`, `connection{}`, `provisioner{}` blocks
    - Because, the resources cannot reference to themselves.