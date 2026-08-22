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

## Conectar un proveedor en OmniRoute

La elección del proveedor, modelo, cuota y precio pertenece al operador. No se fija ninguno en este repositorio porque esos datos deben comprobarse en la cuenta y documentación vigentes.

1. Abre `http://localhost:20128` e inicia sesión con la contraseña local de OmniRoute.
2. En el panel, abre la sección de proveedores o conexiones y elige únicamente el proveedor remoto que ya hayas autorizado.
3. Selecciona el método admitido por ese proveedor e introduce la credencial directamente en OmniRoute. No la pegues en una terminal, prompt, issue o archivo del repositorio.
4. Guarda la conexión y usa la prueba del panel, si está disponible.
5. Comprueba en el catálogo de OmniRoute qué ID de modelo expone esa conexión. Anota solo el ID, nunca la credencial.
6. Crea en OmniRoute una API key local dedicada a Agent Canvas. No reutilices la clave del proveedor.
7. Revisa la cuota y el precio en la fuente oficial del proveedor, desactiva la recarga automática y fija un límite cuando la cuenta lo permita.

Una conexión válida no demuestra que el uso sea gratuito. No uses cookies extraídas, cuentas compartidas ni automatización que el proveedor prohíba.

Los modelos de programación deben soportar contexto suficiente y tool-calling estable. Una respuesta de chat correcta no garantiza que OpenHands pueda completar una tarea con herramientas.

## Configurar Agent Canvas

Abre `http://localhost:8000/canvas`. En el asistente inicial, o después desde **Settings → LLM → Advanced**, configura:

| Campo | Valor |
|---|---|
| Autenticación | Clave de API |
| Modelo personalizado | `openai/<ID exacto publicado por OmniRoute>` |
| URL base | `http://omniroute:20128/v1` |
| Clave API | clave local dedicada creada en OmniRoute |

El prefijo `openai/` indica a OpenHands que use el protocolo OpenAI-compatible. No copies un ejemplo de modelo: sustituye el marcador por el ID que muestre tu propia instancia de OmniRoute. Guarda el perfil y realiza primero una tarea de lectura sin datos sensibles.

La URL del navegador (`localhost`) no sirve entre contenedores. Canvas debe usar el nombre DNS del servicio Docker: `omniroute`.

## Verificación sin exponer claves

Comprueba primero la infraestructura sin autenticarte ni imprimir configuración sensible:

```bash
./scripts/verificar-stack.sh
```

Después, desde la interfaz de Canvas:

1. Guarda el perfil.
2. Confirma que la validación no muestra errores de autenticación, modelo o conexión.
3. Ejecuta una petición inocua de solo lectura.
4. Comprueba en OmniRoute que la solicitud llegó a la conexión esperada y revisa su consumo.

Si falla, distingue el síntoma:

| Error | Revisión |
|---|---|
| Conexión rechazada o timeout | URL base exacta y salud de ambos contenedores |
| 401 o 403 | API key local de OmniRoute usada por Canvas |
| Modelo no encontrado | ID exacto mostrado por OmniRoute y prefijo `openai/` en Canvas |
| 429 | Cuota o límite de la conexión remota |

Registra por cada ruta: fecha, modelo real, cuota, precio comprobado, tool-calling, tamaño de contexto y resultado de una tarea de prueba. Las condiciones cambian; evita documentarlas como permanentes.

## Sin modelos locales

Este diseño no despliega Ollama, LM Studio, vLLM ni GPU. Si en el futuro se añade inferencia local, debe ser una decisión separada basada en RAM, VRAM, calidad y consumo eléctrico medidos.
