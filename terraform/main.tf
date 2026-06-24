terraform {
  backend "s3" {
    bucket  = "mi-terraform-state-bucket-test1"
    key     = "applications/mi-app/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint

  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.cluster.certificate_authority[0].data
  )

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      var.eks_cluster_name,
      "--region",
      var.aws_region
    ]
  }
}

resource "kubernetes_secret_v1" "database" {
  metadata {
    name      = "mi-app-db-secret"
    namespace = "default"
  }

  data = {
    username = var.db_username
    password = var.db_password
  }

  type = "Opaque"
}

resource "kubernetes_deployment_v1" "mi_app" {
  metadata {
    name      = "mi-app"
    namespace = "default"

    labels = {
      app = "mi-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mi-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "mi-app"
        }
      }

      spec {
        container {
          name  = "mi-app"
          image = "${var.ecr_repository_url}:${var.image_tag}"

          image_pull_policy = "Always"

          port {
            container_port = 8000
          }

          env {
            name  = "DB_HOST"
            value = var.db_host
          }

          env {
            name  = "DB_NAME"
            value = var.db_name
          }

          env {
            name = "DB_USER"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.database.metadata[0].name
                key  = "username"
              }
            }
          }

          env {
            name = "DB_PASSWORD"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.database.metadata[0].name
                key  = "password"
              }
            }
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "512Mi"
            }

            limits = {
              cpu    = "250m"
              memory = "512Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 8000
            }

            initial_delay_seconds = 10
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 8000
            }

            initial_delay_seconds = 20
            period_seconds        = 20
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "mi_app" {
  metadata {
    name      = "mi-app-service"
    namespace = "default"

    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"            = "external"
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
      "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internet-facing"
    }
  }

  spec {
    selector = {
      app = "mi-app"
    }

    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 8000
    }

    type = "LoadBalancer"
  }

  wait_for_load_balancer = false

  depends_on = [
    kubernetes_deployment_v1.mi_app
  ]
}
