resource "aws_codepipeline" "backend_codepipeline" {
  name     = format(module.naming.result, "backend-cpl")
  role_arn = module.codepipeline_role.arn

  artifact_store {
    location = module.code_pipeline_s3_bucket.bucket_id
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = 1
      run_order        = 1
      output_artifacts = ["source_output"]
      configuration = {
        Repo       = var.repository_name
        Branch     = var.target_branch_name
        OAuthToken = var.github_token
        Owner      = var.repository_owner
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.backend_codebuild_project.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeDeployToEC2"
      version          = "1"
      input_artifacts  = ["build_output"]
      output_artifacts = []

      configuration = {
        ApplicationName          = aws_codedeploy_app.backend_codedeploy_app.name
        DeploymentGroupName      = aws_codedeploy_deployment_group.backend_codedeploy_deployment_group.deployment_group_name
        DeploymentConfigName     = aws_codedeploy_deployment_group.backend_codedeploy_deployment_group.deployment_config_name
        WaitUntilDeploymentReady = "true"
      }
    }
  }
}
