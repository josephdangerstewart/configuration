# configuration

This goal of this repository is to house all of the configuration for all of the infrastructure that hosts my various personal projects. It uses terraform to manage cloud resource orchestration, custom github actions to share deployment code, and ansible to handle configuration management for VMs (though newer projects should try to consider cheaper cloud native options). Terraform and ansible configurations are applied locally for now, but that may change in the future if I have time.

## Local setup

Follow these steps to setup a new local machine to modify and apply configurations in this project

### Prerequisites

1. Install [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. Install [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) and install Ubuntu (`wsl --install Ubuntu-22.04`)
3. Install python and [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) in WSL (as of writing, ansible only runs on linux)

### Auth config

1. Install and login to the [gcloud cli](https://cloud.google.com/sdk/gcloud#download_and_install_the)
2. Install and login to the [aws cli](https://aws.amazon.com/cli/)
3. Ensure your **public** ssh key has been added to the `ssh_keys` folder and added to all of the host vms
4. Generate a new digital ocean API token and add it to a new `secrets.auto.tfvars` file at the root of this repo like so

```hcl
digital_ocean_token = <DO_TOKEN>
```

## Commands

In `/terraform`

* Run `terraform plan` to show what changes terraform wants to make
* Run `terraform apply` to actually apply those changes
