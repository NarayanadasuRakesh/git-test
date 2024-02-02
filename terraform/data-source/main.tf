resource "aws_instance" "ec2" {
    ami = "aws_ami.centos8.id" # retrieve id using data.tf filter
    instance_type = var.instance_type
    tags = var.tags
}