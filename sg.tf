resource "aws_security_group" "main" {
  name        = "${var.COMPONENT}-ami"
  description = "${var.COMPONENT}-ami"
  vpc_id      = var.DEFAULT_VPC_ID

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.COMPONENT}-ami"
  }
}