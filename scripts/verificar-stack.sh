#!/usr/bin/env bash
set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RAIZ"

[[ -f .env ]] || { echo "Falta .env; créalo localmente antes de verificar el stack" >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "Docker no está disponible" >&2; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "Docker Compose no está disponible" >&2; exit 1; }

compose=(docker compose --env-file .env -f infra/docker-compose.yml)
"${compose[@]}" config -q

for servicio in omniroute agent-canvas; do
  if ! "${compose[@]}" ps --status running --services | grep -Fxq "$servicio"; then
    echo "$servicio no está en ejecución" >&2
    exit 1
  fi
done

comprobar_loopback() {
  local servicio="$1"
  local puerto="$2"
  local publicado

  publicado="$("${compose[@]}" port "$servicio" "$puerto")"
  case "$publicado" in
    127.0.0.1:* | "[::1]:"*) ;;
    *) echo "$servicio:$puerto no está publicado solo en loopback: $publicado" >&2; exit 1 ;;
  esac
}

comprobar_loopback omniroute 20128
comprobar_loopback agent-canvas 8000

contenedor_omniroute="$("${compose[@]}" ps -q omniroute)"
estado_salud="$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}sin-healthcheck{{end}}' "$contenedor_omniroute")"
[[ "$estado_salud" == "healthy" ]] || { echo "OmniRoute no está saludable: $estado_salud" >&2; exit 1; }

contenedor_canvas="$("${compose[@]}" ps -q agent-canvas)"
docker exec "$contenedor_canvas" python -c \
  'import socket; socket.create_connection(("omniroute", 20128), timeout=5).close()'

echo "Stack activo, saludable, limitado a loopback y con conectividad interna: OK"
