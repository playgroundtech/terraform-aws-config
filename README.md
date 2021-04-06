# Terraform Module Title

Description

**Included features:**

- list

## Provisional Instructions

IMPORTANT: When refering to this module in your deployment you should pin to a release tag (e.g. ?ref=vX.Y.Z) since the
`master` branch may introduce unreleased breaking changes.

```
module "" {
  source = "git@github.com:playgroundcloud/<repository>.git?ref=vX.Y.Z"
  ***
}
```

Find more examples on how to use this module in [test](./test) directory.

### Variables:

- `variable` | (Required/Optional) - String/Number/Bool/Map/List/Object  
  Description of the variable  
  Default: `default value`

#### Grouped Variables

- `group_variable` | (Required/Optional) - String/Number/Bool/Map/List/Object  
  Description of the variable  
  Default: `default value`

- `group_variable_map` | (Required/Optional) - Map/Object  
  Description of the variable  
  Default: `default value`

---

The `group_variable_map` block supports the following attributes.

- `argument`: (Required/Optional) - String/Number/Bool/Map/List/Object  
   Description of the argument.

---

### Outputs

- `output`
