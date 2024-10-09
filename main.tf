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

# resource "azurerm_role_assignment" "example" {
#   name               = "00000000-0000-0000-0000-000000000000"
#   scope              = "/subscriptions/2fe6b8f7-d4ff-4119-b78c-f9e27f278f77/resourceGroups/RGNOLOCALACCS"
#   role_definition_id = "Environment Automation II"
#   principal_id       = "2fe6b8f7-d4ff-4119-b78c-f9e27f278f77"
# }


# resource "azurerm_resource_provider_registration" "kubernetes_configuration" {
#   name = "Microsoft.KubernetesConfiguration"
# }


resource "azurerm_resource_group" "rgnolocal" {
  name     = "RGNOLOCALACCS"
  location = "eastus2"
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = "aksveu2ctpld999"
  location            = azurerm_resource_group.rgnolocal.location
  resource_group_name = azurerm_resource_group.rgnolocal.name
  dns_prefix          = "aksveu2ctpld999"
  # azure_active_directory_role_based_access_control {
  #   tenant_id = "6b828656-d429-49a5-b3c7-6e74a6c57971"
  #   azure_rbac_enabled = true
  # }
  # local_account_disabled = true

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



provider "kubernetes" {
  client_certificate     = base64decode(azurerm_kubernetes_cluster.azurerm_kubernetes_cluster.kubernetes_cluster_pulled.kube_config.0.client_certificate)
  host                   = azurerm_kubernetes_cluster.kubernetes_cluster.kube_config.0.host
  client_key             = base64decode(azurerm_kubernetes_cluster.azurerm_kubernetes_cluster.kubernetes_cluster_pulled.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_config.0.cluster_ca_certificate)
  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   command     = "./kubelogin"
  #   args = [
  #     "get-token",
  #     "--environment",
  #     "AzurePublicCloud",
  #     "--server-id",
  #     "6dae42f8-4368-4678-94ff-3960e28e3630",
  #     "--client-id",
  #     var.client_id,
  #     "--client-secret",
  #     var.client_secret,
  #     "--tenant-id",
  #     var.tenant_id,
  #     "--login",
  #     "spn",
  #     "|",
  #     "jq",
  #     ".status.token"
  #   ]
  # }

}

resource "kubernetes_cluster_role" "developer_env_desa_aks" {
  metadata {
    name = "Developer_Env_Desa_Aks_16"
  }

  rule {
    api_groups = [""]
    resources  = ["deployments", "pods", "pods/exec", "pods/log", "services", "secrets"]
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



# # Instala la extensión GitOps en el clúster de AKS
# resource "azurerm_kubernetes_cluster_extension" "gitops" {
#   name                 = "flux"
#   cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster.id
#   extension_type       = "microsoft.flux"
#   release_train        = "Stable"

#   # configuration_settings = {
#   #   "enableFlux" = "true"
#   #   "gitRepository" = "https://github.com/Azure/gitops-flux2-kustomize-helm-mt.git"
#   #   "gitBranch" = "main"
#   #   "gitPath" = "clusters/aks"
#   #   "syncInterval" = "3m"
#   # }
# }

# resource "azurerm_kubernetes_flux_configuration" "k8s_flux" {
#   name       = "flux-system"
#   cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster.id
#   namespace  = "flux-system"
 
#   git_repository {
#     url             = "https://github.com/thomast1906/azure-aks-flux2config-demo"
#     reference_type  = "branch"
#     reference_value = "main"
#   }
 
#   kustomizations {
#     name                      = "kustomization-2"
#     path                      = "./clusters/production/00"
#     sync_interval_in_seconds  = 120
#     retry_interval_in_seconds = 120
 
#   }
 
#   scope = "cluster"
 
#   depends_on = [
#     azurerm_kubernetes_cluster_extension.gitops
#   ]
# }



# output "resource_group_name" {
#   value = data.azurerm_kubernetes_cluster.rgnolocal.name
# }

# output "resource_group_location" {
#   value = data.azurerm_kubernetes_cluster.rgnolocal.location
# }
