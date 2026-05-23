module "baseline" {
  source = "../../modules/baseline"

  project = var.project
  env     = var.env

  guardduty_enabled   = true
  securityhub_enabled = false # 有効化すると Security Hub の課金が発生するため、必要に応じて true に変更
  cloudtrail_enabled  = true
  config_enabled      = true

  budget_enabled           = false # 有効化する場合は budget_alert_email も設定すること
  budget_monthly_limit_usd = "10"
  budget_alert_email       = ""
}
