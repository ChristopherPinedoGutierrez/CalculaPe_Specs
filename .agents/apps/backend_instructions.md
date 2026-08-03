---
name: backend_instructions
description: Reglas y contexto tecnológico específico para la Base de Datos y APIs (CalculaPe)
---

# Instrucciones de la Aplicación: backend

## 1. Jerarquía de Conocimiento
Al desarrollar en esta aplicación, obedeces la siguiente jerarquía:
1. Reglas globales (`AGENTS.md`)
2. Estas instrucciones (`backend_instructions.md`)
3. Archivos de solución históricos (`/.agents/knowledge/solutions/`)

## 2. Stack Tecnológico
* **Base de Datos:** PostgreSQL alojado en Supabase.
  * **Project Ref (CalculaPe):** `hltoadfaclevhgrcpwdg`
* **Autenticación:** Supabase Auth (Integración con Google OAuth).
* **Storage:** Supabase Storage.
* **Realtime:** Supabase Realtime (WebSockets).
* **Notificaciones:** Firebase Cloud Messaging (FCM) - (Integración con Edge Functions o webhooks).

## 3. Patrones y Reglas de Base de Datos
* **Nomenclatura:** Uso de `snake_case` estricto en tablas, columnas, funciones, triggers y roles.
* **Seguridad (Gating):** Nunca modificar esquemas de BD sin autorización explícita del humano.
* **Protección (RLS):** Toda tabla DEBE tener Row Level Security habilitado. El acceso a los datos de transacciones compartidas se rige consultando la pertenencia del usuario en la tabla `group_members`.
* **Centralización de Reglas:** Validaciones críticas (como los límites Freemium o la consistencia de invitaciones) deben ser manejadas en PostgreSQL mediante Triggers y Constraints, evitando que la lógica resida solo en el cliente (mobile).

## 4. Gestión de Scripts SQL
* Los cambios en la BD se manejan mediante archivos SQL en la carpeta `/management/database/scripts/`.
* Todo script debe poseer una cabecera indicando App Origen, Autor, Fecha y Justificación.
* Los cambios estructurales (Tablas) son incrementales.
* Los cambios procedimentales (Triggers, RLS, Funciones) se pueden modificar in-place usando `CREATE OR REPLACE` y documentando el cambio.
* El archivo maestro `/management/database/schema.sql` debe mantenerse siempre actualizado.
