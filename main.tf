# module "decode_pem" {
#   source = "./modules/decode_pem"
#   client_certificate_base64 = var.ARM_CLIENT_CERTIFICATE_BASE64
# }

# resource "local_file" "client_cert" {
#   filename = "/tmp/cert.pfx"
#   content_base64  = var.certificate_pfx_base64
# }

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret = var.client_secret
  # client_certificate_password = var.password_pfx
  # client_certificate = var.certificate_pfx_base64
  
}

resource "azurerm_resource_group" "rgnolocal_update" {
  name     = "RGNNOLOCALACCOUNTS"
  location = "eastus2"

  tags = {
    Environment = "Dev"
    Department  = "Banca"
    Owner       = "Enriqueto"
  }
}


resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = "aksveu2ctpld99"
  location            = azurerm_resource_group.rgnolocal_update.location
  resource_group_name = azurerm_resource_group.rgnolocal_update.name
  dns_prefix          = "aksveu2ctpld99"

  default_node_pool {
    name       = "default"
    node_count = 1
    #   vm_size    = "Standard_D2_v2"
    vm_size = "Standard_A2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
  tags = {
    Environment = "Dev"
    Department  = "Banca"
    Owner       = "Enriqueto"
  }
}


# output "resource_group_name" {
#   value = data.azurerm_kubernetes_cluster.rgnolocal.name
# }

# output "resource_group_location" {
#   value = data.azurerm_kubernetes_cluster.rgnolocal.location
# }


provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.kubernetes_cluster.0.host
  # client_certificate     = base64decode(data.azurerm_kubernetes_cluster.kubernetes_cluster_pulled.kube_config.0.client_certificate)
  # client_key             = base64decode(data.azurerm_kubernetes_cluster.kubernetes_cluster_pulled.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.0.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "./kubelogin"
    args = [
      "get-token",
      "--environment",
      "AzurePublicCloud",
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630",
      "--client-id",
      var.client_id,
      "--client-secret",
      var.client_secret,
      "--tenant-id",
      var.tenant_id,
      "--login",
      "spn",
      "|",
      "jq",
      ".status.token"
    ]
  }

}

resource "kubernetes_cluster_role" "developer_env_desa_aks" {
  metadata {
    name = "Developer_Env_Desa_Aks_16"
  }

  rule {
    api_groups = [""]
    resources  = ["deployments", "pods", "pods/exec", "pods/log", "services"]
    verbs      = ["*"]
  }

  rule {
    api_groups = ["extensions", "apps"]
    resources  = ["deployments", "hpa", "replicasets"]
    verbs      = ["*"]
  }

  rule {
    api_groups = [
      "source.toolkit.fluxcd.io", 
      "kustomize.toolkit.fluxcd.io", 
      "helm.toolkit.fluxcd.io", 
      "notification.toolkit.fluxcd.io", 
      "image.toolkit.fluxcd.io"
    ]
    resources  = [
      "buckets", "gitrepositories", "helmcharts", "helmrepositories", "ocirepositories", 
      "kustomizations", "clusterconfig.azure.com", "helmreleases", "alerts", 
      "providers", "receivers", "imagepolicies", "imagerepositories", 
      "imageupdateautomations", "extensionconfigs", "fluxconfigs"
    ]
    verbs      = ["*"]
  }
}