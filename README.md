# ACI Module - Easy ACI

## Use Cases

* Deploy New ACI Fabrics using Terraform or Add to an existing Fabric.

### Access Policies - modules/access

* Domains
  * Access Domains
  * l3Out Domains
  * Physical Domains

* Global Polices
  * Attachable Access Entity (AEP) Policies
  * Error Disable Recovery
  * MCP Instance Policy
  * QoS Class

* Interface Policies
  * CDP Interface
  * Fibre-Channel Interface
  * L2 Interface
  * Link Level
  * LLDP Interface
  * MisCabling Protocol (MCP) Interface
  * Port-Channel Interface
  * Port Security
  * Spanning Tree Interface

* Leaf
  * Interface Policy Groups (Access/VPC/PC)
  * Switch Policy Groups

* Spine
  * Interface Policy Groups
  * Switch Policy Groups

* VLAN Pools

### Admin Policies - modules/admin

* Authentication Settings
* Configuration backups (Schedulers|Import/Export Policies)
* Firmware/Maintenance Groups
* Global Security Settings
* RADIUS
* TACACS+

### Fabric Policies - modules/fabric

* Date and Time
* DNS Profiles
* Fabric Node Controls
* L3 Interface
* Pod Profiles
* Smart CallHome
* SNMP Policies
* Syslog Policies

### Switches - module/switch

* Fabric Membership
* Interface Policy Groups (Access/VPC/PC)
* Interface Profiles
* Interface Selectors
* Switch Profiles

### Tenants - module/tenants

* Bridge Domains

### Pre-requisites and Guidelines

1. Run the Intial Configuration wizard on the APICs.

2. Sign up for a TFCB (Terraform for Cloud Business) at <https://app.terraform.io/>. Log in and generate the User API Key. You will need this when you create the TF Cloud Target in Intersight.  If not a paid version, you will need to enable the trial account.

3. Clone this repository to your own VCS Repository for the VCS Integration with Terraform Cloud.

4. Integrate your VCS Repository into the TFCB Orgnization following these instructions: <https://www.terraform.io/docs/cloud/vcs/index.html>.  Be sure to copy the OAth Token which you will use later on for Workspace provisioning.

## VERY IMPORTANT NOTE: The Terraform Cloud provider stores terraform state in plain text.  Do not remove the .gitignore that is protecting you from uploading the state files to a public repository in this base directory.  The rest of the modules don't have this same risk

## Obtain tokens and keys

### Terraform Cloud Variables

* terraform_cloud_token

  instructions: <https://www.terraform.io/docs/cloud/users-teams-organizations/api-tokens.html>

* tfc_oath_token

  instructions: <https://www.terraform.io/docs/cloud/vcs/index.html>

* tfc_organization (TFCB Organization Name)
* tfc_email (Must be an Email Assigned to the TFCB Account)
* agent_pool (The Name of the Agent Pool in the TFCB Account)
* vcs_repo (The Name of your Version Control Repository. i.e. CiscoDevNet/intersight-tfb-iks)

### APIC Variables

* apicHostname - Hostname for the APIC.
* apicUser

Note: for Remote Credentials use the following format: "apic:{login_domain}\\\\{user}"

For Certificate based Authentication

* privateKey
* certName

For User Based Authentication

* apicPass - User Password

### Nexus Dashboard Orchestrator Variables

For User Based Authentication

* ndoDomain - Login Domain for the User - Default is local.
* ndoHostname - Hostname for the Nexus Dashboard Orchestrator.
* ndoPass - NDO User Password.
* ndoUser - NDO User.

### Import the Variables into your Environment before Running the Terraform Cloud Provider module(s) in this directory

In the Examples folder is a file Empty_variable_maps.auto.tfvars.  Copy this into the Directory for the module.  Then remove any variables you plan to define and create a {variable}.auto.tfvars for each of the variables you want to use in the module.  For example to create a cdp interface policy remove the following from Empty_variable_maps.auto.tfvars:

```bash
policies_cdp_interface = {}
```

Then create a new file policies_cdp_interface.auto.tfvars and fill out the attributes for the variable from the policies_cdp_interface.tf

Once finished with the modification commit the changes to your repository.

The Following examples are for a Linux based Operating System.  Note that the TF_VAR_ prefix is used as a notification to the terraform engine that the environment variable will be consumed by terraform.

* Terraform Cloud Variables - Linux

```bash
export TF_VAR_terraform_cloud_token="your_cloud_token"
```

* Terraform Cloud Variables - Windows

```powershell
$env:TF_VAR_terraform_cloud_token="your_cloud_token"
```

### APIC/MSO Credentials

* Certificate Based Authentication - Linux

```bash
export TF_VAR_apicUser="{apic_username}"
export TF_VAR_certName="{name_of_certificate_associated_to_the_user}"
export TF_VAR_privateKey=`~/Downloads/apic_private_key.txt`
```

* Certificate Based Authentication - Windows

```powershell
$env:TF_VAR_apicUser="{apic_username}"
$env:TF_VAR_certName="{name_of_certificate_associated_to_the_user}"
$env:TF_VAR_privateKey="$HOME\Downloads\apic_private_key.txt"
```

* User Based Authentication - Linux

```bash
export TF_VAR_apicUser="{apic_username}"
export TF_VAR_apicPass="{user_password}"
export TF_VAR_ndoUser="{ndo_username}"
export TF_VAR_ndoPass="{user_password}"
```

* User Based Authentication - Windows

```powershell
$env:TF_VAR_apicUser="{apic_username}"
$env:TF_VAR_apicPass="{user_password}"
$env:TF_VAR_ndoUser="{ndo_username}"
$env:TF_VAR_ndoPass="{user_password}"
```

## Execute the Terraform Plan

### Terraform Cloud

When running in Terraform Cloud with VCS Integration the first Plan will need to be run from the UI but subsiqent runs should trigger automatically

### Terraform CLI

* Execute the Plan - Linux

```bash
# First time execution requires initialization.  Not needed on subsequent runs.
# terraform init
terraform plan -out="main.plan"
terraform apply "main.plan"
```

* Execute the Plan - Windows

```powershell
# First time execution requires initialization.  Not needed on subsequent runs.
# terraform.exe init
terraform.exe plan -out="main.plan"
terraform.exe apply "main.plan"
```

When run, this module will Create the Terraform Cloud Workspace(s) and Assign the Variables to the workspace(s).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
