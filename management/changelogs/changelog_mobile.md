# Changelog Móvil (App)

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
