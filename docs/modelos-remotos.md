# Modelos remotos y OmniRoute

## Principio económico

El software autohospedado puede ser gratuito; la inferencia externa depende de cada proveedor. OmniRoute centraliza conexiones y selección, pero no elimina precios, límites, términos ni bloqueos regionales.

Política recomendada:

- presupuesto adicional objetivo: USD 0;
- recarga automática desactivada;
- una tarea concurrente;
- proveedores pagos fuera del fallback automático;
- detenerse cuando no exista una ruta gratuita comprobada;
- revisar consumo en el panel después de cada prueba inicial.

## Conectar proveedores

En el panel de OmniRoute, conecta Qwen, DeepSeek, GLM, Kimi u otros proveedores solo mediante mecanismos permitidos por sus términos. Una conexión válida no demuestra que el uso sea gratuito. No uses cookies extraídas, cuentas compartidas ni automatización que el proveedor prohíba.

Los modelos de programación deben soportar contexto suficiente y tool-calling estable. Una respuesta de chat correcta no garantiza que OpenHands pueda completar una tarea con herramientas.

## Perfil de Agent Canvas

Agent Canvas permite configurar endpoints compatibles desde **Settings → LLM → Advanced**. Con ambos servicios dentro del Compose, usa como referencia:

| Campo | Valor orientativo |
|---|---|
| Provider | OpenAI-compatible |
| Model | `openai/auto/coding:free` o el ID exacto publicado por OmniRoute |
| Base URL | `http://omniroute:20128/v1` |
| API key | clave local creada en OmniRoute |

El prefijo y el ID exactos deben validarse contra `GET /v1/models`. Si Agent Canvas rechaza el perfil, usa el identificador exacto devuelto por OmniRoute y revisa los logs de ambos contenedores.

Desde el host puedes comprobar el gateway sin imprimir la clave:

```bash
set -a
source .env
set +a
curl -fsS http://127.0.0.1:20128/v1/models \
  -H "Authorization: Bearer $OMNIROUTE_API_KEY"
```

## Perfiles sugeridos

No fijes un proveedor para siempre. Crea perfiles descriptivos:

- `coding-free`: mejor ruta gratuita comprobada para desarrollo.
- `fast-free`: tareas cortas, clasificación y documentación.
- `review-free`: revisión independiente, si existe un modelo adecuado.

Registra por cada ruta: fecha, modelo real, cuota, tool-calling, tamaño de contexto y resultado de una tarea de prueba. Las ofertas gratuitas cambian; evita documentarlas como permanentes.

## Sin modelos locales

Este diseño no despliega Ollama, LM Studio, vLLM ni GPU. Si en el futuro se añade inferencia local, debe ser una decisión separada basada en RAM, VRAM, calidad y consumo eléctrico medidos.
