# module "decode_pem" {
#   source = "./modules/decode_pem"
#   client_certificate_base64 = var.ARM_CLIENT_CERTIFICATE_BASE64
# }

resource "local_file" "client_cert" {
  filename = "/tmp/cert.pfx"
  content  = base64decode(var.client_certificate_base64)
}

provider "azurerm" {
  features {}

  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_certificate_password = var.client_certificate_password
  client_certificate_path = "/tmp/cert.pfx"
  
}

# resource "azurerm_resource_group" "example" {
#   name     = "example-resources"
#   location = "West Europe"
#   depends_on = [module.decode_pem]  # Asegura que el proveedor espere a que el módulo termine
# }
