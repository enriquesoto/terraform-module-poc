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

data "azurerm_kubernetes_cluster" "kubernetes_cluster_pulled" {
  name                = "aksveu2polyd01"
  resource_group_name = "RSGREU2POLYD01"
}


output "resource_group_name" {
  value = data.azurerm_resource_group.rgnolocal.name
}

output "resource_group_location" {
  value = data.azurerm_resource_group.rgnolocal.location
}


# provider "kubernetes" {
#   host                   = data.azurerm_kubernetes_cluster.kubernetes_cluster_pulled.kube_config.0.host
#   # client_certificate     = base64decode(data.azurerm_kubernetes_cluster.kubernetes_cluster_pulled.kube_config.0.client_certificate)
#   # client_key             = base64decode(data.azurerm_kubernetes_cluster.kubernetes_cluster_pulled.kube_config.0.client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.kubernetes_cluster_pulled.kube_config.0.cluster_ca_certificate)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "kubelogin"
#     args = [
#       "get-token",
#       "--environment",
#       "AzurePublicCloud",
#       "--server-id",
#       "6dae42f8-4368-4678-94ff-3960e28e3630",
#       "--client-id",
#       "7709f2bd-6bbb-4987-85c0-7289b7a2995e",
#       "--client-certificate",
#       "/Users/enrique-bcp/Documents/workspaces/aks-iac/client_working.pfx",
#       "--client-certificate-password",
#       "pasw1234",
#       "--tenant-id",
#       "5d93ebcc-f769-4380-8b7e-289fc972da1b",
#       "--login",
#       "spn",
#       "|",
#       "jq",
#       ".status.token"
#     ]
#   }

# }