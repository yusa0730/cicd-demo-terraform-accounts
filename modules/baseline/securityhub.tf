resource "aws_securityhub_account" "main" {
  count = var.securityhub_enabled ? 1 : 0

  auto_enable_controls     = true
  enable_default_standards = true
}
