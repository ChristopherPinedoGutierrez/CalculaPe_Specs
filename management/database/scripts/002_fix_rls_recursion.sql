-- ==========================================
-- SCRIPT: 002_fix_rls_recursion.sql
-- App Origen: backend / Supabase
-- Autor: AGENT_ROLE
-- Fecha: 2026-08-12
-- Justificación: Corregir la recursión infinita en las políticas RLS de group_members, groups, categories y transactions.
-- ==========================================

-- 1. Crear función auxiliar con SECURITY DEFINER para romper la recursión RLS
CREATE OR REPLACE FUNCTION public.get_user_group_ids(_user_id uuid)
RETURNS SETOF uuid AS $$
  SELECT group_id FROM public.group_members WHERE user_id = _user_id;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- 2. Reemplazar políticas de group_members
DROP POLICY IF EXISTS "Ver miembros de mi grupo" ON public.group_members;
CREATE POLICY "Ver miembros de mi grupo" ON public.group_members FOR SELECT 
USING (user_id = auth.uid() OR group_id IN (SELECT public.get_user_group_ids(auth.uid())));

-- 3. Reemplazar políticas de groups
DROP POLICY IF EXISTS "Ver grupos propios o donde soy miembro" ON public.groups;
CREATE POLICY "Ver grupos propios o donde soy miembro" ON public.groups FOR SELECT 
USING (created_by = auth.uid() OR id IN (SELECT public.get_user_group_ids(auth.uid())));

-- 4. Reemplazar políticas de transacciones
DROP POLICY IF EXISTS "Ver transacciones propias o grupales" ON public.transactions;
CREATE POLICY "Ver transacciones propias o grupales" ON public.transactions FOR SELECT 
USING (
    (group_id IS NULL AND created_by = auth.uid()) OR 
    (group_id IS NOT NULL AND group_id IN (SELECT public.get_user_group_ids(auth.uid())))
);

DROP POLICY IF EXISTS "Insertar transacciones propias o grupales" ON public.transactions;
CREATE POLICY "Insertar transacciones propias o grupales" ON public.transactions FOR INSERT 
WITH CHECK (
    (group_id IS NULL AND created_by = auth.uid()) OR 
    (group_id IS NOT NULL AND group_id IN (SELECT public.get_user_group_ids(auth.uid())))
);

-- 5. Reemplazar políticas de categorías
DROP POLICY IF EXISTS "Catalogos globales y grupales" ON public.categories;
CREATE POLICY "Catalogos globales y grupales" ON public.categories FOR SELECT 
USING (is_global = true OR group_id IN (SELECT public.get_user_group_ids(auth.uid())));
