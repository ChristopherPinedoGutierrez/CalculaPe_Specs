# SDD_CDPG_SPECS: Plantilla de Gestión y Especificaciones (Spec-Driven Development)

Este repositorio es una **plantilla genérica estándar** para la gestión y desarrollo de proyectos de software freelance utilizando la metodología de **Spec-Driven Development (SDD)** y agentes de Inteligencia Artificial (como Antigravity).

El objetivo de este sistema es centralizar la especificación (casos de uso, base de datos, APIs y reglas de negocio) en un solo lugar como la **Única Fuente de Verdad (Single Source of Truth - SSOT)**, permitiendo que múltiples aplicaciones secundarias (web, móviles) consuman esta especificación y mantengan un desarrollo ordenado, consistente y sincronizado de forma automática.

---

## 📂 Estructura del Repositorio

La plantilla se organiza en tres bloques principales que separan el conocimiento base, la especificación de producto y la ejecución del desarrollo:

```
[proyecto]_specs/
├── README.md                          # Este manual de uso, roles y responsabilidades
├── .agents/
│   └── AGENTS.md                      # Reglas del agente orquestador master (Comandos /iniciar)
│
├── 1_introduction/                        # EL ADN INCREMENTAL (Templates + Reglas + Skills)
│   ├── templates/                         # Plantillas estáticas para incepción (Intake, Briefing, Blueprint)
│   └── knowledge/                         # Biblioteca de Conocimiento y Jerarquía de Prioridad
│       ├── knowledge_base.md              # Orquestador del conocimiento e idioma (Español default)
│       ├── standard_skills/               # Nivel 1: Estándares internos obligatorios (DB, Git, Clean Code)
│       ├── solutions/                     # Nivel 2: Soluciones técnicas validadas en este proyecto (Bucle de aprendizaje)
│       └── skills/                        # Nivel 3: Skills y buenas prácticas externas (desarrollo/, gestion/, devops/)
│
├── management/                            # GESTIÓN Y ESPECIFICACIÓN ACTIVA (Specs + Backlog + DB)
│   ├── 1.1_intake.md / 1.2_briefing.md / 1.3_blueprint.md
│   ├── BacklogGlobal.md                   # SSOT del Backlog (Mapeado por Entregables/Épicas)
│   ├── database/                          # Estado y scripts de base de datos
│   │   ├── schema.sql                     # Modelo consolidado actual
│   │   └── scripts/                       # Historial de migraciones SQL inmutables
│   └── changelogs/                        # Historial unificado del proyecto (Patrón Híbrido)
│       ├── orquestador.md                 # Línea de tiempo cronológica (Índice)
│       └── changelog_[epic].md            # Bitácoras detalladas por área/épica
│
└── development/                           # WORKSPACE DE EJECUCIÓN (Lógica de las apps)
    ├── Mapeo_Proyectos.md                 # Mapeo físico de repositorios y épicas
    └── apps/
        └── [nombre_app]/
            └── app_instructions.md        # Especificación de ROL del desarrollador de esta app
```

---

## 🚀 Ciclo de Vida y Flujo de Trabajo

El flujo de trabajo se divide en dos fases: **Fase A (Diseño e Incepción)** y **Fase B (Construcción y Desarrollo Diario)**.

### Fase A: Incepción y Diseño (Rol: PM / Arquitecto en `specs/`)
Todo proyecto nuevo o regularización se maneja desde el chat del repositorio `specs/`. Se sigue un flujo secuencial estricto protegido por **Puntos de Control Humanos (Gates)**:

1. **Intake (Gate 1):** Cuestionario interactivo basado en `1.1_intake.md`. El agente PM consolida las respuestas en `management/1.1_intake.md`. *El desarrollador humano debe aprobar explícitamente en el chat para avanzar.*
2. **Briefing (Gate 2):** El agente redacta el alcance comercial y exclusiones del MVP en `management/1.2_briefing.md`. *El desarrollador humano debe aprobar el alcance para avanzar.*
3. **Blueprint Funcional (Gate 3):** El agente diseña la arquitectura, endpoints de API y plan de entregas globales (entregables) en `management/1.3_blueprint.md`. *El desarrollador humano debe aprobar la especificación técnica para avanzar.*
4. **Modelo de Datos e Infraestructura (Gate 4):** El agente diseña el esquema SQL y las reglas RLS definitivas, guardándolas en `management/database/schema.sql`. *El desarrollador humano debe validar el diseño de base de datos para avanzar.*
5. **Handoff a Desarrollo:** Tras la aprobación del Gate 4, el agente autogenera la estructura del backlog global, changelogs e instrucciones en `development/` y `management/`, aplicando en vivo el SQL inicial si cuenta con un conector MCP de Supabase.

---

### Fase B: Desarrollo Diario (Rol: Programador en cada App)
Para programar, el desarrollador humano abre su IDE y abre el chat **dentro del repositorio de la app específica** (ej: `notificape_web/`).

1. **Carga del Contexto:** El agente desarrollador de la app lee el puntero local `.agents/AGENTS.md` el cual lo redirige a cargar sus instrucciones en `3_development/apps/[nombre_app]/app_instructions.md` y las guías de `1_introduction/knowledge/`.
2. **Selección de Tarea:** El agente lee directamente el **`management/BacklogGlobal.md`** centralizado, filtra las tareas donde `App: [nombre_app]` del entregable activo y te pregunta en cuál trabajar.
3. **Programación y Guardado:**
   * El agente escribe el código dentro de la aplicación.
   * **Base de datos (RLS/Triggers):** Si la tarea requiere cambios en base de datos, el agente edita el archivo SQL original **in-place** (en su archivo `.sql` original de la carpeta `scripts/`) para evitar la proliferación de archivos fix, actualizando los metadatos de su cabecera y el archivo maestro `schema.sql`. Si hay MCP, ejecuta el cambio en Supabase.
   * **Cierre de Tarea (Patrón Híbrido):** Al terminar la tarea y compilar con éxito, el agente:
     * Marca la US como completada en `management/BacklogGlobal.md`.
     * Registra el detalle en `management/changelogs/changelog_[area].md` (Sección 4).
     * Añade la línea resumen en `management/changelogs/orquestador.md`.
     * **Bucle de Aprendizaje:** Si se resolvió un problema técnico complejo (ej. Supabase Real-Time en Kotlin), el agente redacta y guarda la nueva guía técnica en `1_introduction/knowledge/solutions/` para enriquecer la base de conocimiento global del template de forma incremental.

---

## 🛠️ Reglas del Control de Cambios y Base de Datos

### 1. Inmutabilidad Estructural vs. Edición In-Place
* **Estructura (Tablas, Columnas):** Son incrementales. Se debe generar un script nuevo numerado (ej. `0003_alter_table.sql`) y actualizar `schema.sql`.
* **Lógica Procedimental (RLS, Triggers, Funciones, Vistas):** Se edita **in-place** directamente sobre su script original de creación en `/database/scripts/`, actualizando los metadatos del encabezado indicando qué aplicación solicitó el cambio, la fecha y la justificación.

### 2. Sincronización Externa (Jira/Notion)
Si se conecta un servidor MCP para Jira o Notion:
* Durante el Handoff, el agente creará de forma automática el tablero y los tickets en la web basándose en `BacklogGlobal.md`.
* Al completar una tarea, el agente transicionará de forma automática el ticket a "Done" y añadirá el log de cambios técnico en los comentarios del tablero web.

### 3. Gobernanza del Conocimiento (Promoción al Template Base)
Para evitar la proliferación de silos de información y permitir que las lecciones aprendidas en proyectos específicos enriquezcan la plantilla base original, el flujo incluye la **Acción 4: "Promover conocimiento local a la plantilla base"**:
* El agente PM realiza una auditoría comparativa entre la carpeta `1_introduction/knowledge/` local y la de la plantilla base indicada.
* Identifica nuevas guías técnicas y secciones modificadas para crear un reporte de cambios.
* Tras la aprobación del usuario humano (Gate 1), el agente copia los archivos de forma local o genera los comandos de Git necesarios para enviar una rama de contribución a la plantilla base original.

---

## 📝 Roadmap y Fases Pendientes de Desarrollo

Esta plantilla se diseñó bajo un principio modular y extensible. Las fases de control que se integrarán en futuras iteraciones de esta plantilla son:

1. **Fase C: Pruebas y Control de Calidad (Testing SOP):**
   * Estructura del flujo de pruebas unitarias e integración que el agente debe ejecutar localmente antes de registrar un changelog.
   * Creación de `1_introduction/knowledge/standard_skills/standard_testing.md`.
2. **Fase D: Despliegue y DevOps (CI/CD SOP):**
   * Lineamientos para que los agentes preparen los entornos de staging/producción, corran las migraciones automáticas y validen los despliegues.
