resource "aws_lb" "nick_terraform" {
  name               = "learn-asg-nick-terraform-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nick_terraform_lb.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "nick_terraform" {
  load_balancer_arn = aws_lb.nick_terraform.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nick_terraform.arn
  }
}

resource "aws_lb_target_group" "nick_terraform" {
  name     = "learn-asg-nick-terraform"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}