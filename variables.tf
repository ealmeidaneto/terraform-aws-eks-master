# EKS Master Variables

variable cluster_name {
  type        = string
  description = "Variable used to define EKS Cluster's name"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Variable used to name the enviroment. 'Prod', 'Dev', 'Staging', for example"
}


variable "cluster_log_types" {

  type        = list(string)
  default     = []
  description = "Control Plane logs. Possible options: api, audit,authenticator,controllerManager,scheduler."
}

variable "master_subnets" {
  description = "A list of subnets to place the EKS cluster and workers within."
  type        = list(string)
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "VPC ID for security group"
}

variable "cluster_endpoint_private_access" {
  description = "Indicates if EKS private API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates if EKS public API server endpoint is enabled."
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access_cidrs" {
  description = "CIDR blocks which can access the EKS private API."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks which can access the EKS public API."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_version" {
  description = "EKS cluster version."
  type        = string
  default     = "1.17"
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}

variable "cluster_log_retention_in_days" {
  default     = 14
  description = "Log retention."
  type        = number
}

variable "eks_log_kms_key" {
  default     = ""
  description = "(Optional) If KMS Key is set, the key will be used to encrypt the corresponding log group."
  type        = string
}

variable "create_cluster" {
  type        = bool
  default     = true
  description = "(Optional) Controls if EKS master will be created or not"
}

variable "create_cluster_iam" {
  type        = bool
  default     = false
  description = "(Optional) Controls iam rules are created to EKS master will be created or not"
}

variable role_arn {
  type        = string
  default     = ""
  description = "(Required) The Amazon Resource Name (ARN) of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf."
}

variable create_master_sg {
  type        = bool
  default     = false 
  description = "(Optional) Variable that controls whether SG will be created or not"
}

variable master_sg {
  type        = list(string)
  default     = []
  description = "(Optional) Contains a list of SG to be use by EKS master"
}

variable create_cw_log_group {
  type        = bool
  default     = false
  description = "(Optional) Variable that controls whether SG will be created or not. Default: False"
}

variable encryption_config {
  type        = list(map(string))
  default     = []
  description = "(Optional) Configuration block with encryption configuration for the cluster. Only available on Kubernetes 1.13 and above clusters created after March 6, 2020. Detailed below"
}
