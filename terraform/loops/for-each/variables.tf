variable "ami" {
    type = string
    default = "ami-oasikjhfdcaio"
}

variable "instance_type" {
    type = map
    default = {
        mongodb = "t3.small"
        redis = "t2.small"
        mysql = "t3.medium"
        rabbitmq = "t2.small"
    }
}

variable "zone_id" {
    type = string
    default = "ZOmjdoaij132"
}

variable "domain" {
    type = string
    default = "domain.com"
}