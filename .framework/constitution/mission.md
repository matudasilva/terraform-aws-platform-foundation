**Authorship:** agent (reverse-engineered via `fw-init`, brownfield mode), confirmed by operator
**Date:** 2026-07-19
**Version:** v1

# Mission — terraform-aws-platform-foundation

## What it is

A personal Infrastructure as Code lab that builds a production-style AWS platform foundation
with Terraform: multi-environment stacks (`dev`, `prod`, `global`), reusable modules, remote
state in S3 with native locking, GitHub Actions CI with OIDC-based AWS authentication, and a
governance baseline for tagging and module documentation. The `lab/azure` and `lab/google`
directories hold unrelated exploratory Terraform for other clouds, outside this project's scope.

## Who it serves

The repository owner, practicing and demonstrating production-grade IaC patterns (remote state
management, module reusability, CI/CD with short-lived OIDC credentials, governance/tagging
conventions). There is no external team or client consuming this infrastructure.

## Why it exists

To build hands-on depth in professional Terraform/AWS practices — the kind of structural
decisions (state key conventions, stack separation, module contracts, tag governance) that
matter in real platform engineering — through an evolving, real (not toy) codebase, evidenced
by the sequence of 9 closed V2 ORQs that progressively hardened the repo's structure and
governance.

## Scope

**Included:**
- Terraform modules under `modules/` (`vpc`, `iam_role`, `s3_bucket`) and the environment stacks
  under `envs/` (`dev/foundation`, `dev/network`, `dev/compute`, `dev/data`, `global/ci`,
  `prod/foundation`).
- Remote state management in S3 (per-stack state keys, locking).
- GitHub Actions CI (`terraform-ci.yml`): fmt, validate, and OIDC-authenticated plan.
- Tagging and module-documentation governance (Governance Baseline v1, closed in ORQ-001).
- AI Together Framework orchestration artifacts (`.framework/`) for this repo's own workflow.

**Excluded:**
- `lab/azure/` and `lab/google/` — unrelated single-file explorations for other cloud providers,
  not part of the AWS platform foundation.
- Any application workload or business logic — this repo provisions platform infrastructure
  only, not the systems that would run on top of it.
- Multi-tenant or multi-team governance — the project has a single operator; no RBAC or
  organizational access model is in scope.
