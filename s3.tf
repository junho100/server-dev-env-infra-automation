module "code_pipeline_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = format(module.naming.result, "cpl-s3-bucket")

  force_destroy = true

  # S3 bucket-level Public Access Block configuration (by default now AWS has made this default as true for S3 bucket-level block public access)
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  attach_policy = true
  policy = templatefile("./files/cpl-s3-policy.tftpl", {
    s3_bucket_arn = "arn:aws:s3:::${format(module.naming.result, "cpl-s3-bucket")}"
  })
}
