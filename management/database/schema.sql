-- ==========================================
-- ARCHIVO MAESTRO DE ESQUEMA DE BASE DE DATOS
-- Proyecto: CalculaPe
-- Este archivo representa el estado consolidado de la base de datos.
-- ==========================================

-- 1. TIPOS ENUMERADOS
CREATE TYPE public.subscription_type AS ENUM ('free', 'pro');
CREATE TYPE public.member_role AS ENUM ('admin', 'member');
CREATE TYPE public.invitation_status AS ENUM ('pending', 'accepted');

-- 2. TABLAS BASE
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    display_name TEXT,
    avatar_url TEXT,
    subscription_tier public.subscription_type DEFAULT 'free'::public.subscription_type,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    created_by UUID NOT NULL REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.group_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    role public.member_role DEFAULT 'member'::public.member_role,
    group_nickname TEXT,
    monthly_income NUMERIC(12, 2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (group_id, user_id)
);

CREATE TABLE public.invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    invited_by UUID NOT NULL REFERENCES public.profiles(id),
    status public.invitation_status DEFAULT 'pending'::public.invitation_status,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. TABLAS OPERATIVAS
CREATE TABLE public.categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    icon TEXT,
    is_global BOOLEAN DEFAULT true,
    group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    type TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.merchants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ruc TEXT,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    amount NUMERIC(12, 2) NOT NULL,
    currency TEXT DEFAULT 'PEN',
    transaction_date TIMESTAMPTZ NOT NULL,
    description TEXT,
    category_id UUID REFERENCES public.categories(id),
    payment_method_id UUID REFERENCES public.payment_methods(id),
    merchant_id UUID REFERENCES public.merchants(id),
    group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
    created_by UUID NOT NULL REFERENCES public.profiles(id),
    receipt_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. SEGURIDAD RLS (ROW LEVEL SECURITY)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.merchants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- Políticas de Profiles
CREATE POLICY "Perfiles públicos para lectura" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Usuarios pueden actualizar su propio perfil" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Políticas de Groups
-- Función auxiliar con SECURITY DEFINER para romper recursión en políticas RLS
CREATE OR REPLACE FUNCTION public.get_user_group_ids(_user_id uuid)
RETURNS SETOF uuid AS $$
  SELECT group_id FROM public.group_members WHERE user_id = _user_id;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Políticas de Groups
CREATE POLICY "Ver grupos propios o donde soy miembro" ON public.groups FOR SELECT 
USING (created_by = auth.uid() OR id IN (SELECT public.get_user_group_ids(auth.uid())));
CREATE POLICY "Crear grupos propios" ON public.groups FOR INSERT WITH CHECK (created_by = auth.uid());
CREATE POLICY "Actualizar grupos creados" ON public.groups FOR UPDATE USING (created_by = auth.uid());

-- Función auxiliar con SECURITY DEFINER para verificar rol admin sin disparar recursión RLS
CREATE OR REPLACE FUNCTION public.is_group_admin(_group_id uuid, _user_id uuid)
RETURNS boolean AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.group_members
    WHERE group_id = _group_id AND user_id = _user_id AND role = 'admin'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Políticas de Group Members
CREATE POLICY "Ver miembros de mi grupo" ON public.group_members FOR SELECT 
USING (user_id = auth.uid() OR group_id IN (SELECT public.get_user_group_ids(auth.uid())));
CREATE POLICY "Admins pueden insertar miembros" ON public.group_members FOR INSERT 
WITH CHECK (
    EXISTS (SELECT 1 FROM public.groups WHERE id = group_id AND created_by = auth.uid()) OR 
    public.is_group_admin(group_id, auth.uid())
);
CREATE POLICY "Admins o usuarios propios pueden actualizar" ON public.group_members FOR UPDATE 
USING (
    user_id = auth.uid() OR 
    public.is_group_admin(group_id, auth.uid())
);

-- Políticas de Invitations
CREATE POLICY "Ver mis invitaciones enviadas o recibidas" ON public.invitations FOR SELECT 
USING (email = (SELECT email FROM public.profiles WHERE id = auth.uid()) OR invited_by = auth.uid());
CREATE POLICY "Admins pueden invitar" ON public.invitations FOR INSERT 
WITH CHECK (
    EXISTS (SELECT 1 FROM public.groups WHERE id = group_id AND created_by = auth.uid()) OR 
    EXISTS (SELECT 1 FROM public.group_members WHERE group_id = invitations.group_id AND user_id = auth.uid() AND role = 'admin')
);

-- Políticas de Transacciones
CREATE POLICY "Ver transacciones propias o grupales" ON public.transactions FOR SELECT 
USING (
    (group_id IS NULL AND created_by = auth.uid()) OR 
    (group_id IS NOT NULL AND group_id IN (SELECT public.get_user_group_ids(auth.uid())))
);
CREATE POLICY "Insertar transacciones propias o grupales" ON public.transactions FOR INSERT 
WITH CHECK (
    (group_id IS NULL AND created_by = auth.uid()) OR 
    (group_id IS NOT NULL AND group_id IN (SELECT public.get_user_group_ids(auth.uid())))
);
CREATE POLICY "Editar transacciones propias o por admin" ON public.transactions FOR UPDATE 
USING (
    created_by = auth.uid() OR 
    EXISTS (SELECT 1 FROM public.group_members WHERE group_id = transactions.group_id AND user_id = auth.uid() AND role = 'admin')
);
CREATE POLICY "Eliminar transacciones propias o por admin" ON public.transactions FOR DELETE 
USING (
    created_by = auth.uid() OR 
    EXISTS (SELECT 1 FROM public.group_members WHERE group_id = transactions.group_id AND user_id = auth.uid() AND role = 'admin')
);

-- Políticas generales de catálogos (Categorías, Metodos, Comercios)
CREATE POLICY "Catalogos globales y grupales" ON public.categories FOR SELECT USING (is_global = true OR group_id IN (SELECT public.get_user_group_ids(auth.uid())));
CREATE POLICY "Metodos de pago globales" ON public.payment_methods FOR SELECT USING (true);
CREATE POLICY "Comercios globales" ON public.merchants FOR SELECT USING (true);


-- 5. FUNCIONES Y TRIGGERS

-- Trigger: Crear perfil auto cuando se registra en auth.users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, display_name, avatar_url)
  VALUES (new.id, new.email, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Trigger: Procesar invitaciones pendientes cuando se crea el perfil
CREATE OR REPLACE FUNCTION public.process_pending_invitations()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.group_members (group_id, user_id, role)
  SELECT group_id, new.id, 'member'
  FROM public.invitations
  WHERE email = new.email AND status = 'pending';
  
  UPDATE public.invitations
  SET status = 'accepted'
  WHERE email = new.email AND status = 'pending';
  
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_profile_created ON public.profiles;
CREATE TRIGGER on_profile_created
  AFTER INSERT ON public.profiles
  FOR EACH ROW EXECUTE PROCEDURE public.process_pending_invitations();

-- Trigger: Freemium Límites de Grupo (Max 1)
CREATE OR REPLACE FUNCTION public.enforce_group_freemium_limits()
RETURNS trigger AS $$
DECLARE
  creator_tier public.subscription_type;
  group_count int;
BEGIN
  SELECT subscription_tier INTO creator_tier FROM public.profiles WHERE id = new.created_by;
  
  IF creator_tier = 'free' THEN
    SELECT count(*) INTO group_count FROM public.groups WHERE created_by = new.created_by;
    IF group_count >= 1 THEN
      RAISE EXCEPTION 'FREEMIUM_LIMIT_REACHED: Maximo 1 grupo para usuarios free.';
    END IF;
  END IF;
  
  RETURN new;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS before_group_insert ON public.groups;
CREATE TRIGGER before_group_insert
  BEFORE INSERT ON public.groups
  FOR EACH ROW EXECUTE PROCEDURE public.enforce_group_freemium_limits();

-- Trigger: Freemium Límites de Miembros (Max 3)
CREATE OR REPLACE FUNCTION public.enforce_member_freemium_limits()
RETURNS trigger AS $$
DECLARE
  creator_id uuid;
  creator_tier public.subscription_type;
  member_count int;
BEGIN
  SELECT created_by INTO creator_id FROM public.groups WHERE id = new.group_id;
  SELECT subscription_tier INTO creator_tier FROM public.profiles WHERE id = creator_id;
  
  IF creator_tier = 'free' THEN
    SELECT count(*) INTO member_count FROM public.group_members WHERE group_id = new.group_id;
    IF member_count >= 3 THEN
      RAISE EXCEPTION 'FREEMIUM_LIMIT_REACHED: Maximo 3 miembros por grupo para plan free.';
    END IF;
  END IF;
  
  RETURN new;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS before_member_insert ON public.group_members;
CREATE TRIGGER before_member_insert
  BEFORE INSERT ON public.group_members
  FOR EACH ROW EXECUTE PROCEDURE public.enforce_member_freemium_limits();
