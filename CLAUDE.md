# cicd-demo-terraform-accounts

このリポジトリは AWS アカウントの security baseline を管理する Terraform repository。

## 責務

**このrepoで管理する:**
- GuardDuty
- CloudTrail
- AWS Config
- Security Hub
- IAM Password Policy
- Budget Alert

**このrepoで管理しない:**
- ECS / RDS / ALB などのアプリケーション基盤
- GitHub OIDC Provider
- CI/CD IAM Role
- SSM Parameter / Secrets Manager（アプリ用）

上記は別repoで管理する:
- `cicd-demo-terraform` → アプリ基盤
- `cicd-demo-terraform-bootstrap` → OIDC / IAM Role

## ディレクトリ構成

```
baseline/<env>/     # 環境別 baseline ルートモジュール（dev / stg / prod）
modules/baseline/   # baseline 共有モジュール
```

## 最重要ルール

**このrepoの変更はアカウント全体に影響する。**

- prod 変更は必ず追加承認（GitHub Environment approval）を要求する
- baseline リソースの無効化提案は原則禁止
- 以下を削除する提案は不可:
  - Security Hub
  - AWS Config
  - CloudTrail
  - GuardDuty

## 変更時に必ず確認すること

1. `terraform fmt -recursive`
2. `terraform validate`
3. `terraform plan`（変更スコープの確認）
4. prod 変更時は影響範囲を明示する

## 禁止事項

- GuardDuty / CloudTrail / Config / Security Hub の無効化
- IAM Password Policy の緩和
- prod への無承認 apply
- このセッション内で `terraform apply` / `terraform destroy` を直接実行しない
