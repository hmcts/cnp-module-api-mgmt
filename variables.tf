variable "location" {
  default = "UK South"
}

variable "env" {}

variable "vnet_rg_name" {}

variable "vnet_name" {}

variable "virtual_network_type" {
  default = "External"
}

variable "source_range_index" {}

variable "source_range" {}

variable "publisher_email" {
  default = "api-mangement@hmcts.net"
}

variable "publisher_name" {
  default = "HMCTS Reform Platform Engineering"
}

variable "notification_sender_email" {
  default = "apimgmt-noreply@mail.windowsazure.com"
}

variable "common_tags" {
  default = {
    "managedBy" = "pleaseTagMe"
  }
}
