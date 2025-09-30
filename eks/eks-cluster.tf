resource "aws_eks_cluster" "danit" {
  name     = var.name
  role_arn = local.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnets_ids
  }

  depends_on = []
  tags = merge(
    var.tags,
    { Name = "${var.name}" }
  )
}

data "aws_eks_cluster_auth" "danit" {
  name = aws_eks_cluster.danit.name
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = var.name
  addon_name                  = "coredns"
  #addon_version               = "v1.11.1-eksbuild.4"
  #addon_version		      = "v1.11.3-eksbuild.1"
  addon_version               = "v1.12.2-eksbuild.4"
  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [aws_eks_node_group.danit-amd]
}
