output "driver_public_ip" {
  value       = aws_instance.driver.public_ip
}

output "node_public_ip" {
  value       = aws_instance.node.public_ip
}
