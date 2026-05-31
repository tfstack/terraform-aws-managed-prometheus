# Basic AMP Example

This example demonstrates a practical baseline for the module:

- Creates an AMP workspace
- Applies workspace retention settings
- Adds an Alert Manager definition
- Creates one rule group namespace
- Creates a resource policy that includes default Amazon Managed Grafana query access

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Notes

- This example creates billable AMP resources.
- Run `terraform destroy` when you are done testing to avoid ongoing charges.
