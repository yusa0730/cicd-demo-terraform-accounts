output "guardduty_detector_id" {
  description = "GuardDuty Detector ID"
  value       = var.guardduty_enabled ? aws_guardduty_detector.main[0].id : null
}

output "cloudtrail_arn" {
  description = "CloudTrail ARN"
  value       = var.cloudtrail_enabled ? aws_cloudtrail.main[0].arn : null
}

output "cloudtrail_bucket_name" {
  description = "S3 bucket name for CloudTrail logs"
  value       = var.cloudtrail_enabled ? aws_s3_bucket.cloudtrail[0].bucket : null
}

output "config_recorder_name" {
  description = "AWS Config recorder name"
  value       = var.config_enabled ? aws_config_configuration_recorder.main[0].name : null
}

output "config_bucket_name" {
  description = "S3 bucket name for AWS Config delivery"
  value       = var.config_enabled ? aws_s3_bucket.config[0].bucket : null
}
