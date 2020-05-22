## Module 2: Getting Terraform Up and Running

### Installing Terraform executable on PC

##### Manual

Navigate to the [Terraform download page](https://www.terraform.io/downloads.html). Download the Terraform binary for Windows.

Unzip and save `terraform.exe` to a folder. Add the Terraform folder to the PATH environment variable. You can do this in PowerShell by using the following command:

```
setx PATH "$env:path;C:\Terraform" -m
```
Verify that Terraform is installed:
```
PS C:\WINDOWS\system32> terraform version
Terraform v0.12.20

Your version of Terraform is out of date! The latest version
is 0.12.25. You can update by downloading from https://www.terraform.io/downloads.html
```


##### Chocolatey

Install with Chocolatey by running the following command:
```
choco install terraform
```
>**Note:** The Chocolatey package for Terraform is not maintained by HachiCorp. To ensure that your getting the latest version, perform a manual installation.

Verify that Terraform is installed:
```
PS C:\WINDOWS\system32> terraform version
Terraform v0.12.20

Your version of Terraform is out of date! The latest version
is 0.12.25. You can update by downloading from https://www.terraform.io/downloads.html
```
##### Using Terraform in Azure CloudShell

