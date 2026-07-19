**Authorship:** agent (reverse-engineered via `fw-init`, brownfield mode), confirmed by operator
**Date:** 2026-07-19
**Version:** v1

# Roadmap — terraform-aws-platform-foundation

Phases below are reconstructed from the 9 closed V2 ORQs (`.framework/orqs-v2/`), frozen and
kept unaltered as historical record. Phase 1 was governance/CI groundwork; Phase 2 was the
first end-to-end multi-stack deployment. Phase 3 is open, derived from the one explicit
pending decision left by ORQ-009.

## Phases

1. **Governance & CI baseline** — `Closed`
   - ORQ-001: tag normalization, module README requirement, Terraform version alignment,
     `prod` structure unblocked (Governance Baseline v1).
   - ORQ-002: migrate `dev/foundation` state to its official key
     (`envs/dev/foundation/terraform.tfstate`).
   - ORQ-003: GitHub OIDC provider + `ci-terraform-plan` role, unblocking CI.
   - ORQ-004: isolate CI identity into its own stack (`envs/global/ci`), decoupled from any
     destroyable dev stack.

2. **Phase 2 — network/compute/data stacks** — `Closed with technical blocker`
   - ORQ-005: `modules/vpc` (subnets, IGW, NAT, S3 endpoint).
   - ORQ-006: `envs/dev/network` stack, applied and destroyed clean (26 resources).
   - ORQ-007: `modules/iam_role` + `envs/dev/compute` (EC2 via SSM), created but not applied.
   - ORQ-008: `envs/dev/data` (S3 bucket + DynamoDB), created but not applied.
   - ORQ-009: integrated apply `network → compute → data`. Network applied cleanly; compute
     failed because `t2.micro` was rejected as non-Free-Tier-eligible; data was never reached
     per the ORQ-009 rule (no partial continuation past a blocker). Partial compute resources
     and network were destroyed and verified clean.
   - **Resolved post-hoc**: commit `62ef2a5` (outside the ORQ log) replaced `t2.micro` with
     `t3.micro` in `envs/dev/compute`, closing ORQ-009's one open decision.

3. **Next: full Phase 2 integrated apply + AI Together V3 operation** — `Open`
   - Re-run the ORQ-009 integrated apply (`network → compute → data`) now that the `t3.micro`
     fix is in place, to get first real end-to-end verification of the Phase 2 stacks.
   - Extend CI plan-checking beyond `envs/dev/foundation` to the other stacks (`network`,
     `compute`, `data`, `global/ci`), currently only `fmt`/`validate`-checked, not planned.
   - Resolve the two legacy tracked plan files (`envs/dev/tfplan`, `envs/dev/destroy.tfplan`)
     predating the state-artifact gitignore convention.
   - Decide and execute the next infrastructure expansion using `fw-plan` under AI Together
     Framework V3, now that the migration from V2 (`enable-framework.sh --migrate`) is complete.

## Aspirational vision (not committed scope)

`.framework/Diagrams/aws-platform-foundation-target-architecture.svg` (pre-existing, kept as
product reference, not part of the AI Together Constitution artifact set) sketches a longer
5-phase target: Phase 4 (multi-cloud — Azure, GCP, Docker) and Phase 5 (multi-region Transit
Gateway peering). These are directional notes only — `lab/azure/` and `lab/google/` today are
disconnected single-file experiments (no remote state, no CI, no integration with `envs/`), and
`mission.md` §Scope excludes them accordingly. Promoting either phase to active roadmap scope
requires its own ORQ once real integration work begins.
