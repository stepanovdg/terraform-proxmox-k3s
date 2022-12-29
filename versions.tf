terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
    }

    macaddress = {
      source  = "ivoronin/macaddress"
      version = "0.3.0"
    }
  }

  experiments = [module_variable_optional_attrs]
}

locals {
  authorized_keyfile = "authorized_keys"
}
