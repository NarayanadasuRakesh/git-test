resource "aws_instance" "db" {
    for_each = var.instance_type
    ami = "var.ami"
    instance_type = each.value

    tags = {
        Name = each.key
    }
}

resource "aws_security_group" "robotshop-all" {
  name = "Allow-all"
  description = "allow everyone from internet"

  ingress {
    description      = "Allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "robotshop-all"
  }
}

resource "aws_route53_record" "www" {
    for_each = aws_instance.db
    zone_id = var.zone_id
    name = "${each.key}.${var.domain}"
    type = "A"
    ttl = 1
    records = [each.key == "web" ? each.value.public_ip : each.value.private_ip]
}
