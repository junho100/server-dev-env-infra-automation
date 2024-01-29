locals {
  default_env_params = {
    db-host     = module.rds_instance.address
    db-port     = 3306
    db-name     = module.rds_instance.db_name
    db-username = module.rds_instance.username
    db-password = var.db_password
  }
}

resource "aws_ssm_parameter" "backend_ssm_parameter" {
  for_each = merge(var.env_params, local.default_env_params)
  type     = "String"
  name     = format("/${var.project_name}/backend/${var.environment}/%s", each.key)
  value    = each.value
}
