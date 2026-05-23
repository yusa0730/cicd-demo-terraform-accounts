variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment name (dev / stg / prod)"
  type        = string
}

variable "guardduty_enabled" {
  description = "Enable GuardDuty threat detection"
  type        = bool
  default     = true
}

variable "securityhub_enabled" {
  description = "Enable Security Hub (有効化すると AWS Security Hub の課金が発生する)"
  type        = bool
  default     = false
}

variable "cloudtrail_enabled" {
  description = "Enable CloudTrail audit logging"
  type        = bool
  default     = true
}

variable "config_enabled" {
  description = "Enable AWS Config configuration recorder"
  type        = bool
  default     = true
}

variable "budget_enabled" {
  description = "Enable monthly budget alert"
  type        = bool
  default     = false
}

variable "budget_monthly_limit_usd" {
  description = "Monthly budget limit in USD"
  type        = string
  default     = "10"
}

variable "budget_alert_email" {
  description = "Email address for budget alert notifications"
  type        = string
  default     = ""
}
