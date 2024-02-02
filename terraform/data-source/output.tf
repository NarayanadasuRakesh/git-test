# output "ami_info" {
#   value = data.aws_ami.aws-linux-2.id # shows instance id
# }

output "ami_info" {
  value = data.aws_ami.centos8.id # shows instance id
}

output "vpc_info" {
  value = data.aws_vpc.default.id
}