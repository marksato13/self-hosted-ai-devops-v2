# Arquitectura y alcance

## Propósito

La plataforma ofrece un entorno web único para que agentes de IA trabajen con repositorios y proyectos técnicos. Desarrollo es el caso principal; infraestructura, seguridad, operaciones y documentación comparten el mismo núcleo y cambian mediante perfiles, herramientas y permisos.

## Componentes

```mermaid
flowchart LR
    B[Navegador] -->|localhost, SSH o Tailscale| C[Agent Canvas]
    C --> AS[OpenHands Agent Server]
    AS --> W[/projects/workspace]
    AS --> OR[OmniRoute]
    OR --> P1[Proveedor remoto A]
    OR --> P2[Proveedor remoto B]
    W --> V[Validadores deterministas]
    V --> O[PR · plan · informe · artefacto]
    O --> H[Aprobación humana]
```

Agent Canvas agrupa UI, sesiones, automatizaciones y backend. OmniRoute centraliza las rutas OpenAI-compatible y conserva credenciales cifradas. Docker limita el sistema de archivos visible a `/projects` y al estado persistente de OpenHands.

## Qué incluye

- UI web y conversaciones persistentes.
- Workspaces explícitos por proyecto.
- Perfiles de agente por tipo de trabajo.
- Modelos remotos detrás de OmniRoute.
- Instalación local y en VM Linux.
- Acceso privado y guardarraíles de secretos.
- Salidas distintas: PR, plan, informe o artefacto.

## Qué no incluye

- Telegram, OpenClaw u otro canal de mensajería.
- Modelos locales o GPU.
- Kubernetes, observabilidad pesada o múltiples orquestadores.
- Aplicación automática de cambios destructivos.
- Garantía de gratuidad de proveedores externos.

## Límites de confianza

Agent Canvas no es por sí mismo una barrera de seguridad. Un agente puede ejecutar comandos y leer o modificar los archivos que su backend vea. El contenedor y el directorio montado son la frontera principal; una VM dedicada agrega una frontera más fuerte frente al equipo personal.

No se monta `/`, el directorio personal completo ni el socket Docker del host. Solo se monta `PROJECTS_DIR`. Para administrar Docker o infraestructura real, el agente debe preparar archivos y planes; la aplicación se realiza fuera del sandbox tras revisión.

## Escalabilidad

Inicio recomendado: una conversación activa y un workspace. Aumentar concurrencia solo después de medir RAM, cuota y límites del proveedor. Si el uso crece, separar UI y backend o crear backends dedicados por nivel de confianza antes de adoptar Kubernetes.
