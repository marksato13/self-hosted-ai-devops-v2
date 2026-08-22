# Contexto del proyecto

## Objetivo actual

Construir una plataforma personal de agentes IA autohospedada, operada desde una interfaz web y desplegable en una laptop o una VM Linux. Su prioridad es desarrollo de software, con perfiles adicionales para infraestructura, seguridad, operaciones y documentación.

## Decisiones vigentes

- OpenHands Agent Canvas es la interfaz y el orquestador principal.
- OmniRoute es el gateway único de modelos.
- Por ahora solo se usan modelos remotos; no se despliega Ollama ni otra inferencia local.
- Docker delimita los workspaces accesibles.
- El acceso remoto es privado mediante túnel SSH o Tailscale.
- No hay Telegram, OpenClaw ni bot de mensajería.
- No se despliegan Open SWE, Cyrus, Opendray o SWE-agent como plataformas paralelas. Sus patrones pueden estudiarse más adelante.
- El gasto adicional objetivo es USD 0, sin asumir que una ruta externa sea gratuita o ilimitada.
- Una persona aprueba merges, despliegues, `apply` y cualquier acción destructiva.

## Estado real

La arquitectura y las plantillas fueron rediseñadas el 2026-08-22. El Compose aún no fue levantado en esta WSL porque Docker Desktop no tiene habilitada su integración con la distribución. Por ello el repositorio describe una propuesta preparada, no una instalación validada de punta a punta.

## Próximo hito

1. Habilitar Docker en WSL2 o preparar la VM Ubuntu.
2. Copiar `.env.example` a `.env` y ejecutar `./scripts/preparar.sh`.
3. Levantar el Compose.
4. Configurar proveedores gratuitos en OmniRoute.
5. Crear un perfil LLM de OpenHands contra `http://omniroute:20128/v1`.
6. Probar una tarea de desarrollo pequeña y registrar consumo, calidad y límites.
