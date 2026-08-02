# Skill de Desarrollo Android y Kotlin (Estándar Google MAD)

Este documento contiene las directrices de buenas prácticas oficiales de Google para el desarrollo nativo en Android con Kotlin.

---

## 1. Arquitectura Recomendada (Google MAD - Modern Android Development)
Se debe implementar un diseño de arquitectura en capas con Flujo Unidireccional de Datos (UDF):
* **Capa de Interfaz de Usuario (UI Layer):** 
  * Los componentes visuales (Activities, Fragments o Jetpack Compose) solo observan el estado y capturan eventos del usuario. No contienen lógica de negocio.
  * Utilizar `ViewModel` para retener y exponer el estado de la UI a través de flujos reactivos. El ViewModel sobrevive a cambios de configuración.
* **Capa de Datos (Data Layer):**
  * Es la única fuente de verdad para los datos de la aplicación.
  * Implementar el **Patrón Repository** para abstraer las fuentes de datos (ej. cliente local de base de datos o llamadas remotas a Supabase). Los ViewModels interactúan exclusivamente con repositorios, nunca con clientes de red directamente.
* **Capa de Dominio (Domain Layer - Opcional):**
  * Reservada para encapsular casos de uso complejos que contengan lógica de negocio reutilizable entre múltiples ViewModels.

## 2. Concurrencia Estructurada con Kotlin Coroutines y Flow
* **Ámbitos de Corrutinas (Scopes):**
  * Las llamadas asíncronas en ViewModels deben lanzarse utilizando `viewModelScope` para garantizar su cancelación automática al destruirse el ciclo de vida.
  * Evitar el uso de `GlobalScope` para llamadas dentro de la aplicación.
* **Streams de Datos Reactivos:**
  * Utilizar `StateFlow` (flujo caliente con estado inicial y valor único) en el ViewModel para exponer estados de UI inmutables.
  * Utilizar `SharedFlow` para emitir eventos de una sola vez (ej. navegación, toasts o errores).
  * En la UI, colectar flujos de forma segura para el ciclo de vida mediante `repeatOnLifecycle` o `collectAsStateWithLifecycle` en Compose para evitar desperdicio de memoria.

## 3. Integración Segura con Supabase Realtime
* **Cancelación de Colección:** Al suscribirse a cambios de tablas en Supabase mediante Kotlin SDK, asegúrese de encapsular el flujo dentro de un CoroutineScope controlado. Al destruirse la vista o el ViewModel, el scope de recolección debe cancelarse de forma explícita para evitar fugas de conexión de sockets.
* **Reconexión y Red:** La conexión a realtime de Supabase puede experimentar pérdidas temporales. Se debe implementar lógica de captura de excepciones de red y reconexión automática en el repositorio de datos para asegurar la consistencia del estado.
