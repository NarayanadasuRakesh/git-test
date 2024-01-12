output "instance_id" {
    value = aws_instance.loop[*].id
}

output "public_ip" {
    value = aws_instance.loop[*].public_ip
}

output "private_ip" {
    value = aws_instance.loop[*].private_ip
}