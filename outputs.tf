output "lb_endpoint" {
  value = "http://${aws_lb.nick_terraform.dns_name}"
}

output "asg_name" {
  value = aws_autoscaling_group.nick_terraform.name
}