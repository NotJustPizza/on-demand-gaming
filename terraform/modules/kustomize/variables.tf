variable "resources" {
  type = list(string)
}

variable "configmaps" {
  type = map(
    object({
      literals = list(string)
    })
  )
  default = {}
}

variable "secrets" {
  type = map(
    object({
      literals = list(string)
      type     = optional(string, "Opaque")
    })
  )
  default = {}
}

variable "patches" {
  type = list(
    object({
      target = object({
        kind = string
        name = string
      })
      patch = string
    })
  )
  default = []
}

