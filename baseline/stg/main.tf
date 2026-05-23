module "baseline" {
  source = "../../modules/baseline"

  project = var.project
  env     = var.env

  guardduty_enabled   = true
  securityhub_enabled = false
  cloudtrail_enabled  = true
  config_enabled      = true

  budget_enabled           = false
  budget_monthly_limit_usd = "10"
  budget_alert_email       = ""
}
