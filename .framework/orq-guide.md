# Guía de ORQs — Framework V2

Las **Orchestration Requests (ORQs)** son unidades de trabajo estructuradas del Framework AI Together V2. Este proyecto las aloja en `.framework/orq/`.

## Ubicación y estructura

```
.framework/orq/
├── INDEX.md                          # Índice central de ORQs
├── ORQ-001-governance-baseline-v1/   # ORQ específica
│   ├── README.md                     # Descripción ejecutiva
│   ├── spec.md                       # Contrato de diseño
│   ├── acceptance.md                 # Criterios de aceptación
│   ├── tasks.md                      # Tablero de tareas
│   ├── review.md                     # Design Review
│   ├── execution-review.md           # Execution Review
│   └── closure.md                    # Cierre y decisiones
└── ...
```

## Lifecycle de una ORQ

### 1. **Design** (Pre-ejecución)
- Crear `spec.md` con contrato de diseño
- Crear `acceptance.md` con criterios verificables
- Crear `tasks.md` con tareas ejecutables

### 2. **Design Review**
- Revisar scope, criterios, riesgos
- Documento: `review.md`
- Decisión: ✅ APROBADO o ❌ RECHAZADO

### 3. **Execution**
- Ejecutar tasks 1-N según `tasks.md`
- Documentar evidencia
- Commit a git (si aplica)

### 4. **Execution Review**
- Verificar todas las tasks contra `acceptance.md`
- Documento: `execution-review.md`
- Decisión: ✅ PASSED o ❌ FAILED

### 5. **Closure**
- Documentar aprendizajes en `closure.md`
- Preparar Learning Sync Payload
- Documentar Governance Sync targets
- Decidir próximo paso

## Convenciones de naming

- ORQ ID: `ORQ-NNN` (numérico, secuencial)
- Directorio: `ORQ-NNN-descriptivo-kebab-case`
- Ejemplo: `ORQ-001-governance-baseline-v1`

## Cambios recientes

- **2026-05-26**: ORQ-001 movida de `.claude/orq/` a `.framework/orq/` para alineación con convención Framework V2
- Ubicación anterior: `.claude/orq/ORQ-001-governance-baseline-v1/` ❌ (deprecated)
- Ubicación actual: `.framework/orq/ORQ-001-governance-baseline-v1/` ✅

## Próximas ORQs

Después de cerrar ORQ-001:
- ORQ-002: Nuevos módulos de infraestructura
- ORQ-003: CI/CD gates automáticos
- ORQ-004: VPC y networking baseline

(Definidas en `closure.md` de ORQ-001)

## Recursos

- **INDEX.md** — Índice central de ORQs activas y cerradas
- **context.md** — Estado actual del proyecto
- **framework-reference.md** — Referencia del Framework
