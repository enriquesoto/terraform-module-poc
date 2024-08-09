module "decode_pem" {
  source = "./modules/decode_pem"
  client_certificate_base64 = var.ARM_CLIENT_CERTIFICATE_BASE64
}

provider "azurerm" {
  features {}

  tenant_id       = var.ARM_TENANT_ID
  client_id       = var.ARM_CLIENT_ID
  client_certificate_path = "/tmp/sp-cert.pem"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
  depends_on = [module.decode_pem]  # Asegura que el proveedor espere a que el módulo termine
}
