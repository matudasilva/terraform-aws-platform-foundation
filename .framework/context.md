# Contexto del proyecto

## Proyecto

- Nombre:
- Visibilidad del repositorio:
- Política de artefactos del framework:
- Ubicación de memoria operativa:
- Idioma narrativo de la ORQ (`orq_language`):
- Herramientas locales habilitadas:
- Perfil del framework:

## Modelo operativo

Este proyecto usa AI Together Framework V2 con el contexto del proyecto inyectado en tiempo de ejecución.

La visibilidad del repositorio no define la política de artefactos del framework.

## Contrato versionado

- Artefactos del framework versionados explícitamente:
- Artefactos del framework solo locales:
- Límite de fuente pública:
- Project Context Source declarada en `.framework/project-config.yml`:
- Governance Sync Targets declarados en `.framework/project-config.yml`:
- Regla de estados: `Local Closure` no implica `Governance Sync: Synced`

## Estado actual

- ORQ activa: (Ninguna)
- ORQ cerrada: ORQ-003 (OIDC Provider setup para GitHub Actions) ✅ CLOSED 2026-06-10
- ORQ cerrada: ORQ-001 (Governance Baseline v1 alignment) ✅ CLOSED 2026-05-26
- Status: Ejecución completada, Execution Review passed, Closure completado
- ORQ location: `.framework/orq/ORQ-001-governance-baseline-v1/`
- Resultado: 5/5 tasks completadas, Learning Payload preparado
- ORQ-002 location: `.framework/orq/ORQ-002-backend-key-dev-migration/`
- ORQ-003 location: `.framework/orq/ORQ-003-oidc-provider-ci-role/`
- Próximo paso: definir siguiente ORQ

## Restricciones

- Los secretos no deben almacenarse en artefactos del framework.
- No preparar ni commitear artefactos del framework solo locales salvo autorización explícita.
- Los repositorios públicos o potencialmente públicos deberían mantener los artefactos privados de orquestación solo locales o híbridos.
- Una fuente externa de contexto puede alojar contexto humano y reporting gobernado, pero no reemplaza las herramientas locales ejecutables ni vuelve source-first la creación de ORQs.
- `learning_sync` y `dashboard_sync` son contratos separados; no mezclar aprendizaje reusable con observabilidad operativa.
- `fw-close` debe dejar syncs `Prepared` o `Pending` cuando solo existan payloads; usar `fw-governance-sync` para el update real del destino.
- `fw-governance-sync` es un comando explícito y no un efecto automático del cierre o del primer contacto.
- Los `Governance Sync Targets` compartidos son un contrato canónico del Framework; este proyecto solo los materializa en `.framework/project-config.yml` para ejecución determinística.

## Notas

Actualizar este archivo solo con contexto operativo durable cuando pertenezca al Contrato versionado elegido. No usarlo para secretos ni para registros transitorios.
Si el proyecto usa una fuente externa de contexto, declararla en `.framework/project-config.yml` para que agentes con visibilidad del repo puedan descubrir ese contexto sin búsqueda ambigua y sincronizar governance/reporting cuando corresponda.
