resource "aws_guardduty_detector" "main" {
  count  = var.guardduty_enabled ? 1 : 0
  enable = true
}
