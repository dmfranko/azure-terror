variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "windows_count" {
  description = "How many windows vms to create."
}

variable "linux_count" {
  description = "How many linux vms to create."
}

variable "mid_user" {
  description = "MID server user name."
}

variable "mid_password" {
  description = "MID server user password."
}

variable "mid_instance" {
  description = "What instance should this connect to."
}

variable "mid_name" {
  description = "What name you want to give the MID server."
}