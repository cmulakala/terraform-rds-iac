variable "envName" {
  description = "RDS Environment Name Variable"
  type        = string
}

variable "region" {
  description = "Region Name"
  type        = string
}

variable "cidr" {
  description = "CIDR Blcok Name"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "subnetCidrs" {
  description = "Subnet CIDR Blocks"
  type        = list(string)
}
