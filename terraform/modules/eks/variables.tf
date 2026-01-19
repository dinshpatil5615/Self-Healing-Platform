variable "cluster_name" {}
variable "node_role_arn" {}
variable "cluster_role_arn" {}
variable "subnet_ids" {type = list(string)}
variable "cluster_sg_id" {}