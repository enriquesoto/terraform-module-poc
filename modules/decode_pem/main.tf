resource "null_resource" "decode_pem" {
  provisioner "local-exec" {
    command = <<EOT
echo "${var.ARM_CLIENT_CERTIFICATE_BASE64}" | base64 --decode > /tmp/sp-cert.pem
EOT
  }
}
