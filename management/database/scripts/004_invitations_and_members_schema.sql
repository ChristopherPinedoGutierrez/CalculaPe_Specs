-- ==========================================
-- SCRIPT DE MIGRACIÓN: 004_invitations_and_members_schema.sql
-- App Origen: backend / mobile
-- Autor: Tech Lead AI
-- Fecha: 2026-08-13
-- Justificación: Agregar el valor 'cancelled' al tipo enum invitation_status, crear el enum member_status y añadir la columna status a group_members.
-- ==========================================

-- 1. Actualizar enum de estado de invitaciones con 'cancelled'
ALTER TYPE public.invitation_status ADD VALUE IF NOT EXISTS 'cancelled';

-- 2. Crear tipo enumerado para estado de membresías en grupo
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'member_status') THEN
        CREATE TYPE public.member_status AS ENUM ('active', 'blocked');
    END IF;
END $$;

-- 3. Añadir columna status a la tabla group_members
ALTER TABLE public.group_members 
ADD COLUMN IF NOT EXISTS status public.member_status DEFAULT 'active'::public.member_status;

-- 4. Política RLS de DELETE en invitaciones para que los administradores/invitadores puedan revocar
DROP POLICY IF EXISTS "Admins o invitadores pueden eliminar sus invitaciones" ON public.invitations;
CREATE POLICY "Admins o invitadores pueden eliminar sus invitaciones" ON public.invitations 
FOR DELETE 
USING (
  invited_by = auth.uid() OR 
  EXISTS (SELECT 1 FROM public.groups WHERE id = group_id AND created_by = auth.uid()) OR 
  EXISTS (SELECT 1 FROM public.group_members WHERE group_id = invitations.group_id AND user_id = auth.uid() AND role = 'admin')
);

-- 5. Política RLS de UPDATE en invitaciones para que el admin pueda revocar o re-invitar
DROP POLICY IF EXISTS "Admins pueden actualizar sus invitaciones" ON public.invitations;
CREATE POLICY "Admins pueden actualizar sus invitaciones" ON public.invitations 
FOR UPDATE 
USING (
  invited_by = auth.uid() OR 
  EXISTS (SELECT 1 FROM public.groups WHERE id = group_id AND created_by = auth.uid()) OR 
  EXISTS (SELECT 1 FROM public.group_members WHERE group_id = invitations.group_id AND user_id = auth.uid() AND role = 'admin')
);
