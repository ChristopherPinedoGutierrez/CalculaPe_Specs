# Backlog Global - CalculaPe

Este documento es la única fuente de verdad para el desarrollo. Toda historia de usuario o tarea se encuentra organizada por Entregables, Épicas y asignación de App.

## [E1] Fundamentos y Base de Datos
**Épica: Diseño de Esquema y Tablas**
* [ ] App: backend | Crear tablas base: `profiles`, `groups`, `group_members` (incluye roles y `monthly_income`).
* [ ] App: backend | Crear tablas operativas: `categories`, `payment_methods`, `merchants`, `transactions`.
* [ ] App: backend | Crear tabla de gestión: `invitations` para flujo híbrido de correos.

**Épica: Seguridad (RLS) y Reglas de Negocio**
* [ ] App: backend | Configurar Row Level Security (RLS) para proteger lectura/escritura en perfiles.
* [ ] App: backend | Configurar RLS para `groups`, `transactions` y storage basado en membresía (`group_members`).
* [ ] App: backend | Crear Trigger `handle_new_user_invitation` para vincular invitaciones al registrarse con Google.
* [ ] App: backend | Implementar Triggers en PostgreSQL para control de límites Freemium (gating de grupos/miembros).

## [E2] Autenticación e Infraestructura App
**Épica: Configuración Base de Proyecto**
* [ ] App: mobile | Inicializar proyecto Expo (React Native) con TypeScript estricto.
* [ ] App: mobile | Configurar navegación basada en archivos con Expo Router.
* [ ] App: mobile | Integrar React Native Paper para componentes UI / Material Design.

**Épica: Autenticación de Usuarios**
* [ ] App: mobile | Integrar Supabase Auth delegado a Google OAuth (Google Sign-In).
* [ ] App: mobile | Crear flujo de login y protección de rutas (Auth Guard).

**Épica: Motor Offline y Sincronización**
* [ ] App: mobile | Configurar base de datos local `expo-sqlite` para almacenamiento primario Offline-First.
* [ ] App: mobile | Desarrollar motor de sincronización diferencial (Delta Sync en background) hacia Supabase RPCs/REST.

## [E3] Gestión de Espacios y Transacciones
**Épica: Grupos e Invitaciones**
* [ ] App: mobile | UI y lógica para crear grupos y administrar miembros (Asignación de bolsa común / ingresos).
* [ ] App: mobile | UI para envío, recepción y aceptación de invitaciones por email.

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
* [ ] App: mobile | Suscripción a Supabase Realtime para reflejar cambios instantáneos cuando la app está activa.
* [ ] App: mobile | Integrar Firebase Cloud Messaging (FCM) para notificaciones push confiables en segundo plano (Android background/doze).
