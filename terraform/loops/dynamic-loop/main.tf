resource "aws_instance" "robotshop" {
    ami = var.ami
    instance_type = "t2.small"
    vpc_security_group_ids = [aws_security_group.robotshop-all.id]

    tags = {
        Name = "dynamic-loop"
        Terraform = true
    }
}


resource "aws_security_group" "robotshop-all" {
  name        = "dynamic-loop"
  description = "Allow specific traffic"

  dynamic ingress {
    for_each = var.ingress_rules
    content {
        description      = ingress.value["description"]
        from_port        = ingress.value["from_port"]
        to_port          = ingress.value["to_port"]
        protocol         = ingress.value["protocol"]
        cidr_blocks      = ingress.value["cidr_blocks"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}