# Estándar de Git y Changelog Unificado

Este documento define las reglas de control de versiones y el formato de bitácora unificada que todos los agentes deben seguir al pie de la letra para registrar los avances de código.

---

## 1. Convención de Mensajes de Commit (Git)
Los mensajes de confirmación de Git deben ser claros y estructurados bajo el estándar de *Conventional Commits*:
* `feat:` Nueva funcionalidad para el usuario.
* `fix:` Corrección de un error o bug en el código.
* `docs:` Cambios únicamente en la documentación.
* `style:` Cambios estéticos de formato de código (espaciados, comas, etc.) sin impacto funcional.
* `refactor:` Reestructuración de código que no corrige bugs ni añade funciones.
* `test:` Añadir o corregir pruebas automáticas.

---

## 2. Flujo de Registro en el Changelog (Cierre de Tarea)
El registro de los cambios en el changelog se realiza **exclusivamente al finalizar y probar una tarea del backlog**, justo antes de cerrar la tarjeta y generar el mensaje de commit.
* **Prohibición de Log Libre:** Ningún agente o desarrollador puede escribir descripciones en formatos libres.
* **Orquestador Central:** Los cambios generales se enlazan en `management/changelogs/orquestador.md` y se detallan en el archivo atómico correspondiente en `management/changelogs/changelog_[area].md`.

---

## 3. Formato Estándar de Entrada del Changelog
Toda adición a las bitácoras debe copiar exactamente la siguiente estructura de Markdown:

```markdown
---
### [AAAA-MM-DD HH:MM] | App/Componente: [NOMBRE_APP] | Autor: [AGENT_ROLE / HUMAN]

* **Descripción:** [Breve descripción de una línea sobre el cambio realizado]
* **Detalles Técnicos:**
  - **Archivos Modificados:** [Link al archivo modificado 1](file:///ruta), [Link al archivo 2](file:///ruta)
  - **Base de Datos:** [Cambios en tablas, políticas RLS o triggers si aplica, ej: "Ninguno" o "Añadida columna X en tabla Y"]
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: [Descripción del criterio de aceptación validado]
  - [x] AC 2: [Descripción del criterio de aceptación validado]
---
```
