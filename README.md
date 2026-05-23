# terraform-accounts

AWS アカウントのセキュリティベースラインを Terraform で管理するリポジトリです。

## このリポジトリの責務

AWSアカウントごとに必要なセキュリティ基盤を管理します。
アプリ実行基盤（ECS・RDS・ALB）は [terraform-repo](../terraform-repo) で管理します。

| リポジトリ | 責務 |
|-----------|------|
| `terraform-accounts`（このリポジトリ） | GuardDuty・CloudTrail・Config・IAM Password Policy 等のアカウントセキュリティ基盤 |
| `terraform-repo` | VPC・ECS・RDS・ALB・ECR 等のアプリ実行基盤 |
| `app-repo` | アプリケーションコード・ECS デプロイ |

## 管理リソース

| リソース | dev | stg | prod |
|---------|-----|-----|------|
| IAM Password Policy | ✅ | ✅ | ✅ |
| GuardDuty | ✅ | ✅ | ✅ |
| CloudTrail | ✅ | ✅ | ✅ |
| AWS Config | ✅ | ✅ | ✅ |
| Security Hub | ❌ | ❌ | ✅ |
| Budget Alert | ❌ | ❌ | ✅ |

---

## はじめに

### 前提条件

- `terraform-repo` の `bootstrap/<env>` が完了していること
- bootstrap の Step Summary に表示された `accounts_plan_role_arn` / `accounts_apply_role_arn` を GitHub Secrets/Environments に登録済みであること

---

### Step 1: GitHub に Secrets / Environments を登録する

bootstrap 完了後の Step Summary に表示された ARN を以下に登録します。

#### terraform-accounts の Repository Secrets

`Settings → Secrets and variables → Actions → Repository secrets`

| Secret 名 | 値 |
|-----------|---|
| `AWS_ACCOUNTS_PLAN_ROLE_ARN_DEV` | bootstrap Step Summary の `accounts_plan_role_arn`（dev） |
| `AWS_ACCOUNTS_PLAN_ROLE_ARN_STG` | bootstrap Step Summary の `accounts_plan_role_arn`（stg） |
| `AWS_ACCOUNTS_PLAN_ROLE_ARN_PROD` | bootstrap Step Summary の `accounts_plan_role_arn`（prod） |

#### terraform-accounts の GitHub Environments

`Settings → Environments` で `dev` / `stg` / `prod` を作成します。

| Environment | Secret 名 | 値 |
|------------|-----------|---|
| `dev` | `AWS_ACCOUNTS_ROLE_ARN` | bootstrap Step Summary の `accounts_apply_role_arn`（dev） |
| `stg` | `AWS_ACCOUNTS_ROLE_ARN` | bootstrap Step Summary の `accounts_apply_role_arn`（stg） |
| `prod` | `AWS_ACCOUNTS_ROLE_ARN` | bootstrap Step Summary の `accounts_apply_role_arn`（prod） |

`prod` Environment には Required reviewers を設定します。

---

### Step 2: CODEOWNERS を設定する

現在は個人アカウント（`@yusa0730`）で設定済みです。

```
/baseline/          @yusa0730
/modules/           @yusa0730
/.github/workflows/ @yusa0730
/.github/CODEOWNERS @yusa0730
```

#### Team 運用への移行（Organization がある場合）

複数人でレビューを運用する際は、個人ユーザーの代わりに GitHub Team を指定します。

**Team の作成手順**

```
1. github.com/<your-org> → Teams → New team
     Team name: infra-approvers
     Visibility: Visible（← CODEOWNERS 参照に必須）

2. Teams → infra-approvers → Members → Add a member
     → レビュアーを追加

3. Teams → infra-approvers → Repositories → Add repository
     → このリポジトリを追加
     → Role: Write（← CODEOWNERS 機能に必須）
```

**CODEOWNERS の書き換え**

```
/baseline/          @your-org/infra-approvers
/modules/           @your-org/infra-approvers
/.github/workflows/ @your-org/infra-approvers
/.github/CODEOWNERS @your-org/infra-approvers
```

> `@your-org` は Organization 名、`infra-approvers` は Team 名に置き換えてください。

---

### Step 3: Branch Protection Rules を設定する

`Settings → Branches → Add branch ruleset` で `develop` / `stg` / `prod` を設定します。

| 項目 | 値 |
|-----|---|
| Require a pull request before merging | ✅ |
| Require approvals | ✅（1 以上） |
| Require review from Code Owners | ✅ |
| Require status checks to pass before merging | ✅ |
| Required status checks | `baseline-plan / fmt`、`baseline-plan / plan` |

---

### Step 4: 動作確認

```
1. feature ブランチを作成して develop へ PR を出す
   → baseline-plan が自動実行される
   → tfsec / checkov / conftest によるセキュリティチェックが実行される
   → PR コメントに plan 結果が表示される

2. CODEOWNERS (infra-approvers) が approve → develop へ merge する
   → baseline-apply が自動実行される
   → dev アカウントにセキュリティベースラインが適用される

3. develop → stg / stg → prod の順に PR を出して merge する
   → prod は承認ゲートあり（plan 内容確認後に「Approve and deploy」）
```

---

## ディレクトリ構成

```
baseline/
├── dev/       dev アカウントのベースライン設定
├── stg/       stg アカウントのベースライン設定
└── prod/      prod アカウントのベースライン設定

modules/
└── baseline/  ベースラインモジュール本体

policy/
└── terraform.rego  conftest OPA ポリシー（local-exec 等を禁止）
```

---

## ドキュメント

| ドキュメント | 内容 |
|------------|------|
| [アーキテクチャ](../terraform-repo/docs/architecture.md) | AWS 構成・ネットワーク・ECS・RDS・IAM の詳細 |
| [CI/CD](../terraform-repo/docs/cicd.md) | Workflows 一覧・Secrets 一覧 |
