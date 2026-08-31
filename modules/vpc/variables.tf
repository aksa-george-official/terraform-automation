

variable "cidr_block"{
    type = string
}

variable "subnets" {
  description = "Infra-subnet configuration"

  type = map(object({
    availability_zone = string
    cidr_block        = string
    type              = string

  }))
}



