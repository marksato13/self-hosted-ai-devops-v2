# Instrucciones para agentes

## Proyecto

Plataforma autohospedada basada en OpenHands Agent Canvas y OmniRoute. Se ejecuta con Docker en una laptop o VM Linux. Usa únicamente modelos remotos; no incluye modelos locales.

## Reglas

1. Escribir documentación, comentarios y commits en español.
2. Nunca guardar claves, tokens, cookies ni `.env` en Git.
3. No hacer push directo a `main` ni fusionar PR sin aprobación humana.
4. Tratar al agente y sus comandos como código no confiable.
5. Mantener Agent Canvas y OmniRoute en loopback; el acceso remoto usa SSH o Tailscale.
6. Para infraestructura, automatizar `plan`, `check` y `diff`; pedir aprobación para `apply`, despliegues y acciones destructivas.
7. No agregar Telegram, OpenClaw, Ollama, LiteLLM ni otro orquestador sin una decisión explícita.
8. No describir como verificado aquello que solo sea una plantilla.

## Estructura

```text
infra/    Compose, systemd y especificación de VM
docs/     arquitectura, instalación, modelos, seguridad y operación
scripts/  preparación y verificación
```

## Verificación

```bash
./scripts/verificar.sh
```

Si Docker está disponible, también debe pasar:

```bash
docker compose --env-file .env.example -f infra/docker-compose.yml config -q
```
