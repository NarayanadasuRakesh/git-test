resource "aws_instance" "ec2" {
    ami = "aws_ami.aws-linux-2.id" # retrieve id using data.tf filter
    instance_type = "t2.micro"
    tags = {
        Name = "data-souce" # instance name
    }
}