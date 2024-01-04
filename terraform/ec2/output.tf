output "roboshop-info" {
  value = {
    instance_id = aws_instance.roboshop[*].id,
    private_ip  = aws_instance.roboshop[*].private_ip,
    public_ip   = aws_instance.roboshop[*].public_ip,
  }
}