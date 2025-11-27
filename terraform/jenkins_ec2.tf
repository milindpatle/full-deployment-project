resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ubuntu.id                   # Ubuntu latest AMI
  instance_type               = "t3.medium"                              # Instance type
  subnet_id                   = aws_subnet.vpc1_pub[0].id                # Public subnet of VPC1
  key_name                    = var.key_name                             # SSH key
  associate_public_ip_address = true                                     # Public IP required

  iam_instance_profile        = aws_iam_instance_profile.jenkins_profile.name   # IAM role for AWS CLI

  vpc_security_group_ids = [
    aws_security_group.jenkins_sg.id                                     # Jenkins SG
  ]

  user_data = file("${path.module}/jenkins_user_data.sh")               # Install Jenkins, Docker

  tags = {
    Name = "${var.project}-jenkins"                                     # Tag
  }
}
