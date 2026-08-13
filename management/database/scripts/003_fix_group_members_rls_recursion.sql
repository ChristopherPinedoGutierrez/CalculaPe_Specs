-- =============================================================================
-- SCRIPT: 003_fix_group_members_rls_recursion.sql
-- APP: backend / mobile
-- AUTOR: AGENT_ROLE
-- FECHA: 2026-08-13
-- JUSTIFICACIÓN: Solucionar el error 'infinite recursion detected in policy for relation "group_members"'
--                creando una función SECURITY DEFINER para verificar rol de admin sin disparar recursividad RLS.
-- =============================================================================

-- 1. Crear función SECURITY DEFINER para verificar si un usuario es admin de un grupo
CREATE OR REPLACE FUNCTION public.is_group_admin(_group_id uuid, _user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 
    FROM public.group_members
    WHERE group_id = _group_id
      AND user_id = _user_id
      AND role = 'admin'
  );
$$;

-- 2. Reemplazar política de INSERT en group_members
DROP POLICY IF EXISTS "Admins pueden insertar miembros" ON public.group_members;

CREATE POLICY "Admins pueden insertar miembros"
ON public.group_members
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.groups
    WHERE id = group_id AND created_by = auth.uid()
  )
  OR public.is_group_admin(group_id, auth.uid())
);

-- 3. Reemplazar política de UPDATE en group_members
DROP POLICY IF EXISTS "Admins o usuarios propios pueden actualizar" ON public.group_members;

CREATE POLICY "Admins o usuarios propios pueden actualizar"
ON public.group_members
FOR UPDATE
USING (
  user_id = auth.uid()
  OR public.is_group_admin(group_id, auth.uid())
);
