variable "region" {
  default = "us-east-1"
}

variable "tags" {
  type = map(string)
  default     = {
    "name" : "mixfast"
    "company" : "fiap"
  }
}

variable "vpcCIDRblock" {
  default = "10.0.0.0/16"
}
variable "instanceTenancy" {
  default = "default"
}
variable "dnsSupport" {
  type = bool
  default = true
}
variable "dnsHostNames" {
  type = bool
  default = true
}
variable "privatesCIDRblock" {
  type = list
  default = ["10.0.0.0/19", "10.0.64.0/19", "10.0.128.0/19"]
}
variable "publicsCIDRblock" {
  type = list
  default = ["10.0.32.0/24", "10.0.96.0/24", "10.0.224.0/24"]
}
variable "availabilityZone" {
  type = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}