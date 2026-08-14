# Changelog Móvil (App)

---
### [2026-08-14 14:49] | App: mobile/backend | Autor: TECH_LEAD_AI

* **Descripción:** Solución de la falla de sincronización en Supabase (error de sintaxis de UUID en categorías/medios de pago), adición de política RLS DELETE en `group_members`, corrección del cálculo del límite Freemium al crear grupos y adición de distintivos de rol en la UI.
* **Detalles Técnicos:**
  - **Sincronización en Supabase:** Se poblaron las tablas `categories` y `payment_methods` en Supabase con UUIDs estándar válidos y se actualizaron `DEFAULT_CATEGORIES` y `DEFAULT_PAYMENT_METHODS` en la app local, permitiendo que las transacciones se inserten limpiamente en Supabase.
  - **Política RLS DELETE:** Se añadió la política RLS `Eliminar membresia de grupo` en Supabase (`user_id = auth.uid() OR is_group_admin(...)`), permitiendo a los usuarios no administradores abandonar un grupo sin que la sincronización vuelva a restaurarlo.
  - **Validación Freemium Corregida:** Se ajustó `createGroup` en `groupsRepository.ts` para validar `SELECT COUNT(*) FROM groups WHERE created_by = createdBy`. Ahora un usuario en plan Free puede ser invitado a múltiples grupos sin ser bloqueado de crear su grupo propio de derecho.
  - **UI & Fragment Props Warning:** Se reemplazó `React.Fragment` por `View` con `key` en `index.tsx` y `groups/[id].tsx`, eliminando advertencias de consola. Se agregaron Chips indicando `Creador / Admin` vs `Invitado / Miembro` en las tarjetas de grupos del Dashboard.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Verificación de compilación estricta TypeScript (`cmd /c node node_modules/typescript/bin/tsc --noEmit`) con exit code 0.
  - [x] AC 2: Ejecución limpia del servidor local Expo y verificación de logs sin errores.
---

---
### [2026-08-14 12:44] | App: mobile | Autor: TECH_LEAD_AI

* **Descripción:** Refinamiento profundo de UI/UX e infraestructura de datos para Transacciones Manuales ([E3]), implementando el almacenamiento de montos en céntimos enteros, estandarización de moneda en Soles (S/.), selectores modales limpios para espacios/categorías/medios de pago y desaturación del Dashboard.
* **Detalles Técnicos:**
  - **Montos en Céntimos Enteros:** Actualización de `transactionsRepository.ts` para multiplicar el importe flotante por 100 (`Math.round(amount * 100)`) al guardar en SQLite/Supabase, eliminando imprecisiones de punto flotante en JavaScript. Conversión inversa a decimal en UI `(amount / 100).toFixed(2)`.
  - **Estandarización Moneda:** Eliminado el selector de dólares; la moneda queda fijada en Soles (`PEN` - S/.) limpiando el formulario.
  - **Selector de Espacios / Grupos:** Reemplazado el toggle abstracto por un picker modal limpio de Espacios/Grupos (`userGroups`), solucionando el ciclo de re-renderizado de React que reseteaba la selección del grupo.
  - **Selectores Limpios de Categorías y Medios de Pago:** Reemplazado el listado abierto masivo de chips por tarjetas compactas con feedback de selección y modales dedicados de selección con RadioButtons.
  - **Desaturación del Dashboard (`index.tsx`):** Simplificada la vista de inicio eliminando menús complejos para enfocar la experiencia en Espacios/Grupos y un botón limpio `+ Registrar Gasto`.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Verificación de compilación estricta TypeScript (`cmd /c node node_modules/typescript/bin/tsc --noEmit`) con exit code 0.
  - [x] AC 2: Inicialización limpia del proyecto y servidor local Expo (`cmd /c npx expo start -c`) para pruebas en Expo Go.
---

---
### [2026-08-14 11:28] | App: mobile | Autor: TECH_LEAD_AI

* **Descripción:** Culminación completa de la Épica de Gestión de Transacciones Manuales de [E3], incluyendo repositorios SQLite local, formulario de gastos, selector de contexto personal vs. grupal, manejo del doble sello de fechas, comercios privados y menú multi-acción en Dashboard.
* **Detalles Técnicos:**
  - **Repositorios y Semillas:** Creación de `categoriesRepository.ts`, `paymentMethodsRepository.ts`, `merchantsRepository.ts` y `transactionsRepository.ts`. Sembrado automático de 8 categorías globales y 4 medios de pago estándar (`Efectivo`, `Tarjeta de Débito`, `Tarjeta de Crédito`, `Billeteras Digitales`) en SQLite local.
  - **Doble Sello de Fechas & Cero Fricción [E4]:** Desacoplamiento entre `transaction_date` (fecha real de consumo) y `created_at` (registro en sistema). Columna `receipt_url` lista para la futura recepción de URLs de imágenes de comprobantes desde el escáner QR/OCR.
  - **Comercios Privados & Smart Pre-fill:** Autocompletado privado limitado exclusivamente al historial del usuario. Pre-selección inteligente de la última categoría utilizada en dicho comercio.
  - **Formulario y Vistas UI:** Creación de `app/(app)/transactions/create.tsx` (registro manual) y `app/(app)/transactions/[id].tsx` (detalle, edición, eliminación y reasignación de espacio "Mover a otro Espacio"). Integración de transacciones recientes en el Dashboard (`index.tsx`) y sección de Gastos del Grupo en `groups/[id].tsx`.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Verificación de compilación estricta de TypeScript (`npx tsc --noEmit`) con 0 errores (exit code 0).
  - [x] AC 2: Verificación de configuración e inicialización limpia de Expo Dev Server (`cmd /c npx expo start -c`) para vinculación directa con Expo Go.
  - [x] AC 3: Actualización de `BacklogGlobal.md` marcando la Épica de Transacciones Manuales como completada al 100%.
---

---
### [2026-08-13 14:15] | App: mobile | Autor: TECH_LEAD_AI

* **Descripción:** Solución del problema de visibilidad de grupos al aceptar invitaciones mediante la exoneración del filtro delta de fecha en las tablas `groups` y `group_members` durante la sincronización.
* **Detalles Técnicos:**
  - **Consolidación Supabase:** Se auditó mediante el MCP de Supabase que el usuario `chrisdavid.pinedo@gmail.com` figuraba exitosamente como miembro activo del grupo `Casa 1` (ID `9574731c-b715-45cb-ad8d-968758a239a1`) en la tabla remota `group_members`.
  - **Causa Raíz:** Al ejecutar la sincronización diferencial (`pullDeltaSync`), la consulta filtraba registros usando `created_at > last_synced_at`. Dado que el grupo `Casa 1` fue creado por el administrador minutos antes de la marca de tiempo de sincronización de la cuenta invitada, la consulta delta descartaba la fila del grupo impidiendo su inserción en la base de datos local SQLite.
  - **Solución Aplicada:** 
    1. Se exoneró a las tablas `groups` y `group_members` del filtro por marca de tiempo en `pullDeltaSync()` ([src/services/syncService.ts](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/services/syncService.ts)), permitiendo que RLS suministre la lista exacta de todos los grupos y miembros activos a los que pertenece el usuario.
    2. Se configuró `acceptInvitation()` en [src/services/invitationService.ts](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/services/invitationService.ts) para borrar los metadatos de sincronización de grupos y miembros antes de desencadenar la sincronización.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Visualización inmediata del grupo al que se fue invitado en la pantalla principal Dashboard al momento de aceptar la invitación.
  - [x] AC 2: Verificación de tipos TypeScript (`npx tsc --noEmit`) con 0 errores.
---

---
### [2026-08-13 14:07] | App: mobile | Autor: TECH_LEAD_AI

* **Descripción:** Solución del error `table group_members has no column named status` en SQLite mediante la adición de una migración defensiva `ALTER TABLE` en `initDatabase()`.
* **Detalles Técnicos:**
  - **Causa Raíz:** La instrucción `CREATE TABLE IF NOT EXISTS` en SQLite no modifica esquemas de tablas preexistentes en dispositivos que ya contaban con una base de datos local creada previamente. Al ejecutar la sincronización con la nueva columna `status`, SQLite rechazaba la preparación del query.
  - **Solución Aplicada:** Se incluyó un bloque `ALTER TABLE group_members ADD COLUMN status TEXT DEFAULT 'active';` envuelto en `try/catch` dentro de `initDatabase()` ([src/db/database.ts](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/db/database.ts)), garantizando la migración automática de la estructura SQLite sin afectar instalaciones previas ni nuevas.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Corrección limpia del error en consola durante la sincronización inicial al ingresar con cualquier usuario.
  - [x] AC 2: Verificación de tipos TypeScript (`npx tsc --noEmit`) con 0 errores.
---

---
### [2026-08-13 13:55] | App: mobile/backend | Autor: TECH_LEAD_AI

* **Descripción:** Corrección de la política RLS de consulta (`SELECT`) en la tabla `groups` para permitir la lectura del nombre e información del espacio a los usuarios que poseen una invitación pendiente.
* **Detalles Técnicos:**
  - **Causa Raíz:** La política RLS anterior de `groups` restringía las consultas exclusivamente a `created_by = auth.uid()` o integrantes del grupo (`group_members`). Cuando un usuario invitado (ej. `chrisdavid.pinedo@gmail.com`) iniciaba sesión, Supabase rechazaba la lectura del nombre del grupo (`Casa 1`), provocando que la invitación no pudiese recuperar los datos relacionales de la BD remota.
  - **Solución Aplicada:**
    - Se actualizó la política RLS en Supabase mediante MCP tool:
      ```sql
      CREATE POLICY "Ver grupos propios o donde soy miembro o invitado" ON public.groups FOR SELECT 
      USING (
        created_by = auth.uid() 
        OR id IN (SELECT public.get_user_group_ids(auth.uid()))
        OR id IN (
          SELECT group_id FROM public.invitations 
          WHERE email = (SELECT email FROM public.profiles WHERE id = auth.uid()) 
          AND status = 'pending'
        )
      );
      ```
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Visualización y descarga inmediata de la invitación enviada al iniciar sesión con la cuenta receptora.
  - [x] AC 2: Verificación de tipos TypeScript (`npx tsc --noEmit`) con 0 errores.
---

---
### [2026-08-13 13:51] | App: mobile/backend | Autor: TECH_LEAD_AI

* **Descripción:** Implementación de la arquitectura de gestión inmutable de invitaciones enviadas (revocación `cancelled`, re-invitación `pending`) y control de estado de membresías (`active` / `blocked` con reactivación inmediata).
* **Detalles Técnicos:**
  - **Base de Datos / Supabase:**
    - Se ejecutó el script [004_invitations_and_members_schema.sql](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_Specs/management/database/scripts/004_invitations_and_members_schema.sql) mediante el MCP de Supabase:
      - Agregado el valor `cancelled` al enum `invitation_status`.
      - Creado el enum `member_status` (`'active'`, `'blocked'`) y añadida la columna `status` a `group_members`.
      - Creadas políticas RLS para `DELETE` y `UPDATE` en `invitations`.
    - Se actualizó el esquema maestro [schema.sql](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_Specs/management/database/schema.sql).
  - **Lógica de Negocio y Repositorios:**
    - `invitationService.ts`: Lógica de `sendInvitation` adaptada para reactivar invitaciones en estado `declined` o `cancelled` a `pending` al re-invitar. Agregada función `revokeInvitation`.
    - `groupMembersRepository.ts`: Creada función `updateMemberStatus` para cambiar el estado entre `active` y `blocked`.
  - **Interfaz de Usuario (UI):**
    - [`app/(app)/groups/[id].tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/groups/[id].tsx):
      - Sección de integrantes con indicación de estado (`ACTIVO` / `SUSPENDIDO`) y botón de **Reactivar** (reactivación directa sin re-invitación).
      - Sección de **Invitaciones Emitidas del Grupo** para administradores con acciones de **Revocar** y **Volver a invitar**.
    - [`app/(app)/invitations/index.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/invitations/index.tsx):
      - Control de pestañas `SegmentedButtons` ("Recibidas" vs "Enviadas").
      - Pestaña "Enviadas" lista las invitaciones emitidas desde los grupos del usuario con estado (`PENDIENTE`, `DECLINADA`, `CANCELADA`) y soporte de revocar/re-invitar.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Visibilidad y control completo de invitaciones enviadas en el detalle de grupo y vista general.
  - [x] AC 2: Trazabilidad inmutable mediante máquina de estados (`pending`, `declined`, `cancelled`).
  - [x] AC 3: Suspensión de integrantes con reactivación directa sin necesidad de nueva invitación.
  - [x] AC 4: Validación estricta TypeScript (`npx tsc --noEmit`) con 0 errores.
---

---
### [2026-08-13 13:28] | App: mobile/backend | Autor: TECH_LEAD_AI

* **Descripción:** Adición de la política RLS `DELETE` para grupos en Supabase y reemplazo del spinner de pantalla completa por el componente de carga progresiva `GroupSkeleton` (Skeleton UI).
* **Detalles Técnicos:**
  - **Causa Raíz Bug 1 (Borrado no reflejado en Supabase):** La tabla `groups` en Supabase carecía de una política RLS de tipo `DELETE`. PostgREST bloqueaba la solicitud de eliminación por defecto al ser invocada por `processSyncQueue()`.
  - **Solución Bug 1:** Se aplicó el script [003_groups_delete_rls.sql](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_Specs/management/database/scripts/003_groups_delete_rls.sql) que define la política `"Eliminar grupos creados por el dueño" ON public.groups FOR DELETE USING (created_by = auth.uid())` y se actualizó [schema.sql](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_Specs/management/database/schema.sql).
  - **Solución UI (Skeleton Loader):** Se construyó el componente animado [GroupSkeleton.tsx](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/components/GroupSkeleton.tsx) y se refactorizó `DashboardScreen` para renderizar datos locales de forma instantánea (0ms) mientras realiza la sincronización remota en segundo plano, mostrando un esqueleto de 3 tarjetas únicamente si la lista local está vacía.
  - **Archivos Modificados / Creados:**
    - [`management/database/scripts/003_groups_delete_rls.sql`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_Specs/management/database/scripts/003_groups_delete_rls.sql)
    - [`management/database/schema.sql`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_Specs/management/database/schema.sql)
    - [`src/components/GroupSkeleton.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/components/GroupSkeleton.tsx)
    - [`app/(app)/(tabs)/index.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/(tabs)/index.tsx)
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Eliminación efectiva y permanente de filas en Supabase al borrar un grupo desde la interfaz móvil.
  - [x] AC 2: Experiencia de usuario mejorada mediante lectura instantánea de SQLite e integración de `GroupSkeleton` animado.
  - [x] AC 3: Verificación TypeScript (`npx tsc --noEmit`) con 0 errores.
---

---
### [2026-08-13 13:22] | App: mobile | Autor: TECH_LEAD_AI

* **Descripción:** Solución del problema de carga inicial del Dashboard mediante la sincronización proactiva `await triggerFullSync()` antes de consultar SQLite local y reseteo forzado de `sync_metadata` cuando la tabla local de grupos está vacía.
* **Detalles Técnicos:**
  - **Consolidación de Datos Supabase:** Se verificaron los registros reales en Supabase mediante MCP tool `execute_sql`:
    - Usuario PRO `cdpg.dev@gmail.com` tiene **4 grupos activos** (`Casa 10`, `Casa22`, `Casa 11`, `Casa 1`).
    - Usuario FREE `chrisdavid.pinedo@gmail.com` tiene **1 grupo activo** (`Casa 33`).
  - **Causa Raíz:** Al abrir `DashboardScreen`, la pantalla leía SQLite síncronamente antes de que `triggerFullSync` terminase de descargar los deltas remotos. Además, si `sync_metadata` conservaba marcas de tiempo previas, Supabase no devolvía los grupos creados con anterioridad a esa fecha.
  - **Solución:** 
    1. Se hizo asíncrono y bloqueante el llamado `await triggerFullSync()` en `loadDashboardData()` dentro de `app/(app)/(tabs)/index.tsx`.
    2. Se agregó en `pullDeltaSync()` una verificación de seguridad: si la tabla local `groups` contiene 0 filas, limpia `sync_metadata` forzando la descarga completa e inmediata de todos los grupos y miembros remotos desde Supabase.
  - **Archivos Modificados / Creados:**
    - [`app/(app)/(tabs)/index.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/(tabs)/index.tsx)
    - [`src/services/syncService.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/services/syncService.ts)
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Descarga e inserción inmediata en SQLite de los 4 grupos del usuario PRO al iniciar la pantalla Dashboard.
  - [x] AC 2: Recuperación automática si la tabla de grupos local está en 0 filas mediante borrado preventivo de `sync_metadata`.
  - [x] AC 3: Verificación estricta TypeScript (`npx tsc --noEmit`) con 0 errores.
---

---
### [2026-08-13 13:17] | App: mobile | Autor: TECH_LEAD_AI

* **Descripción:** Corrección crítica de la pérdida de visualización de grupos al cambiar de usuario y solución del error de `crypto` al invitar.
* **Detalles Técnicos:**
  - **Causa Raíz Bug 1 (Grupos no visibles):** `reconcileLocalGroups` ejecutaba `supabase.from('groups').select('id')` recibiendo solo los grupos del usuario actual por RLS, pero borraba de SQLite todos los grupos locales del usuario anterior. Al volver al usuario previo, `pullDeltaSync` omitía descargar sus grupos por el timestamp `last_synced_at` previamente guardado.
  - **Solución Bug 1:** Se modificó `reconcileLocalGroups` para filtrar únicamente los grupos pertenecientes al usuario activo, y se creó la función `clearLocalDatabaseOnLogout()` que vacía las tablas de SQLite al cerrar sesión para garantizar sincronizaciones deltas limpias por usuario.
  - **Causa Raíz Bug 2 (Error con crypto):** React Native Hermes no expone `crypto.randomUUID` de forma nativa, lo que provocaba un fallo de ejecución y formatos de ID inválidos para columnas `UUID` en Postgres.
  - **Solución Bug 2:** Creación del helper seguro `generateUUID()` en `src/lib/uuid.ts` compatible con React Native que genera UUIDs RFC4122 v4 válidos.
  - **Archivos Modificados / Creados:**
    - [`src/lib/uuid.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/lib/uuid.ts)
    - [`src/services/syncService.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/services/syncService.ts)
    - [`src/services/invitationService.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/services/invitationService.ts)
    - [`src/contexts/AuthContext.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/contexts/AuthContext.tsx)
    - [`app/(app)/(tabs)/profile.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/(tabs)/profile.tsx)
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Preservación intacta de los grupos en Supabase y visualización correcta al cambiar de cuenta.
  - [x] AC 2: Limpieza de SQLite local al desloguear para aislar sesiones de usuarios en el dispositivo.
  - [x] AC 3: Generación de UUIDs v4 válidos para invitaciones sin errores de motor JavaScript.
  - [x] AC 4: Verificación estricta de compilación TypeScript superada con 0 errores (`npx tsc --noEmit`).
---

---
### [2026-08-13 13:10] | App: mobile/backend | Autor: TECH_LEAD_AI

* **Descripción:** Implementación de la UI y lógica para envío, recepción, listado y respuesta (Aceptar/Declinar) de invitaciones a grupos por correo electrónico, con campana de notificaciones global en Appbar, modal genérico `NotificationsModal`, validación de correo registrado/no registrado y funciones RPC seguras en Supabase.
* **Detalles Técnicos:**
  - **Archivos Modificados / Creados:**
    - [`management/database/scripts/002_invitations_rpc.sql`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_Specs/management/database/scripts/002_invitations_rpc.sql)
    - [`management/database/schema.sql`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_Specs/management/database/schema.sql)
    - [`src/db/types.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/db/types.ts)
    - [`src/services/invitationService.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/services/invitationService.ts)
    - [`src/services/syncService.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/services/syncService.ts)
    - [`src/components/NotificationsModal.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/components/NotificationsModal.tsx)
    - [`src/components/InviteMemberModal.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/components/InviteMemberModal.tsx)
    - [`app/(app)/invitations/index.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/invitations/index.tsx)
    - [`app/(app)/invitations/[id].tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/invitations/[id].tsx)
    - [`app/(app)/(tabs)/index.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/(tabs)/index.tsx)
    - [`app/(app)/(tabs)/profile.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/(tabs)/profile.tsx)
    - [`app/(app)/groups/[id].tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/groups/[id].tsx)
  - **Base de Datos:** Creación de funciones RPC `accept_invitation` y `reject_invitation` con `SECURITY DEFINER` en PostgreSQL (Supabase) y actualización del tipo enum `invitation_status` con `'declined'`.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Envío de invitaciones a correos desde el modal de grupo con detección de usuario registrado/no registrado.
  - [x] AC 2: Icono de campana global en Appbar con Badge dinámico en Dashboard y Configuración.
  - [x] AC 3: `NotificationsModal` para desplegar notificaciones activas y navegar al detalle puntual de la invitación.
  - [x] AC 4: Navegación desde Configuración -> "Invitaciones a Grupos" a la pantalla completa de invitaciones.
  - [x] AC 5: Aceptación y rechazo seguro en Supabase mediante RPC con control de límites Freemium (máx. 3 miembros en plan Free).
  - [x] AC 6: Verificación de tipos TypeScript estricto (`npx tsc --noEmit`) superada con 0 errores y servidor Expo Metro iniciado correctamente.
---

---
### [2026-08-13 11:32] | App: mobile | Autor: AGENT_ROLE

* **Descripción:** Construcción del Design System centralizado (`src/theme`) extendiendo Material Design 3 de React Native Paper, proveedor dinámico de temas `ThemeProvider` con soporte para Modo Claro, Oscuro y Sistema, persistencia en `AsyncStorage` y refactorización completa de componentes UI sin colores hardcodeados.
* **Detalles Técnicos:**
  - **Archivos Modificados / Creados:**
    - [`src/theme/colors.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/theme/colors.ts)
    - [`src/theme/theme.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/theme/theme.ts)
    - [`src/contexts/ThemeContext.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/contexts/ThemeContext.tsx)
    - [`app/_layout.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/_layout.tsx)
    - [`app/(app)/(tabs)/_layout.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/(tabs)/_layout.tsx)
    - [`app/(app)/(tabs)/index.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/(tabs)/index.tsx)
    - [`app/(app)/(tabs)/profile.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/(tabs)/profile.tsx)
    - [`src/services/syncService.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/services/syncService.ts)
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Paleta de colores centralizada `lightColors` y `darkColors` en `src/theme/colors.ts`.
  - [x] AC 2: Selección dinámica de tema (Sistema, Claro, Oscuro) en la pestaña de Perfil con persistencia en `AsyncStorage`.
  - [x] AC 3: Adaptación automática de fondos, tarjetas, textos y FAB flotante al cambiar de modo claro u oscuro con contraste óptimo (`onPrimary`).
  - [x] AC 4: Verificación estricta de compilación TypeScript superada con 0 errores (`tsc --noEmit`).
---

---
### [2026-08-13 11:10] | App: mobile | Autor: AGENT_ROLE

* **Descripción:** Solución del bugfix de sincronización de perfil/suscripción `Pro` mediante filtro `updated_at`, implementación de la navegación inferior (Bottom Tabs), pantalla de Perfil/Configuración con deslogueo protegido por modal y ciclo de vida extendido de grupos (editar nombre, abandonar y borrar en cascada).
* **Detalles Técnicos:**
  - **Archivos Modificados / Creados:**
    - [`src/contexts/DatabaseProvider.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/contexts/DatabaseProvider.tsx)
    - [`src/services/syncService.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/services/syncService.ts)
    - [`src/db/repositories/profilesRepository.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/db/repositories/profilesRepository.ts)
    - [`src/db/repositories/groupsRepository.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/db/repositories/groupsRepository.ts)
    - [`app/(app)/(tabs)/_layout.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/(tabs)/_layout.tsx)
    - [`app/(app)/(tabs)/index.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/(tabs)/index.tsx)
    - [`app/(app)/(tabs)/profile.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/(tabs)/profile.tsx)
    - [`app/(app)/groups/[id].tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/groups/[id].tsx)
    - [`app/(app)/index.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/index.tsx)
  - **Base de Datos:** Descarga de deltas por `updated_at` y operaciones SQLite de eliminación/edición de grupos vinculadas a `sync_queue`.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Sincronización del nivel de suscripción `Pro` reflejada en SQLite local sin sobreescrituras forzadas.
  - [x] AC 2: Navegación por pestañas inferiores (Bottom Tabs: Inicio y Perfil) operativa.
  - [x] AC 3: Pantalla de Perfil funcional con edición de `display_name` y cierre de sesión con diálogo modal de confirmación.
  - [x] AC 4: Menú contextual en detalle de grupo para editar nombre, abandonar grupo y borrado en cascada con diálogo destructivo.
  - [x] AC 5: Verificación estricta de compilación TypeScript superada con 0 errores (`tsc --noEmit`).
---

---
### [2026-08-13 10:06] | App: mobile | Autor: AGENT_ROLE

* **Descripción:** Implementación de repositorios locales de grupos y miembros (`groupsRepository`, `groupMembersRepository`) con encolado en `sync_queue` para Delta Sync, y construcción de vistas UI en Expo Router / React Native Paper para la gestión de grupos y bolsa común.
* **Detalles Técnicos:**
  - **Archivos Modificados / Creados:**
    - [`src/db/repositories/groupsRepository.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/db/repositories/groupsRepository.ts)
    - [`src/db/repositories/groupMembersRepository.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/db/repositories/groupMembersRepository.ts)
    - [`app/(app)/groups/index.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/groups/index.tsx)
    - [`app/(app)/groups/create.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/groups/create.tsx)
    - [`app/(app)/groups/[id].tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/groups/[id].tsx)
    - [`app/(app)/index.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/(app)/index.tsx)
  - **Base de Datos:** Operaciones SQLite locales en `groups` y `group_members` vinculadas a la cola de sincronización de Supabase.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Creación de grupos en SQLite local con asignación de rol admin y encolado en `sync_queue`.
  - [x] AC 2: Vistas UI de lista de grupos, creación y detalle de miembros con edición de `monthly_income` y cálculo de bolsa común.
  - [x] AC 3: Captura de excepciones de límites Freemium (`FREEMIUM_LIMIT_REACHED`) en UI.
  - [x] AC 4: Verificación estricta de compilación TypeScript superada con 0 errores (`tsc --noEmit`).
---

---
### [2026-08-12 16:00] | App: mobile | Autor: AGENT_ROLE

* **Descripción:** Configuración de la base de datos local SQLite (`expo-sqlite`) para almacenamiento primario Offline-First e implementación del motor de sincronización diferencial (Delta Sync).
* **Detalles Técnicos:**
  - **Archivos Modificados / Creados:** 
    - [`src/db/database.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/db/database.ts)
    - [`src/db/types.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/db/types.ts)
    - [`src/db/repositories/profilesRepository.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/db/repositories/profilesRepository.ts)
    - [`src/services/syncService.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/services/syncService.ts)
    - [`src/contexts/DatabaseProvider.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/src/contexts/DatabaseProvider.tsx)
    - [`app/_layout.tsx`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/app/_layout.tsx)
    - [`index.ts`](file:///c:/Trabajo/Proyectos/CalculaPe/CalculaPe_App/index.ts)
  - **Base de Datos:** Replicación local de las 8 tablas de Supabase + tablas de control (`sync_queue` y `sync_metadata`).
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Base de datos SQLite inicializada correctamente en Expo SDK 54 sin errores de compilación ni ejecución.
  - [x] AC 2: Escuchador de conectividad NetInfo activo y motor Delta Sync configurado (Push y Pull).
  - [x] AC 3: Verificación de tipos estricta con TypeScript superada exitosamente (`tsc --noEmit`).
---
