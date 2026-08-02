# Plantilla: Cuestionario de Descubrimiento (Intake)

Esta plantilla es utilizada por el agente para guiar la entrevista inicial con el cliente o dueño del negocio.

---

## 1. Visión y Valor de Negocio (El Propósito)
* **Problema Raíz:** Si no hiciéramos este desarrollo, ¿qué problema seguiría existiendo en el negocio? ¿Cómo se hace hoy?
* **Usuarios Finales:** ¿Quiénes utilizarán la solución (perfil técnico, edad promedio, en qué dispositivo se usará más)?
* **Métrica de Éxito:** ¿Qué número, evento o indicador clave nos dirá: "el software funciona y aporta valor"?
* **Tiempo y Presupuesto:** ¿Existe una fecha límite inamovible (evento, feria, lanzamiento)? ¿Cuáles son las restricciones de presupuesto para infraestructura/servicios de terceros?

## 2. Alcance Funcional (El "Qué")
* **Flujo Principal:** Describe el recorrido lógico del usuario desde que abre la aplicación hasta que completa su objetivo principal.
* **Gestión de Datos (CRUD):** ¿Qué información se necesita crear, leer, actualizar o eliminar en el sistema (ej. usuarios, productos, transacciones)?
* **Roles y Permisos:** ¿Todos los usuarios verán lo mismo o habrá diferentes niveles de acceso (ej. Administrador, Vendedor, Cliente)?
* **Reportes y Salidas:** ¿Se requiere generación de reportes en PDF, exportación a Excel o visualización de gráficos estadísticos?

## 3. Atributos de Calidad (Requisitos No Funcionales)
* **Disponibilidad:** ¿El sistema debe estar activo 24/7 o hay horarios críticos (ej. solo horario de oficina)?
* **Escalabilidad:** ¿Cuántos usuarios recurrentes esperamos en el primer mes y a largo plazo?
* **Conectividad:** ¿La solución requiere funcionar sin conexión a internet (Offline-first) o asumimos que siempre habrá red móvil/Wi-Fi?
* **Soporte y Mantenimiento:** ¿Quién mantendrá el servidor y actualizará la app una vez entregada?

## 4. Legalidad, Seguridad y Finanzas (El Blindaje)
* **Privacidad de Datos (Perú):** ¿Se capturarán nombres, correos o números telefónicos de clientes finales? (Recordar cumplimiento de la **Ley N° 29733 - Ley de Protección de Datos Personales en Perú**).
* **Consentimiento y Términos de Servicio:** ¿El cliente entiende las implicaciones de integrar APIs o "escuchar" notificaciones de aplicaciones bancarias de terceros (como Yape/Plin)? ¿Cómo autorizan los usuarios el uso de sus datos?
* **Falsos Positivos y Robustez:** ¿Qué medidas se plantean si una notificación o mensaje de transacción falla, cambia de formato de texto o se duplica por problemas de red?
* **Auditoría e Integridad:** ¿Se requiere registrar la identidad del usuario, coordenadas GPS o ID del dispositivo al confirmar transacciones críticas?
* **Latencia Aceptable:** ¿Cuál es el tiempo máximo que puede transcurrir desde que se realiza una acción (ej. pago recibido) hasta que se refleja en la pantalla del vendedor?
