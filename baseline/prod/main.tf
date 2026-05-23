module "baseline" {
  source = "../../modules/baseline"

  project = var.project
  env     = var.env

  guardduty_enabled   = true
  securityhub_enabled = true # prod は Security Hub を有効化
  cloudtrail_enabled  = true
  config_enabled      = true

  budget_enabled           = true # prod は予算アラートを有効化
  budget_monthly_limit_usd = "100"
  budget_alert_email       = "" # 通知先メールアドレスを設定すること
}
