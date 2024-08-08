provider "azurerm" {
  features {}

  tenant_id       = var.tenant_id
  client_id       = var.client_id

  client_certificate_path = "/tmp/sp-cert.pem"

  # Decodificar el archivo PEM desde base64 y escribirlo temporalmente
  provisioner "local-exec" {
    command = <<EOT
echo "$ARM_CLIENT_CERTIFICATE_BASE64" | base64 --decode > /tmp/sp-cert.pem
EOT
  }
}