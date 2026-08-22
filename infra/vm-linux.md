# Especificación de la VM Linux

La plataforma funciona sobre cualquier hipervisor capaz de ejecutar Ubuntu Server y Docker.

## Recursos recomendados

| Recurso | Mínimo de prueba | Recomendado |
|---|---:|---:|
| vCPU | 2 | 4 |
| RAM | 4 GB | 8 GB |
| Disco | 30 GB | 50 GB o más |
| GPU | No | No |
| Red | NAT o bridge | Bridge/LAN + Tailscale |
| SO | Ubuntu Server 24.04 LTS | Ubuntu Server 24.04 LTS |

No se ejecutan modelos locales, por lo que la RAM se destina a Agent Canvas, OmniRoute, sandboxes, dependencias y compilaciones. Proyectos Java, contenedores anidados o builds grandes pueden requerir más memoria y disco.

## Hipervisores

- VMware ESXi: VM con VMXNET3 y disco de aprovisionamiento fino.
- Proxmox/KVM: VirtIO para disco y red.
- Hyper-V: VM de generación 2.
- VirtualBox: útil para pruebas, no preferido para servicio permanente.

## Red y snapshots

Asigna una IP estable por reserva DHCP. No publiques 8000 ni 20128 en Internet. Usa SSH o Tailscale.

Snapshots sugeridos:

1. Ubuntu recién instalado.
2. Docker, firewall y acceso privado verificados.
3. Stack configurado y primera tarea superada.

Un snapshot no sustituye el backup del estado de OpenHands, OmniRoute y los repositorios.
