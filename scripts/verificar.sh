#!/usr/bin/env bash
set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RAIZ"

requeridos=(
  README.md .env.example AGENTS.md CONTEXTO-PROYECTO.md
  infra/docker-compose.yml infra/vm-linux.md
  docs/arquitectura.md docs/instalacion-local.md docs/instalacion-vm.md
  docs/modelos-remotos.md docs/flujos.md docs/proyectos-referencia.md
  docs/patrones-adoptados.md docs/plan-implementacion.md docs/seguridad.md docs/runbook.md
  scripts/verificar-stack.sh
)

for archivo in "${requeridos[@]}"; do
  [[ -f "$archivo" ]] || { echo "Falta $archivo" >&2; exit 1; }
done

for retirado in config tests infra/telegram-control infra/litellm infra/shotter; do
  [[ ! -e "$retirado" ]] || { echo "Componente antiguo presente: $retirado" >&2; exit 1; }
done

python3 - <<'PY'
from pathlib import Path
import re
import sys

root = Path.cwd()
errors = []
pattern = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
for doc in [root / "README.md", *sorted((root / "docs").glob("*.md")), *sorted((root / "infra").glob("*.md"))]:
    text = doc.read_text(encoding="utf-8")
    for target in pattern.findall(text):
        target = target.split("#", 1)[0]
        if not target or "://" in target or target.startswith("mailto:"):
            continue
        resolved = (doc.parent / target).resolve()
        if not resolved.exists():
            errors.append(f"{doc.relative_to(root)} -> {target}")
if errors:
    print("Enlaces relativos rotos:", *errors, sep="\n- ", file=sys.stderr)
    raise SystemExit(1)
print("Enlaces relativos: OK")
PY

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck scripts/*.sh
  echo "ShellCheck: OK"
else
  echo "ShellCheck: OMITIDO (no instalado)"
fi

if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  docker compose --env-file .env.example -f infra/docker-compose.yml config -q
  echo "Docker Compose: OK"
else
  echo "Docker Compose: OMITIDO (Docker no disponible o daemon sin integrar)"
fi

git diff --check
echo "Estructura y formato: OK"
