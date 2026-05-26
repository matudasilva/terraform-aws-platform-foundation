# AGENTS

## Purpose

This project uses AI Together Framework V2 for scoped orchestration, task execution, review, and closure.

## Context Precedence

1. `.framework/context.md`
2. Versioned project documentation
3. ORQ and task documents
4. External human memory only when explicitly referenced

## Operating Rules

- Do not execute framework prompts without project context.
- Keep changes scoped to the active ORQ or task.
- Do not include secrets in framework artifacts.
- Do not stage or commit local-only framework artifacts unless explicitly authorized.
- Repo visibility does not define Framework Artifact Policy.
- If the repository is public or may become public, keep private orchestration artifacts local-only.
