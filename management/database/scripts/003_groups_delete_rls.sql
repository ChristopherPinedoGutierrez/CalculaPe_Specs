-- ==========================================
-- SCRIPT DE MIGRACIÓN: 003_groups_delete_rls.sql
-- App Origen: backend / mobile
-- Autor: Tech Lead AI
-- Fecha: 2026-08-13
-- Justificación: Agregar política RLS de DELETE en la tabla groups para permitir a los administradores/creadores eliminar grupos en Supabase.
-- ==========================================

-- Agregar política de DELETE para grupos
DROP POLICY IF EXISTS "Eliminar grupos creados por el dueño" ON public.groups;
CREATE POLICY "Eliminar grupos creados por el dueño" ON public.groups FOR DELETE USING (created_by = auth.uid());
