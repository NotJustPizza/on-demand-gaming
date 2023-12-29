variable "image_version" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "vultr_region_id" {
  type = string
}

variable "k8s_default_labels" {
  type = map(string)
}

variable "k8s_namespace" {
  type = string
}

variable "k8s_registry_url" {
  type = string
}

variable "k8s_secrets" {
  type = map(string)
}
