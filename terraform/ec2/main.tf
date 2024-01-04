resource "aws_instance" "roboshop" {
  ami = var.ami
  #count = 11
  count                  = length(var.instance_name) # provides length dynamically
  instance_type          = var.instance_name[count.index] == "mongodb" || var.instance_name[count.index] == "mysql" || var.instance_name[count.index] == "shipping" ? "t3.small" : "t2.micro"
  vpc_security_group_ids = [aws_security_group.terraform-all.id]

  tags = {
    Name = var.instance_name[count.index]
  }
}


resource "aws_security_group" "terraform-all" {
  name        = var.name
  description = "Allow any traffic from internet"

  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.sg-tags
}

resource "aws_route53_record" "route53" {
  #count = 11 # static
  count           = length(var.instance_name) # dynamic 
  zone_id         = var.zone_id
  name            = "${var.instance_name[count.index]}.${var.domain_name}"
  type            = "A"
  ttl             = 1
  allow_overwrite = true
  records         = [var.instance_name[count.index] == "web" ? aws_instance.roboshop[count.index].public_ip : aws_instance.roboshop[count.index].private_ip]
}