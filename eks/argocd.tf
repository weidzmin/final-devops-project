resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "5.46.7"

  create_namespace = true

  values = [
    yamlencode({
      server = {
        ingress = {
          enabled = true
          hosts = ["argocd.${var.name}.${var.zone_name}"]
          annotations = {
            "kubernetes.io/ingress.class" = "nginx"
            "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
            "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
            "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
          }
          tls = true
        }
        extraArgs = [
          "--insecure"
        ]
      }
      configs = {
        params = {
          "server.insecure" = true
        }
      }
    })
  ]

  depends_on = [
    aws_eks_cluster.danit,
    aws_eks_node_group.danit-amd,
    helm_release.nginx_ingress
  ]
}

# ArgoCD admin password
resource "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  data = {
    password = base64encode("admin123")
  }

  depends_on = [helm_release.argocd]
}
