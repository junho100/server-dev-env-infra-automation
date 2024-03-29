variable "vpn_ip_address" {
  description = "vpn ip address for limited access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_name" {
  description = "database name"
  type        = string
  default     = "test"
}

variable "db_username" {
  description = "database admin username"
  type        = string
  default     = "root"
}

variable "db_password" {
  description = "database password"
  type        = string
  default     = "admin123!"
}

variable "environment" {
  description = "environment"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "name of project"
  type        = string
  default     = "defaultproj"

  validation {
    condition     = length(var.project_name) < 11
    error_message = "length of project name should be less than 10 words."
  }
}

variable "repository_name" {
  description = "name of target repository name"
  type        = string
}

variable "repository_owner" {
  description = "name of repository owner"
  type        = string
}

variable "target_branch_name" {
  description = "name of target branch"
  type        = string
}

variable "github_token" {
  description = "github token for access repository"
  type        = string
}

variable "domain_name" {
  description = "domain name for connecting service"
  type        = string
}

variable "api_endpoint_prefix" {
  description = "api endpoint prefix"
  type        = string
}

variable "env_params" {
  description = "list of additional environment parameters"
  type        = map(string)
}

