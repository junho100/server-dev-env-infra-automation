resource "aws_codebuild_project" "backend_codebuild_project" {
  name         = format(module.naming.result, "backend-cd-project")
  service_role = module.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec/buildspec-${var.environment}.yml"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }
}
