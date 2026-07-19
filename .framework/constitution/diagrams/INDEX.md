# Diagrams Index — terraform-aws-platform-foundation

| tipo | alcance | archivo | generado/manual | última actualización | refresh_pending | refresh_baseline |
|---|---|---|---|---|---|---|
| context | producto | `context.svg` | auto-generado | 2026-07-19 | no | `sha256:704a184a28cb16e4f498a3e889a39a053906e52964fb460b94ecccb04dcd9876` |
| architecture | framework | `architecture.svg` | auto-generado | 2026-07-19 | no | `sha256:704a184a28cb16e4f498a3e889a39a053906e52964fb460b94ecccb04dcd9876` |
| deployment | producto | `deployment.svg` | manual | 2026-07-19 | no | `sha256:704a184a28cb16e4f498a3e889a39a053906e52964fb460b94ecccb04dcd9876` |

## Notes

`structural.svg` and `behavior.svg` were evaluated as applicable by the `fw-init` complexity
gate (real product modules in `mission.md` §Scope; ordered phase dependencies in `roadmap.md`)
but deferred by operator decision, to avoid duplicating information already covered elsewhere.

`deployment.svg` (moved from `.framework/Diagrams/aws-platform-foundation-target-architecture.svg`
into this directory and registered here) is a manual, pre-existing product diagram — VPC/subnet
layout across regions, per-stack breakdown, and the phase roadmap (including the aspirational
multi-cloud Phase 4/5 sketch noted in `roadmap.md` §Aspirational vision). Its overlapping/clipped
text was reframed in this same session (no content change). Being manual, it is not regenerated
by `fw-init`/`fw-replan` tooling; content updates remain a manual edit, with `refresh_pending`
tracked here against the same Constitution-source signature as the auto-generated diagrams.
