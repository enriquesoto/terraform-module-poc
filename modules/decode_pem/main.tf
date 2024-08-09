resource "null_resource" "decode_pem" {
  provisioner "local-exec" {
    command = <<EOT
echo "${var.client_certificate_base64}" | base64 --decode > /tmp/sp-cert.pem
EOT
  }
}
