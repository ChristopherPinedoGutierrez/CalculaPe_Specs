# Changelog Móvil (App)

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
