# Plantilla: Blueprint de Solución Técnica (Blueprint)

Este documento es redactado por el agente Arquitecto para consolidar la arquitectura técnica y el modelo de datos antes de iniciar la programación.

---

# BLUEPRINT DE SOLUCIÓN TÉCNICA

**Proyecto:** [Nombre del Proyecto]
**ID Proyecto:** [Código de Proyecto]
**Fecha:** [DD/MM/AAAA]
**Versión:** 1.0

## 1. ARQUITECTURA DE DATOS Y ENTIDADES (SQL)
*(Define el modelo de datos. Presenta las entidades en formato de lista desordenada, detallando campos, tipos y claves).*

* **Base de Datos Seleccionada:** [ej: PostgreSQL en Supabase]
  * **Justificación:** [Por qué se elige esta base de datos en términos de RLS, triggers y tiempo real].

### Modelo de Entidades (Esquema SQL Base)
```sql
-- Coloca aquí la definición SQL limpia que se usará como fuente de verdad
-- Ejemplo:
-- CREATE TABLE users ( ... );
```

### Relaciones y Propósito
* **Tabla A:** [Propósito de la tabla y cómo se relaciona con otras].
* **Tabla B:** [Propósito de la tabla y cómo se relaciona con otras].

## 2. FLUJO LÓGICO Y ENDPOINTS DE API
*(Detalla los procesos internos del sistema, cómo viaja la información entre roles y los puntos de conexión de la API).*
* **Flujo de Usuario (Lógica):** [Describir paso a paso cómo se comunican las apps con la base de datos].
* **Endpoints de API / RPCs de Base de Datos:**
  * `POST /api/...` o función RPC: [Propósito y estructura de entrada/salida]
  * `GET /api/...` o función RPC: [Propósito y estructura de entrada/salida]

## 3. STACK TECNOLÓGICO Y ENTORNO DE DESARROLLO
*(Definición formal de los lenguajes, frameworks y la configuración específica del entorno de desarrollo).*

* **Tecnologías Core:**
  * **Backend:** [ej. Supabase]
  * **Frontend / Mobile:** [ej. React Web / Android Kotlin]

### Mapeo de Entorno y Flujo de Trabajo (Workflow)
*(Especificar los parámetros técnicos y de compilación para que los agentes operen sin errores de contexto).*

* **Aplicaciones y Repositorios:**
  1. **App 1 (Web):**
     * **Repositorio:** `https://github.com/[user]/[repo_web]`
     * **Puerto Local / URL:** `http://localhost:5173`
     * **Entorno de Edición:** Editado por el agente en IDE. Compilado con `npm run dev`.
  2. **App 2 (Android Vendedor):**
     * **Repositorio:** `https://github.com/[user]/[repo_android_vendedor]`
     * **Package Name / Application ID:** `com.notificape.vendedor`
     * **Entorno de Edición:** Editado por el agente en el IDE. Compilado y visualizado por el humano en Android Studio. El agente no debe intentar compilar en la terminal a menos que use comandos Gradle explícitos acordados.
  3. **App 3 (Android Administrador):**
     * **Repositorio:** `https://github.com/[user]/[repo_android_admin]`
     * **Package Name / Application ID:** `com.notificape.admin`
     * **Entorno de Edición:** Editado por el agente. Visualizado externamente en emulador.

### Herramientas de Integración de Agentes e Integraciones (MCP Servers)
*(Define qué integraciones y herramientas del Model Context Protocol están configuradas a nivel Workspace para este ecosistema).*
* **Integración 1 (ej: `Supabase MCP`):** Activa. El agente la usará proactivamente para inspeccionar, validar y alterar (bajo aprobación) el esquema de base de datos.
* **Integración 2 (ej: `Jira / Notion MCP`):** Activa. El agente la usará para sincronizar el backlog.

## 4. MANEJO DE CASOS CRÍTICOS Y SEGURIDAD
*(Estrategias técnicas para mitigar fallos de red, concurrencia y seguridad de datos).*
* **Pérdida de Conectividad (Red):** [Cómo reacciona la app, reintentos offline].
* **Evitar Duplicidad:** [Claves únicas en la base de datos, idempotencia de transacciones].
* **Políticas de Seguridad (Supabase RLS):** [Cómo protegemos las tablas de lectura/escritura no autorizada a nivel de base de datos].

## 5. PLAN DE LANZAMIENTO E HITOS DETALLADOS
*(Cronograma de desarrollo detallado por semanas con entregables técnicos específicos y definición de las Épicas).*
* **Épica 1: Autenticación e Infraestructura** (Semana 1)
  * *Entregable:* Base de datos, RLS, inicio de sesión.
* **Épica 2: Interceptación y Reglas de Negocio** (Semana 2)
  * *Entregable:* Notificaciones locales, automatización de pagos.

## 6. CONTROL DE CAMBIOS Y CONGELAMIENTO TÉCNICO
> [!IMPORTANT]
> **Nota de Gestión:** Este documento define la base estructural del software. Una vez validado y congelado por el cliente, cualquier modificación en el modelo de datos, flujo lógico o tecnologías aquí descritas será considerada un "Cambio de Alcance". Dichos cambios requerirán una nueva evaluación presupuestaria y ajustes en el cronograma de entrega.

## 7. ANEXOS: DIAGRAMAS Y WIREFRAMES
* **Figma Link:** [Enlace a los diseños de Figma]
* **Diagrama de Flujo / Arquitectura:** [Diagrama en código Mermaid o imagen adjunta]
