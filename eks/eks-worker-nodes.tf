resource "aws_eks_node_group" "danit-amd" {
  cluster_name    = aws_eks_cluster.danit.name
  node_group_name = "${var.name}-amd"
  node_role_arn   = local.node_role_arn
  subnet_ids      = var.subnets_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  labels = {
    "node-type" : "general"
  }

  depends_on = []
  
  tags = merge(
    var.tags,
    { Name = "${var.name}-amd-node-group" }
  )
}
