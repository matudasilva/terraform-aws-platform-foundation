# learnings.md — plantilla

Fuente de aprendizajes por repo (draft V3 §14.2, nivel 1). Cada entrada la escribe `fw-replan`
al cerrar una ORQ. No se edita a mano el digest cruzado (eso es un artefacto generado, ver
`framework/local-tools/fw_learnings_digest.py`) — pero esta lista de entradas sí es editable
por el operador para corregir o confirmar `scope_confirmed`.

```yaml
- date: YYYY-MM-DD
  orq: ORQ-NN
  category: process        # process | technical | governance | tooling
  summary: "Descripción breve y concreta del aprendizaje."
  evidence: .framework/orqs/ORQ-NN/validation.md
  scope_proposed: project-only        # project-only | framework-candidate
  scope_confidence: media             # baja | media | alta
  scope_rationale: >
    Por qué fw-replan propuso este scope: recurrencia, capa que toca, colisión con invariante,
    severidad.
  scope_confirmed: null                # null hasta que el operador confirme en lote
  authored_by:
    - agent: "Claude (modelo)"
      role: replan
```

## Campos

- `date` — fecha de cierre de la ORQ que originó el aprendizaje.
- `orq` — identificador de la ORQ (`ORQ-NN`).
- `category` — una de `process`, `technical`, `governance`, `tooling`.
- `summary` — una frase concreta, no genérica ("el design review sin revisor distinto del autor
  dejó pasar X", no "mejorar el proceso de revisión").
- `evidence` — ruta al archivo de evidencia (normalmente `validation.md` de la ORQ origen).
- `scope_proposed` / `scope_confidence` / `scope_rationale` — propuesta asistida de `fw-replan`
  (draft §14.5), nunca automática.
- `scope_confirmed` — `null` hasta confirmación explícita del operador; luego pasa a
  `project-only` o `framework-candidate`. Solo `framework-candidate` confirmado entra al digest
  cruzado (§14.2 nivel 2).
- `authored_by` — atribución estructural (draft §6.1), poblada por la Skill que genera la
  entrada, no a mano.
