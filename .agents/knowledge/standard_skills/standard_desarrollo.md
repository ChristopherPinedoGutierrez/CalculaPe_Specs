# Estándar de Desarrollo Limpio y Arquitectura (Generales)

Este documento contiene las directrices generales de calidad de código, manejo de errores y patrones de diseño recomendados para cualquier desarrollo de software en este proyecto.

---

## 1. Principios Generales de Código Limpio y Arquitectura
* **KISS (Keep It Simple, Stupid):** El código debe ser lo más simple posible. Evita la sobreingeniería o anticipar necesidades futuras que no estén en el backlog.
* **DRY (Don't Repeat Yourself):** Evita la duplicación de código. Si una lógica se repite más de dos veces, refactorízala en una función, hook o componente reutilizable.
* **Nombres Descriptivos:** Nombres de variables, clases y funciones que indiquen claramente su propósito sin necesidad de comentarios.
* **Principios SOLID (Énfasis en SRP - Single Responsibility Principle):** Cada componente, clase o módulo debe tener una única razón para cambiar. Los componentes de interfaz de usuario (UI) no deben interactuar de forma directa con la base de datos o API; deben delegar estas tareas a custom hooks o servicios de datos independientes.
* **Clean Architecture (Arquitectura de Capas):** Se debe procurar la separación física de responsabilidades en tres capas fundamentales: Presentación (UI/Vistas), Dominio (Lógica pura de negocio abstracta) y Datos (Mecanismos de persistencia, Supabase y llamadas a red), evitando el acoplamiento directo entre la interfaz y la infraestructura de red.

## 2. Manejo de Errores y Asincronía
* Toda operación asíncrona (llamadas a API, queries de base de datos) debe estar envuelta en bloques de control de excepciones (`try-catch` o equivalente).
* Los errores deben capturarse de forma específica y mapearse a mensajes o estados legibles para el usuario final, registrando el error técnico en consola o logs para depuración.
* No se permiten promesas o flujos asíncronos "huérfanos" que puedan causar caídas del sistema o fugas de memoria.

## 3. Pautas de Frontend (Web)
* **Componentes Reactivos:** Mantener los componentes pequeños, modulares y enfocados en una sola responsabilidad.
* **Separación de Lógica:** Extraer la lógica de negocio y llamadas a API hacia Custom Hooks o controladores, manteniendo el componente de vista puramente enfocado en renderizar la UI.
* **Manejo de Estado:** Utilizar estados locales (`useState`) para interfaces simples, y estados globales o de servidor (ej. Context, Redux, React Query) solo cuando los datos se compartan entre múltiples vistas.

## 4. Pautas de Backend y Aplicaciones Móviles
* **Arquitectura de Capas:** Estructurar el código separando la capa de presentación (UI/Controllers), la capa de negocio (ViewModels/Services) y la capa de datos (Repositories/DataSources).
* **Idempotencia:** Asegurar que las llamadas de creación de datos en el backend sean seguras ante reintentos por pérdida de conexión (uso de claves únicas).
