resource "aws_autoscaling_group" "nick_terraform" {
  name                 = "nick_terraform"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.nick_terraform.name
  vpc_zone_identifier  = module.vpc.public_subnets

  lifecycle {
    ignore_changes = [desired_capacity, target_group_arns]
  }

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "nick_terraform"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "nick_terraform" {
  autoscaling_group_name = aws_autoscaling_group.nick_terraform.id
  lb_target_group_arn    = aws_lb_target_group.nick_terraform.arn
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "nick_terraform_scale_up"
  autoscaling_group_name = aws_autoscaling_group.nick_terraform.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 2
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_description   = "Monitors CPU utilization for ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  alarm_name          = "nick_terraform_scale_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "2"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nick_terraform.name
  }
}
