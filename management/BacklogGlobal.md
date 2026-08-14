# Backlog Global - CalculaPe

Este documento es la única fuente de verdad para el desarrollo. Toda historia de usuario o tarea se encuentra organizada por Entregables, Épicas y asignación de App.

## [E1] Fundamentos y Base de Datos
**Épica: Diseño de Esquema y Tablas**
* [x] App: backend | Crear tablas base: `profiles`, `groups`, `group_members` (incluye roles y `monthly_income`).
* [x] App: backend | Crear tablas operativas: `categories`, `payment_methods`, `merchants`, `transactions`.
* [x] App: backend | Crear tabla de gestión: `invitations` para flujo híbrido de correos.

**Épica: Seguridad (RLS) y Reglas de Negocio**
* [x] App: backend | Configurar Row Level Security (RLS) para proteger lectura/escritura en perfiles.
* [x] App: backend | Configurar RLS para `groups`, `transactions` y storage basado en membresía (`group_members`).
* [x] App: backend | Crear Trigger `handle_new_user_invitation` para vincular invitaciones al registrarse con Google.
* [x] App: backend | Implementar Triggers en PostgreSQL para control de límites Freemium (Max 1 Grupo, Max 3 miembros para plan Free).

## [E2] Autenticación e Infraestructura App
**Épica: Configuración Base de Proyecto**
* [x] App: mobile | Inicializar proyecto Expo (React Native) con TypeScript estricto.
* [x] App: mobile | Configurar navegación basada en archivos con Expo Router.
* [x] App: mobile | Integrar React Native Paper para componentes UI / Material Design.

**Épica: Autenticación de Usuarios**
* [x] App: mobile | Integrar Supabase Auth delegado a Google OAuth (Google Sign-In).
* [x] App: mobile | Crear flujo de login y protección de rutas (Auth Guard).

**Épica: Motor Offline y Sincronización**
* [x] App: mobile | Configurar base de datos local `expo-sqlite` para almacenamiento primario Offline-First.
* [x] App: mobile | Desarrollar motor de sincronización diferencial (Delta Sync en background) hacia Supabase RPCs/REST.

## [E3] Gestión de Espacios y Transacciones
**Épica: Grupos, Perfil e Invitaciones**
* [x] App: mobile | UI y lógica para crear grupos y administrar miembros (Asignación de bolsa común / ingresos).
* [x] App: mobile | Sincronización del perfil de usuario (`subscription_tier` pro/free y `display_name`) entre Supabase y SQLite con soporte en Delta Sync (`updated_at`).
* [x] App: mobile | Navegación inferior (Bottom Tabs), pantalla de Perfil/Configuración con edición de nombre de usuario y cierre de sesión con diálogo de confirmación.
* [x] App: mobile | Refinamiento de grupos: Editar nombre de grupo, abandonar grupo (Miembros) y eliminación destructiva en cascada con diálogo de confirmación (Admins).
* [x] App: mobile | Arquitectura de Design System y Tema Centralizado (`src/theme`) con soporte para Modo Claro/Oscuro/Sistema, paleta corporativa y persistencia de preferencia.
* [x] App: mobile | UI para envío, recepción y aceptación de invitaciones por email.
* [x] App: mobile | Gestión de invitaciones enviadas (visibilidad por grupo en detalle, pestaña Enviadas en configuración y revocación/reinvitación por admin).

**Épica: Gestión de Transacciones (Manual)**
* [ ] App: mobile | Formulario de registro de gastos manuales.
* [ ] App: mobile | Selector de contexto: alternancia fluida entre registrar en espacio personal (`group_id IS NULL`) o grupal.

## [E4] Escaneo Híbrido y Procesamiento de Comprobantes
**Épica: Módulo Cámara y Parser QR**
* [ ] App: mobile | Implementar cámara y escáner de códigos QR.
* [ ] App: mobile | Desarrollar Parser QR Extensible (Factory Pattern) con soporte inicial para comprobantes SUNAT (Perú).

**Épica: Módulo Visión Computacional (OCR)**
* [ ] App: mobile | Integrar API de IA/OCR como fallback cuando el QR no exista o sea ilegible.
* [ ] App: mobile | Crear pantalla de confirmación pre-llenada para que el usuario valide la extracción (Monto, Fecha, RUC/Local).

**Épica: Procesamiento y Almacenamiento de Imágenes**
* [ ] App: mobile | Desarrollar módulo de compresión de imagen en cliente (JPEG/WebP ~150-300KB).
* [ ] App: mobile | Subida segura de imágenes comprimidas a Supabase Storage con URLs firmadas y vinculación a `transactions`.

## [E5] Reportería, Notificaciones y Realtime
**Épica: Dashboard Informativo y Repartición**
* [ ] App: mobile | Desarrollar motor de cálculo para la repartición proporcional de presupuestos basada en `monthly_income`.
* [ ] App: mobile | Visualización de gráficos estadísticos (gastos por categoría, establecimiento y miembro).

**Épica: Resiliencia y Notificaciones (Realtime)**
* [ ] App: mobile | Suscripción a Supabase Realtime (Foreground) habilitada para TODOS los usuarios (Free y Pro) para asegurar actualización visual al instante.
* [ ] App: mobile | Integrar Firebase Cloud Messaging (FCM) para notificaciones en segundo plano (Background) EXCLUSIVO para dispositivos de usuarios PRO.

## [E6] Monetización (Ads y Suscripciones)
**Épica: In-App Purchases (Suscripción PRO)**
* [ ] App: mobile | Integrar RevenueCat / React Native IAP para conexión con Google Play Billing.
* [ ] App: mobile | Crear pantalla de "Paywall" (Planes y beneficios) y enlazar actualización del `subscription_tier` en Supabase al confirmar compra.

**Épica: Google AdMob (Plan Free)**
* [ ] App: mobile | Configurar `react-native-google-mobile-ads` y registrar bloques de anuncios (Banners e Intersticiales).
* [ ] App: mobile | Lógica de Banners: Mostrar a usuarios Free, SALVO que estén navegando dentro de un grupo creado por un usuario PRO (Herencia de Contexto Ad-Free).
* [ ] App: mobile | Lógica de Intersticiales: Mostrar a usuarios Free (tras acciones de alto valor), aplicando la misma herencia de contexto si están en un grupo PRO.
