terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = "${{ secrets.DIGITALOCEAN_ACCESS_TOKEN }}"
}

resource "digitalocean_kubernetes_cluster" "imersao" {
  name    = "imersao"
  region  = "nyc1"
  version = "1.31.1-do.4"

  node_pool {
    name       = "autoscale-worker-pool"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
  }
}

resource "local_file" "kube_config" {
  content  = digitalocean_kubernetes_cluster.imersao.kube_config.0.raw_config
  filename = "kube_config.yaml"
}