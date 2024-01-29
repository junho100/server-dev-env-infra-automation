################################################################################
# RDS
################################################################################

module "rds_instance" {
  source = "terraform-aws-modules/rds/aws"

  identifier = format(module.naming.result, "rds")

  engine               = "mysql"
  engine_version       = "8.0"
  family               = "mysql8.0" # DB parameter group
  parameter_group_name = format(module.naming.result, "parameter-group")
  parameters = [
    {
      name  = "default_collation_for_utf8mb4"
      value = "utf8mb4_0900_ai_ci"
    },
    {
      name  = "collation_server"
      value = "utf8mb4_general_ci"
    },
    {
      name  = "collation_connection"
      value = "utf8mb4_general_ci"
    },
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_connection"
      value = "utf8mb4"
    },
    {
      name  = "character_set_database"
      value = "utf8mb4"
    },
    {
      name  = "character_set_filesystem"
      value = "utf8mb4"
    },
    {
      name  = "character_set_results"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    },
    {
      name  = "time_zone"
      value = "Asia/Seoul"
    },
  ]
  major_engine_version = "8.0" # DB option group
  instance_class       = "db.t3.micro"

  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = false
  password                    = var.db_password
  port                        = 3306

  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.subnet_group_for_rds.name
  vpc_security_group_ids = [module.sg_for_rds.security_group_id]

  create_cloudwatch_log_group = false

  skip_final_snapshot = true
  deletion_protection = false
  allocated_storage   = 20
}

################################################################################
# Supporting Resources
################################################################################

resource "aws_db_subnet_group" "subnet_group_for_rds" {
  name       = format(module.naming.result, "subnet-group")
  subnet_ids = module.vpc.database_subnets
}
