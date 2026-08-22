# Seguridad

OpenHands puede ejecutar comandos, modificar archivos, acceder a red y usar credenciales configuradas. Debe tratarse como código no confiable.

## Reglas obligatorias

1. Montar únicamente un directorio dedicado de proyectos.
2. No montar el home completo, `/`, `/var/run/docker.sock` ni directorios de secretos.
3. Mantener Agent Canvas y OmniRoute en `127.0.0.1`.
4. Usar túnel SSH o Tailscale para acceso remoto.
5. Configurar claves fuertes para `LOCAL_BACKEND_API_KEY`, `OH_SECRET_KEY` y OmniRoute.
6. Proteger `.env` con permisos `600` y mantenerlo fuera de Git.
7. Proteger `main` y revisar todo PR antes del merge.
8. Desactivar recargas automáticas y fijar límites en los proveedores.

## Separación por riesgo

- Laptop personal: adecuada para pruebas con repositorios no sensibles.
- VM dedicada: recomendada para uso continuo y mejor aislamiento.
- Producción: no entregar credenciales al agente durante la primera etapa. El agente genera un plan o PR y un operador aplica el cambio.

## Acciones que requieren aprobación

- `tofu apply`, `terraform apply` o despliegues.
- Cambios de firewall, DNS, IAM o red.
- Escritura sobre bases de datos y servicios productivos.
- Rotación de secretos.
- Eliminación de recursos, volúmenes, snapshots o backups.
- Merge, release, push de imágenes o publicación externa.

`destroy`, borrados masivos y force-push deben permanecer fuera del agente.

## Secretos

Instala los hooks:

```bash
pipx install pre-commit
pre-commit install
pre-commit run --all-files
```

Si un secreto llega a Git, revócalo; borrarlo del archivo no es suficiente. Las credenciales de proveedores se introducen directamente en OmniRoute o Agent Canvas, nunca en prompts, issues o documentación.

## Red

El Compose publica solo en loopback. En VM, `ufw` permite SSH y deniega el resto. No uses `tailscale funnel`, ngrok sin autenticación ni redirección de puertos del router.

## Checklist

- [ ] `.env` tiene permisos `600`.
- [ ] Los secretos se generaron de forma aleatoria.
- [ ] Gitleaks y pre-commit están activos.
- [ ] Solo `/projects` está montado en Agent Canvas.
- [ ] Puertos 8000 y 20128 no están expuestos públicamente.
- [ ] `main` requiere PR y aprobación.
- [ ] Los proveedores tienen topes y recarga desactivada.
- [ ] Los repositorios de prueba no contienen datos sensibles.
- [ ] Existe snapshot o backup antes de actualizar.
