variable "ami" {
    type = string
    default = "ami-081609eef2e3cc958"
}

variable "ingress_rules" {
   
    default = [ 
    {
        Name: "port80"
        description      = "Allow port 80"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    },
    {
        Name: "port443"
        description      = "Allow port 443"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    },
    {
        name: "port22"
        description      = "Allow port 22"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    },
    ]
}