# IAM role for Jenkins EC2
resource "aws_iam_role" "jenkins_role" {
  name = "${var.project}-jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# IAM policy that allows Jenkins to use AWS services
resource "aws_iam_policy" "jenkins_policy" {
  name = "${var.project}-jenkins-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:*",                         # ECR push/pull
          "ec2:Describe*",                 # Describe EC2 resources
          "eks:Describe*",                 # EKS describe
          "eks:List*",                     # EKS list
          "iam:ListRoles",                 # List IAM roles
          "logs:CreateLogGroup",           # CloudWatch logs
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:Get*",                       # Optional S3 read
          "s3:List*"                       # Optional S3 list
        ]
        Resource = "*"
      }
    ]
  })
}


# Attach IAM policy to Jenkins role
resource "aws_iam_role_policy_attachment" "jenkins_policy_attach" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = aws_iam_policy.jenkins_policy.arn
}

# Instance profile for Jenkins EC2
resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "${var.project}-jenkins-profile"
  role = aws_iam_role.jenkins_role.name
}
    