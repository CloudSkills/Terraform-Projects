module "consul" {
  source  = "hashicorp/consul/azure"
  version = "0.0.5"

  servers = 3
}