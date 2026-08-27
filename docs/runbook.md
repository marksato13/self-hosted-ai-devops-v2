# Operación y diagnóstico

Todos los comandos se ejecutan desde la raíz del repositorio.

## Estado

```bash
./scripts/verificar-stack.sh
docker compose --env-file .env -f infra/docker-compose.yml ps
docker compose --env-file .env -f infra/docker-compose.yml logs --tail=100 agent-canvas
docker compose --env-file .env -f infra/docker-compose.yml logs --tail=100 omniroute
```

La verificación automatizada no carga ni muestra claves. Los logs pueden contener datos de solicitudes; revísalos localmente y no los publiques sin sanearlos.

## Reinicio

```bash
docker compose --env-file .env -f infra/docker-compose.yml restart agent-canvas
docker compose --env-file .env -f infra/docker-compose.yml restart omniroute
```

## Problemas frecuentes

| Síntoma | Revisar |
|---|---|
| Docker no existe en WSL | integración de Docker Desktop con esa distribución |
| Canvas no abre | contenedor, puerto 8000 y URL `/canvas` |
| Canvas responde 502 o el backend está desconectado | permisos de `OPENHANDS_DATA_DIR`, `LOCAL_BACKEND_API_KEY` y logs de Agent Canvas |
| Modelo no valida | ID exacto, base URL desde el contenedor y API key |
| OmniRoute devuelve 429 | cuota del proveedor o límite de concurrencia |
| El agente no ve un proyecto | que esté bajo `PROJECTS_DIR` y abierto como `/projects/...` |
| RAM agotada | reducir a una tarea, revisar logs y ampliar la VM |

En Linux, si los logs indican `unable to open database file`, instala `acl` y vuelve a ejecutar `./scripts/preparar.sh`. La verificación comprueba tanto la UI pública como el Agent Server interno y fallará mientras el backend no esté disponible.

## Respaldo

Detén el stack antes de un respaldo consistente:

```bash
docker compose --env-file .env -f infra/docker-compose.yml down
```

Respalda `OPENHANDS_DATA_DIR`, los repositorios y el volumen de OmniRoute. En una VM, toma snapshot solo como complemento; no reemplaza un backup independiente.

## Actualización

1. Revisa notas de la versión.
2. Respalda estado.
3. Fija una etiqueta probada en `OPENHANDS_IMAGE`.
4. Ejecuta `docker compose pull` y `up -d`.
5. Comprueba UI, perfil LLM y una tarea de prueba.
6. Conserva el estado anterior hasta validar.

## Incidente

Si el agente ejecuta acciones inesperadas:

1. Detén `agent-canvas`.
2. Revoca las credenciales que pudo leer.
3. Revisa cambios, logs y procesos.
4. Restaura el workspace o snapshot si corresponde.
5. Reduce montajes y permisos antes de reiniciar.
