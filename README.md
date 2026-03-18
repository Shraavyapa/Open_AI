# Azure OpenAI Infrastructure & Client

This project provisions Azure OpenAI resources using Terraform and includes a Python client to interact with the deployed service.

## Architecture

- **Azure OpenAI Cognitive Services Account** - GPT-4 deployment
- **Log Analytics Workspace** - Centralized logging and monitoring
- **Diagnostic Settings** - Audit logs and request/response tracking
- **Metric Alerts** - Token usage monitoring with email notifications

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Python 3.8+
- An Azure subscription

## Setup

### 1. Deploy Infrastructure

```bash
# Login to Azure
az login

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy resources
terraform apply
```

### 2. Configure Environment Variables

After deployment, set the required environment variables:

```bash
# PowerShell
$env:AZURE_OPENAI_API_KEY = "your-api-key"
$env:AZURE_OPENAI_ENDPOINT = "https://file123.openai.azure.com"

# Bash
export AZURE_OPENAI_API_KEY="your-api-key"
export AZURE_OPENAI_ENDPOINT="https://file123.openai.azure.com"
```

### 3. Install Python Dependencies

```bash
pip install openai
```

### 4. Run the Client

```bash
python alert.py
```

## Project Structure

```
├── main.tf              # Terraform infrastructure configuration
├── alert.py             # Python client for Azure OpenAI
├── .gitignore           # Git ignore rules
└── README.md            # This file
```

## Resources Created

| Resource | Name | Purpose |
|----------|------|---------|
| Cognitive Account | fileon | Azure OpenAI service |
| Log Analytics | fileon-law | Logging and diagnostics |
| Action Group | file-action-group | Alert notifications |
| Metric Alert | fileon-openai-alert | Token usage monitoring |

## Security Notes

- API keys are loaded from environment variables (never commit secrets)
- Terraform state files are excluded from version control
- Network ACLs are configured on the OpenAI resource

## License

Private project.
