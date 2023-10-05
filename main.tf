terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kubernetes_persistent_volumes_running_out_of_storage_space" {
  source    = "./modules/kubernetes_persistent_volumes_running_out_of_storage_space"

  providers = {
    shoreline = shoreline
  }
}