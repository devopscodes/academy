data "template_file" "init" {
  template = file("${path.module}/init.tpl")
}

resource "aws_instance" "web_server" {
  ami                  = "ami-0c956e207f9d113d5"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.s3_profile.id

  user_data                   = data.template_file.init.rendered
  user_data_replace_on_change = true

  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.allow_http_from_alb.id]
  tags = {
    Name = "Nginx"
  }
}

resource "aws_iam_instance_profile" "s3_profile" {
  name = "s3_profile"
  role = aws_iam_role.s3_role.name
}

resource "aws_iam_role" "s3_role" {
  name = "s3_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  inline_policy {
    name = "my_inline_s3_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

}