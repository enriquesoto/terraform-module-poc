provider "azurerm" {
  features {}

  tenant_id       = var.ARM_TENANT_ID
  client_id       = var.ARM_CLIENT_ID
  client_certificate_path = "/tmp/sp-cert.pem"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "null_resource" "force_apply" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
echo "${var.ARM_CLIENT_CERTIFICATE_BASE64}" | base64 --decode > /tmp/sp-cert.pem
EOT
  }
}
