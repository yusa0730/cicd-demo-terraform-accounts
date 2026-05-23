terraform {
  backend "s3" {
    bucket       = "cicd-demo-terraform-stg"
    key          = "baseline/terraform.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}
