#!/usr/bin/env bash
set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$RAIZ/.env"
ENV_EXAMPLE="$RAIZ/.env.example"

command -v openssl >/dev/null 2>&1 || {
  echo "Falta openssl." >&2
  exit 1
}

if [[ ! -f "$ENV_FILE" ]]; then
  cp "$ENV_EXAMPLE" "$ENV_FILE"
  echo "Creado .env desde .env.example"
fi
chmod 600 "$ENV_FILE"

# Ajusta el marcador de usuario solo en la copia privada.
sed -i "s|/home/CAMBIAR|$HOME|g" "$ENV_FILE"

generar_si_vacio() {
  local clave="$1" valor
  if grep -q "^${clave}=$" "$ENV_FILE"; then
    valor="$(openssl rand -hex 32)"
    sed -i "s|^${clave}=$|${clave}=${valor}|" "$ENV_FILE"
    echo "Generado: $clave"
  fi
}

for clave in \
  LOCAL_BACKEND_API_KEY \
  OH_SECRET_KEY \
  OMNIROUTE_JWT_SECRET \
  OMNIROUTE_API_KEY_SECRET \
  OMNIROUTE_STORAGE_ENCRYPTION_KEY \
  OMNIROUTE_INITIAL_PASSWORD; do
  generar_si_vacio "$clave"
done

leer_variable() {
  local clave="$1"
  sed -n "s|^${clave}=||p" "$ENV_FILE" | tail -n 1
}

OPENHANDS_DATA_DIR="$(leer_variable OPENHANDS_DATA_DIR)"
PROJECTS_DIR="$(leer_variable PROJECTS_DIR)"
[[ -n "$OPENHANDS_DATA_DIR" ]] && mkdir -p "$OPENHANDS_DATA_DIR"
[[ -n "$PROJECTS_DIR" ]] && mkdir -p "$PROJECTS_DIR"

echo "Preparación terminada. Revisa .env y no lo agregues a Git."
