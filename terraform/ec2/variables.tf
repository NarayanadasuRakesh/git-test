variable "ami" {
  type    = string
  default = "ami-03265a0778a880afb"
}

# variable "instance_type" {
#     type = string
#     default = "t2.micro"
# }

variable "instance_name" {
  type    = list(any)
  default = ["mongodb", "redis", "mysql", "rabbitmq", "catalogue", "user", "cart", "shipping", "payment", "dispatch", "web"]
}

variable "tags" {
  type = map(any)
  default = {
    Name        = "terraform"
    Project     = "robotshop"
    Environment = "dev"
    Component   = "web"
    Terraform   = "true"
  }
}

variable "name" {
  type    = string
  default = "terraform-all"
}

variable "sg-tags" {
  type = map(any)
  default = {
    Name = "terraform-sg"
  }
}

variable "zone_id" {
  type    = string
  default = "zone-id"
}

variable "domain_name" {
  type    = string
  default = "<domain/ip>"
}
