resource "aws_ecr_repository" "app" {
  name                 = "dev/nodejs-monitoring-app"
  image_tag_mutability = "MUTABLE"
  tags                 = { Project = var.project }
}
