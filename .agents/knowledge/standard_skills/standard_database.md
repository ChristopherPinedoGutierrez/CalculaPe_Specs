# Estándar de Base de Datos y Supabase

Este documento define las reglas obligatorias de nomenclatura y diseño de base de datos que todos los agentes deben seguir para este proyecto.

---

## 1. Nomenclatura de Objetos (Naming Conventions)
* **Tablas:** Minúsculas, plural y utilizando `snake_case` (ej. `usuarios`, `transacciones_bancarias`).
  * *Regla de Compatibilidad Legacy (Prudencia Operativa):* Si el proyecto a integrar posee una nomenclatura preexistente (como PascalCase con comillas dobles, ej: `"Usuarios"`, `"TransaccionesBancarias"`), y cambiarla requeriría una refactorización profunda que afecte a múltiples aplicaciones en producción, se debe conservar la nomenclatura preexistente para evitar breaking changes. Toda tabla nueva creada a partir de la integración deberá seguir estrictamente el estándar de minúsculas y `snake_case`. En proyectos nuevos desarrollados desde cero, no se permiten excepciones.
* **Columnas:** Minúsculas y utilizando `snake_case` (ej. `nombre_completo`, `creado_en`).
* **Claves Primarias (PK):** Siempre deben llamarse `id` y ser de tipo `UUID` autogenerado (`gen_random_uuid()`).
* **Claves Foráneas (FK):** Deben llamarse `[nombre_tabla_singular]_id` (ej. `usuario_id`).

## 2. Auditoría y Fechas
* Todas las tablas deben contener obligatoriamente los campos:
  * `creado_en` de tipo `timestamp with time zone` con valor por defecto `now()`.
  * `actualizado_en` de tipo `timestamp with time zone` con valor por defecto `now()`.
* Si la tabla maneja transacciones críticas o estados financieros, debe contar con un disparador (trigger) que actualice `actualizado_en` de forma automática.

## 3. Seguridad a Nivel de Fila (RLS)
* Todas las tablas en Supabase deben tener habilitado **Row Level Security (RLS)** de forma obligatoria (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY;`).
* Toda política RLS debe documentarse detallando qué roles (ej. `authenticated`, `anon`) tienen acceso de tipo SELECT, INSERT, UPDATE o DELETE.

## 4. Tipos de Datos Estándar
* **Monedas y Dinero:** Usar siempre `numeric` o `decimal` para evitar errores de precisión de punto flotante.
* **Estados y Opciones:** Usar tipos `ENUM` creados previamente para delimitar los estados (ej. `estado_pago`).
