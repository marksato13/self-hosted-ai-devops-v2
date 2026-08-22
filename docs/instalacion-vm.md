# Instalación en una VM Linux

Esta guía sirve para VMware ESXi, Proxmox VE, Hyper-V, VirtualBox, KVM u otro hipervisor. La plataforma no depende del hipervisor.

## 1. Crear la VM

Usa la especificación de [infra/vm-linux.md](../infra/vm-linux.md). Instala Ubuntu Server 24.04 LTS con OpenSSH. Toma un snapshot limpio antes de instalar el stack.

## 2. Preparar Ubuntu

```bash
sudo apt update && sudo apt -y upgrade
sudo apt install -y ca-certificates curl git openssl ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw --force enable
```

No abras 8000 ni 20128 en `ufw` si usarás un túnel SSH o Tailscale.

## 3. Instalar Docker

Sigue el repositorio oficial de Docker para Ubuntu o, para una prueba inicial:

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"
```

Cierra la sesión SSH y vuelve a entrar. Verifica:

```bash
docker version
docker compose version
docker run --rm hello-world
```

## 4. Clonar y configurar

```bash
mkdir -p ~/platform ~/projects
cd ~/platform
git clone https://github.com/marksato13/self-hosted-ai-devops.git
cd self-hosted-ai-devops
cp .env.example .env
sed -i "s|/home/CAMBIAR|$HOME|g" .env
./scripts/preparar.sh
chmod 600 .env
```

## 5. Levantar servicios

```bash
docker compose --env-file .env -f infra/docker-compose.yml pull
docker compose --env-file .env -f infra/docker-compose.yml up -d
docker compose --env-file .env -f infra/docker-compose.yml ps
```

Para inicio automático, Docker usa `restart: unless-stopped`. Si prefieres que systemd gestione el Compose, instala la plantilla y sustituye su ruta:

```bash
sed "s|__INSTALL_DIR__|$PWD|g" infra/systemd/agent-platform.service \
  | sudo tee /etc/systemd/system/agent-platform.service >/dev/null
sudo systemctl daemon-reload
sudo systemctl enable --now agent-platform.service
sudo systemctl status agent-platform.service
```

## 6. Acceso privado

### Túnel SSH

Desde la laptop:

```bash
ssh -L 8000:127.0.0.1:8000 -L 20128:127.0.0.1:20128 usuario@IP_DE_LA_VM
```

Luego abre `http://localhost:8000/canvas` y `http://localhost:20128`.

### Tailscale

Instala Tailscale en la VM y en tu laptop. Mantén el Compose en loopback y publica cada servicio solo dentro de la tailnet mediante `tailscale serve`. Revisa el comando vigente de Tailscale antes de aplicarlo, porque su sintaxis puede cambiar.

No uses `tailscale funnel` ni redirecciones puertos del router.

## 7. Configurar y probar

Configura OmniRoute y el perfil LLM siguiendo [modelos remotos](modelos-remotos.md). Prueba en este orden:

1. Respuesta simple del modelo.
2. Lectura de un repositorio de prueba.
3. Cambio pequeño y ejecución de tests.
4. Reinicio de la VM y recuperación del estado.
5. Snapshot con el stack validado.

No entregues a la VM credenciales de producción hasta completar estas pruebas.
