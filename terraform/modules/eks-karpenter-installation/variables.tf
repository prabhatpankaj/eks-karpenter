variable "kubeconfig" {
  type = string
}

variable "iam_assumable_role_karpenter_iam_role_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}