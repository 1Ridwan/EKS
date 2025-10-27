resource "aws_iam_role" "eks" {

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam:aws:policy/AmazonEKSClusterPolicy"
}

# eks cluster resource

resource "aws_eks_cluster" "eks" {
  name = "cluster-project"
  version = var.eks_version
  role_arn = aws_iam_role.eks.arn

  access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {

    endpoint_private_access = false
    endpoint_public_access = true

    subnet_ids = [
      var.private_subnet_zone1_id,
      var.private_subnet_zone2_id
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks,
  ]
}

