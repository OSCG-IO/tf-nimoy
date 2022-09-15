output "driver_public_ip"  { value = aws_instance.driver.public_ip }
output "driver_private_ip" { value = aws_instance.driver.private_ip }

output "node_public_ip"    { value  = aws_instance.node.public_ip }
output "node_private_ip"   { value  = aws_instance.node.private_ip }

output "sg_id" { value = aws_security_group.sg.id }
