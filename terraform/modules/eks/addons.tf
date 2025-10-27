resource "aws_eks_addon" "core_dns" {
  cluster_name                = aws_eks_cluster.eks.name
  addon_name                  = "coredns"
  resolve_conflicts_on_create = "OVERWRITE"
  
  #pod_identity_association = {

  #}
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.eks.name
  addon_name                  = "kube-proxy"
  resolve_conflicts_on_create = "OVERWRITE"
}

# vpc cni

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.eks.name
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_create = "OVERWRITE"
}

module "aws_vpc_cni_ipv4_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws"
  name = "aws-vpc-cni-ipv4"
  attach_aws_vpc_cni_policy = true
  aws_vpc_cni_enable_ipv4   = true

}

resource "aws_eks_pod_identity_association" "vpc_cni" {
  cluster_name    = module.eks.cluster_name
  service_account = "vpccni"
  role_arn        = module.aws_vpc_cni_ipv4_pod_identity.iam_role_arn
  depends_on = [awk_eks_addon.vpc_cni]
}