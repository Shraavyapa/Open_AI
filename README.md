# Azure OpenAI Monitoring Infrastructure

This Terraform configuration deploys an Azure OpenAI service with comprehensive monitoring, logging, and alerting capabilities.

## Resources Created

| Resource | Name | Description |
|----------|------|-------------|
| Azure OpenAI Account | `fileon` | Cognitive Services account (OpenAI kind) with S0 SKU |
| Log Analytics Workspace | `fileon-law` | Centralized logging with 30-day retention |
| Diagnostic Settings | `fileon-diagnostics` | Routes OpenAI logs/metrics to Log Analytics |
| Action Group | `file-action-group` | Email notification group |
| Metric Alert | `fileon-openai-alert` | Alerts when token usage exceeds threshold |

## Prerequisites

- Azure CLI installed and authenticated
- Terraform >= 1.0
- Azure subscription with permissions to create resources
- Existing resource group: `rg-cp-shraavya-pa`

## Configuration

Update these values in `main.tf` before deployment:

```hcl
subscription_id       = "your-subscription-id"
resource_group_name   = "your-resource-group"
email_address         = "your-email@example.com"
```

## Alert Configuration

The metric alert monitors **TotalTokens** usage:
- **Threshold**: 100 tokens
- **Window**: 5 minutes
- **Frequency**: Evaluated every 1 minute
- **Severity**: 2 (Warning)

## Usage

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply configuration
terraform apply

# Destroy resources
terraform destroy
```

## Logs Collected

- **Audit** - Security and administrative events
- **RequestResponse** - API request and response details
- **AllMetrics** - Performance and usage metrics

## Tags

All resources are tagged with:
- `environment`: file/prod

