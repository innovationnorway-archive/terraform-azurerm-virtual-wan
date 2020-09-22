variable "name_prefix" {
  type        = string
  default     = "test"
  description = "Creates a unique name beginning with the specified prefix."
}

variable "region" {
  type        = string
  default     = "westeurope"
  description = "The Azure region where the resources should be created."
}
