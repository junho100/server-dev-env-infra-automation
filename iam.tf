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
    module.backend_instance_policy.arn
  ]
}

module "backend_instance_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = format(module.naming.result, "backend-policy")
  path        = "/"
  description = "backend-policy"

  policy = file("./files/backend-policy.json")
}

module "codebuild_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name               = format(module.naming.result, "cb-role")
  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = false

  trusted_role_services = [
    "codebuild.amazonaws.com"
  ]

  custom_role_policy_arns = [
    module.codebuild_policy.arn
  ]
}

module "codebuild_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = format(module.naming.result, "cb-policy")
  path        = "/"
  description = "codebuild-policy"

  policy = file("./files/codebuild-policy.json")
}

module "codedeploy_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name               = format(module.naming.result, "cd-role")
  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = false

  trusted_role_services = [
    "codedeploy.amazonaws.com"
  ]

  custom_role_policy_arns = [
    module.codedeploy_policy.arn
  ]
}

module "codedeploy_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = format(module.naming.result, "cd-policy")
  path        = "/"
  description = "codedeploy-policy"

  policy = file("./files/codedeploy-policy.json")
}

module "codepipeline_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name               = format(module.naming.result, "cpl-role")
  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = false

  trusted_role_services = [
    "codepipeline.amazonaws.com"
  ]

  custom_role_policy_arns = [
    module.codepipeline_policy.arn
  ]
}

module "codepipeline_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = format(module.naming.result, "cpl-policy")
  path        = "/"
  description = "codepipeline-policy"

  policy = file("./files/codepipeline-policy.json")
}
