resource "aws_security_group" "allow_public_alb" {
  name        = "allow-public-alb-${local.stack_name}"
  description = "Allow inbound traffic to public ALB"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP to backend"
    from_port   = var.backend_port
    to_port     = var.backend_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_security_group" "allow_http_from_alb" {
  name        = "allow-http-from-alb-${local.stack_name}"
  description = "Allow inbound traffic to NGINX from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from ALB"
    from_port   = var.backend_port
    to_port     = var.backend_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Internet access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
