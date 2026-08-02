# Skill de Desarrollo Web (Next.js & React)

Este documento define las buenas prácticas y patrones recomendados para el desarrollo frontend utilizando React y la arquitectura App Router de Next.js.

---

## 1. Arquitectura Next.js App Router (Server vs. Client)
* **Server Components (RSC):**
  * Es el comportamiento predeterminado en Next.js. Se ejecutan y renderizan en el servidor.
  * Deben utilizarse para la obtención y consulta inicial de datos (data fetching). Esto reduce la carga de JavaScript en el navegador y mejora la seguridad al no exponer claves en el cliente.
* **Client Components ("use client"):**
  * Se utilizan cuando se requiere interactividad (ej. eventos como `onClick`, hooks como `useState` o `useEffect`, o suscripciones en tiempo real a Supabase).
  * Mantener los Client Components lo más pequeños y profundos posible en el árbol de componentes para maximizar el renderizado en el servidor.

## 2. Integración y Cookie-Based Auth en Next.js con Supabase
* **Tres Tipos de Clientes (@supabase/ssr):**
  * **Client Component Client:** Utilizado en componentes interactivos web para interactuar con datos en tiempo real y eventos de autenticación básicos.
  * **Server Component Client:** Configurado en componentes del servidor, Server Actions y Route Handlers. Gestiona las cookies HTTP-only para almacenar y validar la sesión de forma segura del lado del servidor.
  * **Admin Client (Service Role):** Utilizado exclusivamente en entornos de backend seguros para tareas administrativas que requieran saltar las políticas RLS. **Nunca** debe usarse en componentes del cliente ni exponer su token en el navegador.
* **Middleware para Protección de Rutas:**
  * Utilizar `middleware.ts` en la raíz de Next.js para interceptar peticiones de rutas protegidas. Esto refresca los tokens de sesión de cookies antes de que las vistas del servidor o cliente se rendericen.

## 3. Principios de Código en React
* **Single Responsibility Principle (SRP):** Desacoplar la UI de la infraestructura de datos. Los archivos visuales no deben inicializar clientes de Supabase ni realizar peticiones fetch crudas; se debe implementar Custom Hooks para el manejo de estado asíncrono y llamadas de red.
* **Mapeo de Rutas y Navegación:** Utilizar la estructura de carpetas `app/` de Next.js y los enlaces de navegación nativos para garantizar una correcta indexación SEO y rendimiento de carga.
