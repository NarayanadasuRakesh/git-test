variable "ami" {
    type = string
    default = "ami-123asdf"
}

variable "instance_names" {
    type = list
    default = ["mongodb","redis","mysql","rabbitmq"]
}