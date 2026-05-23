resource "aws_s3_bucket" "cloudtrail" {
  count  = var.cloudtrail_enabled ? 1 : 0
  bucket = "${local.prefix}-cloudtrail-${local.account_id}"
}

resource "aws_s3_bucket_versioning" "cloudtrail" {
  count  = var.cloudtrail_enabled ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  count  = var.cloudtrail_enabled ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  count  = var.cloudtrail_enabled ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  count  = var.cloudtrail_enabled ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = aws_s3_bucket.cloudtrail[0].arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudtrail:${local.region}:${local.account_id}:trail/${local.prefix}-trail"
          }
        }
      },
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.cloudtrail[0].arn}/AWSLogs/${local.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"  = "bucket-owner-full-control"
            "AWS:SourceArn" = "arn:aws:cloudtrail:${local.region}:${local.account_id}:trail/${local.prefix}-trail"
          }
        }
      }
    ]
  })
}

resource "aws_cloudtrail" "main" {
  count = var.cloudtrail_enabled ? 1 : 0
  name  = "${local.prefix}-trail"

  s3_bucket_name                = aws_s3_bucket.cloudtrail[0].bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  depends_on = [aws_s3_bucket_policy.cloudtrail]
}
