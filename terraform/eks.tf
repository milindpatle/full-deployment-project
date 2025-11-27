module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.31.2"

  cluster_name    = "${var.project}-eks"
  cluster_version = "1.29"
  create_cloudwatch_log_group = false


  vpc_id     = aws_vpc.vpc2.id
  subnet_ids = aws_subnet.vpc2_priv[*].id

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = [var.node_instance_type]
      key_name       = var.key_name
    }
  }

  tags = {
    Project = var.project
  }
}
