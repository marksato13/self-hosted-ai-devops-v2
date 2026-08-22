# Proyectos de referencia

Esta plataforma toma **ideas arquitectónicas**, no copia código ni instala todos
los proyectos listados. Cada dependencia real debe aprobarse, fijarse a una
versión y revisarse de forma independiente antes de incorporarse.

| Proyecto | Licencia declarada | Idea estudiada | Decisión en V2 |
|---|---|---|---|
| [OpenHands](https://github.com/OpenHands/OpenHands) | MIT | Interfaz de agente, sesiones, workspaces y sandbox | Componente principal previsto: Agent Canvas. |
| [OmniRoute](https://github.com/diegosouzapw/OmniRoute) | MIT | Un endpoint compatible y política central de proveedores | Gateway único previsto. |
| [Open SWE](https://github.com/langchain-ai/open-swe) | MIT | Trabajo asíncrono por tarea, sandbox y artefactos revisables | Se adoptan los contratos de tarea y revisión; no se instala su framework. |
| [SWE-agent](https://github.com/SWE-agent/SWE-agent) | MIT | Bucle acotado de issue, herramientas y validación de una corrección | Se adopta el criterio de reproducción y pruebas; no se ejecuta como segundo agente. |
| [Opendray](https://github.com/Opendray/opendray) | Apache-2.0 | Separación entre gateway, agentes y canales de control | Solo sirve como referencia de límites de confianza; no se añaden sus canales ni memoria. |

## Cyrus

El nombre **Cyrus** es ambiguo: no se encontró un repositorio canónico de un
agente de desarrollo con licencia y mantenimiento verificables. Por tanto no se
incluye enlace ni patrón técnico atribuible. Si se elige un upstream concreto,
se debe registrar aquí su URL, licencia, fecha de revisión, superficie de
permisos y la razón para adoptarlo o descartarlo.

## Licencias y límites

MIT y Apache-2.0 permiten reutilización bajo sus condiciones, pero esta V2 no
redistribuye código de esos proyectos. Los nombres, ideas y enlaces no implican
soporte, afiliación ni compatibilidad. Las APIs y los modelos remotos conservan
sus propios términos, costes y límites.

Consulta [patrones adoptados](patrones-adoptados.md) para el mapeo a esta
arquitectura y [plan de implementación](plan-implementacion.md) para el orden
de adopción.
