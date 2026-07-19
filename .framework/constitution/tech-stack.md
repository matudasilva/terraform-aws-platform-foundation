**Authorship:** agent (reverse-engineered via `fw-init`, brownfield mode), confirmed by operator
**Date:** 2026-07-19
**Version:** v1

# Technical stack — terraform-aws-platform-foundation

## Stack

- **IaC**: Terraform, `required_version >= 1.10.0` (all stacks; required by `use_lockfile = true`
  in S3 backends — native S3 locking replaces DynamoDB lock tables).
- **Provider**: `hashicorp/aws ~> 5.0`.
- **Cloud**: AWS, account `342946498391`, region `us-east-1`, local CLI profile `terraform-lab`.
- **State backend**: S3, bucket `tf-platform-foundation-state-dev-938472`, one state key per
  stack under the convention `envs/<environment>/<stack>/terraform.tfstate`
  (e.g. `envs/dev/foundation/terraform.tfstate`, `envs/global/ci/terraform.tfstate`).
- **CI/CD**: GitHub Actions (`.github/workflows/terraform-ci.yml`) — `terraform fmt -check`,
  `terraform init -backend=false` + `validate` in an isolated `/tmp` workspace, then
  `terraform plan` authenticated via GitHub OIDC (`aws-actions/configure-aws-credentials`,
  no long-lived AWS keys in CI).
- **Repository structure**:
  - `envs/<environment>/<stack>/` — deployable root modules (`dev/foundation`, `dev/network`,
    `dev/compute`, `dev/data`, `global/ci`, `prod/foundation`).
  - `modules/` — reusable modules (`vpc`, `iam_role`, `s3_bucket`), each with its own
    `main.tf`/`variables.tf`/`outputs.tf`/`README.md`.
  - Cross-stack data flow via `terraform_remote_state` (e.g. `dev/compute` and `dev/network`
    read S3 state directly rather than through Terraform workspaces or a monorepo apply).
- **Compute**: EC2 (`al2023` AMI, `t3.micro` — `t2.micro` was rejected by AWS as ineligible for
  Free Tier, fixed in commit `62ef2a5`), accessed via SSM (no SSH), using `modules/iam_role`
  for the instance role/profile.
- **Networking**: `modules/vpc` — public/private subnets across multiple AZs, IGW, optional
  NAT Gateway(s) (single or per-AZ), route tables, S3 Gateway Endpoint.
- **Data**: `modules/s3_bucket` (encrypted, tagged) and DynamoDB table, provisioned in
  `envs/dev/data`.
- **Identity**: GitHub Actions OIDC provider + `ci-terraform-plan` IAM role, isolated in
  `envs/global/ci` (its own state, separate from any destroyable dev stack).

## Constraints

- `terraform fmt -check -recursive` and `terraform validate` are enforced in CI on every push/PR
  touching `envs/**/*.tf` or `modules/**/*.tf`.
- CI only runs `init -backend=false` + `validate` against `envs/dev/foundation`; other stacks are
  not currently plan-checked in CI (evidenced by `terraform-ci.yml` scope).
- State must never be committed (`tfstate`, `tfplan`, `.terraform/` are gitignored); two stray
  plan files (`envs/dev/tfplan`, `envs/dev/destroy.tfplan`) predate that convention and remain
  tracked as legacy debt.
- AWS authentication in CI is OIDC-only; no static AWS credentials are stored as repo secrets.
- Local backend init requires Terraform >= 1.10.0 specifically because of `use_lockfile = true`.

## Technical invariants

- **State key convention** `envs/<environment>/<stack>/terraform.tfstate` — changing it requires
  the same "copy-before-cutover" discipline used in ORQ-002 (copy/verify the S3 object at the
  new key before changing `backend.tf`), never a same-commit atomic rename.
- **Tag baseline** (Governance Baseline v1, ORQ-001): every taggable resource carries
  `project`, `environment`, `managed_by`, `owner`, `component`, `repository` — lowercase,
  underscore-separated keys/values.
- **CI identity stays isolated**: `ci-terraform-plan` and the GitHub OIDC provider live only in
  `envs/global/ci`, deliberately separated from destroyable dev stacks (ORQ-004) so that
  destroying `dev/foundation` (or any dev stack) can never break CI.
- **Module contract**: every module under `modules/` ships `main.tf`, `variables.tf`,
  `outputs.tf`, `README.md`, and must pass `terraform fmt`, `terraform init -backend=false`,
  `terraform validate` before being consumed by a stack (checklist established in ORQ-005).
