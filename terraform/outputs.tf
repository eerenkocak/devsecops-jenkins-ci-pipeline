output "jenkins_url" {
  description = "Access URL for the provisioned Jenkins Controller"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}

output "server_public_ip" {
  description = "Public IP address of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_server.public_ip
}
