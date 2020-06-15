variable "location" {
  type    = "string"
  default = "UK South"
}

variable "env" {
  type = "string"
}

variable "vnet_rg_name" {
  type = "string"
}

variable "api_subnet_id" {
  type = "string"
}

variable "publisher_email" {
  type    = "string"
  default = "api-mangement@hmcts.net"
}

variable "publisher_name" {
  type    = "string"
  default = "HMCTS Reform Platform Engineering"
}

variable "notification_sender_email" {
  type    = "string"
  default = "apimgmt-noreply@mail.windowsazure.com"
}

variable "common_tags" {
  type = "map"
  default = {
    "managedBy" = "pleaseTagMe"
  }
}
