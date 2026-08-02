# Skill de Base de Datos (Supabase & PostgreSQL)

Este documento define las buenas prácticas y patrones de diseño para el motor de base de datos relacional PostgreSQL provisto por Supabase.

---

## 1. Diseño Seguro con Row Level Security (RLS)
* **Políticas RLS Obligatorias:**
  * Toda tabla creada en la base de datos debe tener Row Level Security habilitado por defecto:
    ```sql
    ALTER TABLE "NombreTabla" ENABLE ROW LEVEL SECURITY;
    ```
  * Las políticas de seguridad deben ser granulares y verificar las credenciales del usuario autenticado en Supabase.
* **Control de Sesión mediante JWT:**
  * Utilizar la función `auth.uid()` para restringir la consulta o modificación de datos solo a las filas que correspondan al usuario autenticado:
    ```sql
    CREATE POLICY "Usuarios pueden leer sus propios datos"
    ON "Usuarios" FOR SELECT
    USING (auth.uid() = usuario_id);
    ```
  * Utilizar los metadatos y claims del token (`auth.jwt()`) para validaciones avanzadas (ej. validar si el usuario posee rol de administrador).

## 2. Optimización de Supabase Realtime
Supabase Realtime ofrece tres modos distintos. Elegir el adecuado es crítico para la estabilidad de la conexión:
1. **Postgres Changes:**
   * Escucha cambios directos en el log de replicación de tablas (INSERT, UPDATE, DELETE).
   * **Buenas Prácticas:** Usar siempre filtros del lado del servidor para limitar el volumen de eventos transmitidos. Evitar suscribirse a tablas con alto volumen de escritura por segundo (high-write tables), ya que satura la conexión del cliente.
2. **Broadcast:**
   * Ideal para transferencias de datos efímeras y de baja latencia entre clientes conectados (ej. cursores en pantalla, eventos de juego, estado de "escribiendo..." en chat).
   * **Ventaja:** No persiste datos en disco, lo que lo hace sumamente rápido y de bajo costo de cómputo.
3. **Presence:**
   * Utilizado exclusivamente para sincronizar el estado de conexión de usuarios (online/offline) y listados de usuarios activos en una sección.

* **Gobernanza del Ciclo de Vida:**
  * Las IAs de desarrollo deben programar de forma obligatoria el cierre de canales (`removeChannel`) al finalizar los ciclos de vida de los componentes en React o ViewModels en Kotlin para evitar fugas de socket y saturar los límites de conexiones concurrentes del servidor.

## 3. Lógica Procedimental (Triggers, Funciones y Vistas)
* **Funciones de Seguridad (`security definer`):**
  * Al crear triggers o funciones PostgreSQL que deban saltarse el RLS de forma segura (ej. copiar datos de auth.users a la tabla pública de perfiles tras el registro), use `security definer`.
  * **Vulnerabilidad y Mitigación:** Siempre defina explícitamente el `search_path` en las funciones `security definer` para evitar ataques de inyección de rutas en PostgreSQL:
    ```sql
    CREATE FUNCTION public.handle_new_user()
    RETURNS trigger SECURITY DEFINER SET search_path = public
    AS ...
    ```
* **Disparadores (Triggers) de Auditoría:**
  * Toda tabla con estados cambiantes debe contar con un disparador que actualice automáticamente el campo `actualizado_en` ante operaciones de modificación (UPDATE).
