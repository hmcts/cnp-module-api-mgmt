variable "location" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "infra_location" {
  type    = "string"
  default = "core-infra"
}

variable "subscription" {
  type = "string"
}

variable "source_range" {
  type = "string"
}
