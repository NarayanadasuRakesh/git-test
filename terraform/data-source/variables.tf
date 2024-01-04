variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "tags" {
    type = map
    default = {
        Name = "data-source" 
    }
}