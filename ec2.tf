resource "aws_instance" "ami" {
  instance_type          = "t3.small"
  ami                    = data.aws_ami.ami.image_id
  vpc_security_group_ids = [aws_security_group.main.id]
  iam_instance_profile   = aws_iam_instance_profile.parameter-store-access.name
  tags = {
    Name = "${var.COMPONENT}-ami"
  }
}

resource "null_resource" "ansible-apply" {
  triggers = {
    abc = timestamp()
  }
  provisioner "remote-exec" {
    connection {
      host     = aws_instance.ami.public_ip
      user     = local.ssh_username
      password = local.ssh_password
    }

    inline = [
      "ansible-pull -i localhost, -U https://github.com/raghudevopsb66/roboshop-mutable-ansible roboshop.yml -e HOSTS=localhost -e APP_COMPONENT_ROLE=${var.COMPONENT} -e ENV=ENV -e APP_VERSION=${var.APP_VERSION}"
    ]
  }
}

resource "aws_ami_from_instance" "ami" {
  depends_on         = [null_resource.ansible-apply]
  name               = "${var.COMPONENT}-${var.APP_VERSION}"
  source_instance_id = aws_instance.ami.id
}

