-- ==========================================
-- SCRIPT DE MIGRACIÓN: 002_invitations_rpc.sql
-- App Origen: backend / mobile
-- Autor: Tech Lead AI
-- Fecha: 2026-08-13
-- Justificación: Agregar el valor 'declined' al enum invitation_status y definir las funciones RPC accept_invitation y reject_invitation con SECURITY DEFINER.
-- ==========================================

-- 1. Actualizar enum de estado de invitaciones
ALTER TYPE public.invitation_status ADD VALUE IF NOT EXISTS 'declined';

-- 2. Función RPC para Aceptar Invitación
CREATE OR REPLACE FUNCTION public.accept_invitation(p_invitation_id UUID)
RETURNS void AS $$
DECLARE
  v_group_id UUID;
  v_email TEXT;
  v_user_id UUID;
  v_creator_id UUID;
  v_creator_tier public.subscription_type;
  v_member_count INT;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED: Usuario no autenticado.';
  END IF;

  -- Obtener email del usuario
  SELECT email INTO v_email FROM public.profiles WHERE id = v_user_id;

  -- Buscar invitación pendiente
  SELECT group_id INTO v_group_id
  FROM public.invitations
  WHERE id = p_invitation_id AND (email = v_email OR email = (SELECT email FROM auth.users WHERE id = v_user_id)) AND status = 'pending';

  IF v_group_id IS NULL THEN
    RAISE EXCEPTION 'NOT_FOUND: Invitación no encontrada o ya procesada.';
  END IF;

  -- Evaluar límite Freemium del creador del grupo
  SELECT created_by INTO v_creator_id FROM public.groups WHERE id = v_group_id;
  SELECT subscription_tier INTO v_creator_tier FROM public.profiles WHERE id = v_creator_id;

  IF v_creator_tier = 'free' THEN
    SELECT count(*) INTO v_member_count FROM public.group_members WHERE group_id = v_group_id;
    IF v_member_count >= 3 THEN
      RAISE EXCEPTION 'FREEMIUM_LIMIT_REACHED: El grupo ha alcanzado el límite máximo de 3 miembros para el plan Free.';
    END IF;
  END IF;

  -- Insertar miembro
  INSERT INTO public.group_members (group_id, user_id, role)
  VALUES (v_group_id, v_user_id, 'member')
  ON CONFLICT (group_id, user_id) DO NOTHING;

  -- Actualizar estado
  UPDATE public.invitations
  SET status = 'accepted'
  WHERE id = p_invitation_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Función RPC para Rechazar Invitación
CREATE OR REPLACE FUNCTION public.reject_invitation(p_invitation_id UUID)
RETURNS void AS $$
DECLARE
  v_user_id UUID;
  v_email TEXT;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'UNAUTHORIZED: Usuario no autenticado.';
  END IF;

  SELECT email INTO v_email FROM public.profiles WHERE id = v_user_id;

  UPDATE public.invitations
  SET status = 'declined'
  WHERE id = p_invitation_id AND (email = v_email OR email = (SELECT email FROM auth.users WHERE id = v_user_id));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
