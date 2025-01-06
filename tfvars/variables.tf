variable "instances" {
  type = map(string)
}

variable "common_tags" {
  default = {
    Project = "Expense"
    Terraform = "true"
  }
}

variable "tags" {
  type = map
}

variable "environment" {
  
}

variable "zone_id" {
  default = "Z081461419PCT70J0BCQ6"
}

variable "domain_name" {
  default = "devsecmlops.online"
}