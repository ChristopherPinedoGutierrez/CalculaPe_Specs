# Biblioteca de Conocimiento y Estándares (Knowledge Base)

Este documento es el orquestador e índice centralizado de las pautas de ingeniería, estándares de calidad y metodologías de desarrollo que todos los agentes deben seguir estrictamente.

---

## 🌎 Idioma de Operación y Comunicación
> [!IMPORTANT]
> **Regla Global:** Toda interacción conversacional, preguntas, explicaciones y reportes dirigidos al desarrollador humano se realizarán obligatoriamente en **Español**. Los términos técnicos de programación, nombres de variables o archivos pueden utilizar el inglés según el estándar de desarrollo correspondiente, pero la comunicación del chat siempre será en español.

---

## 📂 Directorio de Conocimiento y Jerarquía de Prioridad

Al auditar, diseñar o codificar, el agente debe seguir estrictamente un orden de jerarquía para evitar contradicciones. Los estándares definidos por el desarrollador para este proyecto tienen prioridad absoluta sobre los lineamientos externos de la industria:

### 1. Nivel 1 (Máxima Prioridad): Estándares Internos (standard_skills/)
Estas son las reglas de diseño y convenciones obligatorias definidas por el desarrollador para este proyecto en particular. Tienen precedencia absoluta sobre cualquier skill externa:
* [Estándar de Base de Datos](file:///1_introduction/knowledge/standard_skills/standard_database.md): Convenciones de nomenclatura relacional (snake_case), UUIDs y políticas de seguridad RLS.
* [Estándar de Git y Changelog](file:///1_introduction/knowledge/standard_skills/standard_git.md): Criterios para documentar los avances utilizando el formato de registro unificado y atómico.
* [Estándar de Desarrollo Limpio](file:///1_introduction/knowledge/standard_skills/standard_desarrollo.md): Pautas generales de clean code, manejo de errores asíncronos y arquitectura del software.

### 2. Nivel 2 (Prioridad Media): Soluciones de Proyecto (solutions/)
Casos de uso específicos y guías técnicas de aprendizaje generadas durante el desarrollo de este proyecto para resolver problemas técnicos concretos y homogeneizar soluciones entre aplicaciones:
* *(Se poblará dinámicamente con guías técnicas de aprendizaje dentro de `1_introduction/knowledge/solutions/` conforme se codifiquen las tareas).*

### 3. Nivel 3 (Prioridad de Referencia): Biblioteca de Buenas Prácticas Externas (skills/)
Lineamientos y guías de desarrollo consolidadas descargadas de internet (ej. Android MAD de Google, guías oficiales de Supabase o Vite) que sirven como marco de consulta y referencia:
* *(Se organizan en la carpeta `1_introduction/knowledge/skills/` subdividida en desarrollo/, gestion/ y devops/).*
