# data "aws_ami" "aws-linux-2" {
#   owners       = ["137112412989"]
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-kernel-5.10-hvm-*"]
#   }
#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   filter {
#     name = "architecture"
#     values = ["arm64"]
#   }
# }

data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "centos8" {
    owners = [137112412989]
    most_recent = true

    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*"]
    }

    filter {
      name = "architecture"
      values = ["x86_64"]
    }

    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }

    filter {
      name = "root-device-type"
      values = ["ebs"]
    }
}