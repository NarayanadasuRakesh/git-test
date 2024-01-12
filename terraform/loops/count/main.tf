resource "aws_instance" "loop" {
    count = 4
    ami = "var.ami"
    instance_type = "t2.micro"

    tags = {
        Name = var.instance_names[count.index]
    }
}