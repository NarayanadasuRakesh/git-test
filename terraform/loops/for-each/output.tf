# output "instance_info" {
#     value = aws_instance.db[each.key.instance_type]
# }
output "instance_info" {
  value = { for key, instance in aws_instance.db : key => { instance_type = instance.instance_type } }
}