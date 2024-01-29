module "backend_instance_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name               = format(module.naming.result, "backend-role")
  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = true

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  custom_role_policy_arns = [
    module.task_policy.arn
  ]
}

module "backend_instance_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = format(module.naming.result, "backend-policy")
  path        = "/"
  description = "backend-policy"

  policy = file("./files/backend-policy.json")
}
