# Patrones adoptados

Los patrones siguientes son reglas de diseño para implementar V2. No describen
funciones ya verificadas: el Compose sigue pendiente de una prueba completa.

| Patrón | Referencia | Aplicación en V2 | Límite explícito |
|---|---|---|---|
| Un plano de interacción | OpenHands | Agent Canvas concentra conversación, perfiles y workspace elegido | No añadir otro orquestador ni un bot de mensajería. |
| Un gateway de modelos | OmniRoute | Todo perfil usa el mismo endpoint compatible | No encadenar proxies ni asumir que una ruta gratuita está disponible. |
| Unidad de trabajo revisable | Open SWE | Cada tarea termina en PR, plan, informe o artefacto con validaciones | No aprobar ni fusionar automáticamente. |
| Sandbox por tarea | Open SWE, SWE-agent | El agente ve solo un proyecto bajo `PROJECTS_DIR` | No montar `/`, el home completo ni el socket Docker. |
| Corrección reproducible | SWE-agent | Un bug debe incluir reproducción, cambio mínimo y prueba de regresión | No convertir una conversación sin evidencia en una corrección automática. |
| Frontera de confianza | Opendray | Separar UI/agente, gateway y artefactos; mantener puertos en loopback | No incorporar canales externos, memoria compartida o ejecución remota sin evaluación propia. |
| Aprobación humana | Todos, adaptado | `apply`, despliegue, merge, borrado y rotación de secretos quedan fuera del agente | No habilitar bypass por prompt, etiqueta o perfil. |

## Contrato mínimo de una tarea

Antes de cerrar una tarea, el agente debe dejar un resultado revisable:

```json
{
  "tipo": "pull_request | plan_infra | informe | artefacto",
  "estado": "completado | bloqueado | requiere_aprobacion",
  "riesgo": "bajo | medio | alto",
  "validaciones": [],
  "cambios": [],
  "pendientes": []
}
```

Para código, la salida incluye rama o parche y la orden de prueba ejecutada.
Para infraestructura, incluye `plan` o `diff`, impacto, rollback y una acción
humana propuesta. Para seguridad y operaciones, separa hechos, hipótesis y
evidencia.

## Lo que no se adopta

- Enjambres de agentes, colas autónomas y merges automáticos de la V1.
- Telegram, Slack o cualquier canal externo como superficie de control.
- Cookies, cuentas compartidas o automatización prohibida por un proveedor.
- Acceso del agente a infraestructura productiva, Docker del host o secretos.
- Un supuesto de que todos los repositorios o modelos se comportan igual.
