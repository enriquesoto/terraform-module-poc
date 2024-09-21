# module "decode_pem" {
#   source = "./modules/decode_pem"
#   client_certificate_base64 = var.ARM_CLIENT_CERTIFICATE_BASE64
# }

resource "local_file" "client_cert" {
  filename = "/tmp/cert.pfx"
  content_base64  = var.certificate_pfx_base64
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_certificate_password = var.password_pfx
  client_certificate_path = "/tmp/cert.pfx"
  
}

data "azurerm_resource_group" "rgnolocal" {
  name     = "RGNOLOCALACCS"
}
