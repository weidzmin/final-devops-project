# Hardcoded ARNs for existing IAM roles (bypassing iam:GetRole permission)
locals {
  cluster_role_arn = "arn:aws:iam::013372624309:role/student1-eks-cluster-role"
  node_role_arn    = "arn:aws:iam::013372624309:role/student1-eks-node-role"
}

# OIDC provider for IRSA
data "tls_certificate" "cert" {
  url = aws_eks_cluster.danit.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "openid_connect" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cert.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.danit.identity[0].oidc[0].issuer
}

module "oidc-provider-data" {
  source     = "reegnz/oidc-provider-data/aws"
  version    = "0.0.3"
  issuer_url = aws_eks_cluster.danit.identity[0].oidc[0].issuer
}
