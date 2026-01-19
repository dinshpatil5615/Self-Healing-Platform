module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
}

module "eks" {
  source = "./modules/eks"
  cluster_name = var.cluster_name
  subnet_ids = module.vpc.public_subnets
  node_role_arn = module.iam.node_role_arn
  cluster_role_arn = module.iam.cluster_role_arn
  cluster_sg_id = module.security-groups.eks_cluster_sg_id
}

module "security-groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "jenkins" {
  source = "./modules/jenkins"
  subnet_id = module.vpc.public_subnets
  # vpc_id = module.vpc.vpc_id
  instance_type = var.instance_type
  key_name = var.key_name
  jenkins_sg_id = module.security-groups.jenkins_sg_id
}

resource "helm_release" "argocd" {
  name = "argocd"
  namespace = "argocd"
  create_namespace = true
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
}

resource "helm_release" "prometheus" {
  name = "monitoring"
  namespace = "monitoring"
  create_namespace = true
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "kube-prometheus-stack"
}
