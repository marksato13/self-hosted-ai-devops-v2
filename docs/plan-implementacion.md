# Plan de implementación

Este plan convierte la arquitectura de V2 en una instalación comprobada. No se
avanza de fase si su verificación no pasó.

Estado local al 22 de agosto de 2026: la fase 1 pasó para el Compose de
desarrollo. Las comprobaciones manuales restantes de la fase 0 y toda la fase 2
siguen pendientes; esta última requiere iniciar sesión, conectar un proveedor
autorizado, crear una API key local y ejecutar una tarea inocua.

## Fase 0 · Base y seguridad

1. Habilitar Docker Desktop → WSL Integration, o preparar una VM Ubuntu 24.04.
2. Clonar V2, copiar `.env.example` y ejecutar `./scripts/preparar.sh`.
3. Instalar `pre-commit` y ejecutar `pre-commit run --all-files`.

**Verifica:** `.env` está en modo `600`, Docker responde y no hay secretos
versionados.

## Fase 1 · Servicios mínimos

1. Fijar una versión probada de `OPENHANDS_IMAGE`; no usar `latest` en la VM.
2. Levantar `omniroute` y `agent-canvas` con Compose.
3. Confirmar que ambos servicios escuchan solo en `127.0.0.1`.

**Verifica:** `./scripts/verificar-stack.sh`, logs sin reinicios y acceso local a Canvas.

## Fase 2 · Modelo y tarea inocua

1. Conectar un único proveedor permitido en OmniRoute.
2. Crear su API key local y configurar un perfil OpenAI-compatible en Canvas.
3. Probar una tarea de lectura en un repositorio de ejemplo bajo `PROJECTS_DIR`.

**Verifica:** respuesta correcta, coste/cuota registrados y ningún archivo fuera
del workspace.

## Fase 3 · Desarrollo revisable

1. Usar una rama de prueba y pedir un cambio pequeño con su prueba.
2. Exigir el contrato de resultado de [patrones adoptados](patrones-adoptados.md).
3. Ejecutar tests, linter y Gitleaks fuera del agente antes de revisar el diff.

**Verifica:** existe un parche o PR sin secretos; una persona decide el merge.

## Fase 4 · Infraestructura y operaciones

1. Empezar solo con `plan`, `check`, `diff` y comandos de lectura.
2. Añadir herramientas una por una a una imagen/sandbox dedicada.
3. Documentar rollback antes de cualquier `apply` o despliegue.

**Verifica:** el agente no recibe credenciales productivas ni puede aplicar
cambios desde el sandbox.

## Fase 5 · Operación continua

1. Migrar a VM dedicada, mantener acceso SSH o Tailscale y crear backups.
2. Configurar límites por proveedor y revisar uso semanalmente.
3. Tras cada actualización, repetir las fases 1 a 3 con un proyecto de prueba.

**Verifica:** reinicio recuperable, copia de seguridad restaurable y auditoría de
los cambios realizada.
