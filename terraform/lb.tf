resource "aws_lb" "front" {
  name               = "my-devopscodes-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_public_alb.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.front.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance_nginx.arn
  }
}

resource "aws_lb_target_group" "instance_nginx" {
  name     = "devopscodes-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "instance_nginx" {
  target_group_arn = aws_lb_target_group.instance_nginx.arn
  target_id        = aws_instance.web_server.id
  port             = 80
}