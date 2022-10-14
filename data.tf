data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "centos7-devops-practice-with-ansible"
  owners      = ["self"]
}

data "aws_ssm_parameter" "ssh_credentials" {
  name = "ssh.credentials"
}
