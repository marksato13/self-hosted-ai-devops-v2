# Instalación local y WSL2

## Opción recomendada

Usar Docker evita que el agente se ejecute directamente con todos los permisos del usuario. En Windows, Docker Desktop debe tener habilitada la integración con la distribución WSL2.

## Requisitos

- Windows 11 + WSL2 y Docker Desktop, o Linux/macOS con Docker Engine.
- Git y OpenSSL.
- 4 CPU lógicas, 8 GB de RAM disponibles y 20 GB de disco.
- Proyectos guardados en un directorio dedicado.

## Windows + WSL2

1. Abre Docker Desktop.
2. Ve a **Settings → Resources → WSL Integration**.
3. Habilita la distribución usada por este repositorio y pulsa **Apply & restart**.
4. Comprueba desde WSL:

```bash
docker version
docker compose version
docker run --rm hello-world
```

Para mejor rendimiento, los repositorios de trabajo pueden vivir dentro del filesystem Linux (`~/projects`) en vez de `/mnt/c`, especialmente si tienen muchas dependencias.

## Preparar el proyecto

```bash
cp .env.example .env
./scripts/preparar.sh
```

El script crea los directorios indicados y completa secretos locales vacíos. Revisa `.env` y cambia `CAMBIAR` por tu usuario si fuese necesario.

## Arrancar

```bash
docker compose --env-file .env -f infra/docker-compose.yml pull
docker compose --env-file .env -f infra/docker-compose.yml up -d
docker compose --env-file .env -f infra/docker-compose.yml ps
```

Abre:

- Agent Canvas: `http://localhost:8000/canvas`
- OmniRoute: `http://localhost:20128`

Ambos puertos escuchan solo en loopback.

## Configuración inicial

1. En OmniRoute, inicia sesión con `OMNIROUTE_INITIAL_PASSWORD`.
2. Conecta un único proveedor autorizado y comprueba su cuota y precio vigentes.
3. Crea una API key local de OmniRoute.
4. En Agent Canvas abre **Settings → LLM → Advanced**.
5. Configura el ID exacto del modelo, la API key local y la URL interna `http://omniroute:20128/v1` como se describe en [modelos remotos](modelos-remotos.md).
6. Abre como workspace una carpeta ubicada bajo `/projects`.
7. Ejecuta primero una tarea de lectura o un cambio descartable.

No uses `localhost` como URL base en Canvas: dentro del contenedor, ese nombre apunta al propio Canvas y no a OmniRoute.

## Detener y actualizar

```bash
docker compose --env-file .env -f infra/docker-compose.yml down
docker compose --env-file .env -f infra/docker-compose.yml pull
docker compose --env-file .env -f infra/docker-compose.yml up -d
```

Antes de actualizar en un entorno importante, fija `OPENHANDS_IMAGE` a una versión comprobada y respalda `OPENHANDS_DATA_DIR` y el volumen `omniroute-data`.
