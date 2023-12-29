# tflint-ignore: terraform_unused_declarations
variable "stack_version" {
  type = string

  validation {
    condition     = var.stack_version == "v0.11.0"
    error_message = "Unsupported stack version, please update module first."
  }
}

variable "vultr_api_key" {
  sensitive = true
  type      = string
}
