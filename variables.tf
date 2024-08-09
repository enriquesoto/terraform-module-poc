variable "ARM_CLIENT_ID" {
  description = "Client ID of the Azure Service Principal"
  type        = string
}

variable "ARM_TENANT_ID" {
  description = "Tenant ID of the Azure Service Principal"
  type        = string
}

variable "ARM_CLIENT_CERTIFICATE_BASE64" {
  description = "Base64 encoded client certificate"
  type        = string
}