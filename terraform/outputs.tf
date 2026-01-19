output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "jenkins_url" {
  value = "http://${module.jenkins.jenkins_public_ip}:8080"
}