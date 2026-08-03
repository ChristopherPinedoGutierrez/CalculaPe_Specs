-- CalculaPe - Esquema Base de Datos (Supabase / PostgreSQL)

-- 1. Extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Entidad: Perfiles (profiles)
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(255),
    display_name VARCHAR(100),
    avatar_type VARCHAR(50) DEFAULT 'google',
    avatar_url TEXT,
    subscription_tier VARCHAR(50) DEFAULT 'free', -- 'free', 'pro'
    subscription_status VARCHAR(50) DEFAULT 'active',
    subscription_expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Entidad: Grupos (groups)
CREATE TABLE public.groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_by UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Entidad: Miembros del Grupo (group_members)
CREATE TABLE public.group_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    group_nickname VARCHAR(100),
    role VARCHAR(50) NOT NULL DEFAULT 'member', -- 'admin', 'member'
    monthly_income NUMERIC(12, 2) DEFAULT 0.00,
    joined_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_group_member UNIQUE (group_id, user_id)
);

-- 5. Entidad: Categorías (categories)
CREATE TABLE public.categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(100),
    is_default BOOLEAN DEFAULT false,
    created_by UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Entidad: Métodos de Pago (payment_methods)
CREATE TABLE public.payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(100),
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 7. Entidad: Comercios / Establecimientos (merchants)
CREATE TABLE public.merchants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    tax_id VARCHAR(50), -- RUC / NIF
    default_category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 8. Entidad: Transacciones (transactions)
CREATE TABLE public.transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    amount NUMERIC(12, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'PEN',
    transaction_type VARCHAR(50) DEFAULT 'expense', -- 'expense', 'income'
    date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
    merchant_id UUID REFERENCES public.merchants(id) ON DELETE SET NULL,
    payment_method_id UUID REFERENCES public.payment_methods(id) ON DELETE SET NULL,
    split_type VARCHAR(50) DEFAULT 'direct', -- 'equal', 'proportional', 'direct'
    receipt_url TEXT,
    qr_raw_data TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 9. Entidad: Invitaciones (invitations)
CREATE TABLE public.invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
    invited_email VARCHAR(255) NOT NULL,
    invited_by UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    invitee_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'accepted', 'rejected', 'cancelled'
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- LÓGICA DE NEGOCIO Y LÍMITES FREEMIUM (GATING)
-- ==========================================

-- Trigger: Límite de grupos por usuario gratuito
CREATE OR REPLACE FUNCTION enforce_free_tier_group_limit()
RETURNS TRIGGER AS $$
DECLARE
    user_tier VARCHAR;
    group_count INT;
BEGIN
    SELECT subscription_tier INTO user_tier FROM public.profiles WHERE id = NEW.created_by;
    
    IF user_tier = 'free' THEN
        SELECT COUNT(*) INTO group_count FROM public.groups WHERE created_by = NEW.created_by;
        IF group_count >= 2 THEN
            RAISE EXCEPTION 'Límite de grupos alcanzado para el plan gratuito.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_group_limit
BEFORE INSERT ON public.groups
FOR EACH ROW EXECUTE FUNCTION enforce_free_tier_group_limit();

-- Trigger: Límite de miembros por grupo gratuito
CREATE OR REPLACE FUNCTION enforce_free_tier_member_limit()
RETURNS TRIGGER AS $$
DECLARE
    creator_id UUID;
    creator_tier VARCHAR;
    member_count INT;
BEGIN
    SELECT created_by INTO creator_id FROM public.groups WHERE id = NEW.group_id;
    SELECT subscription_tier INTO creator_tier FROM public.profiles WHERE id = creator_id;
    
    IF creator_tier = 'free' THEN
        SELECT COUNT(*) INTO member_count FROM public.group_members WHERE group_id = NEW.group_id;
        IF member_count >= 5 THEN
            RAISE EXCEPTION 'Límite de miembros (5) alcanzado para este grupo en el plan gratuito.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_member_limit
BEFORE INSERT ON public.group_members
FOR EACH ROW EXECUTE FUNCTION enforce_free_tier_member_limit();

-- ==========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==========================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;

-- Profiles: Lectura pública (para invitaciones), escritura por sí mismo
CREATE POLICY "Profiles are readable by everyone" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Groups: Lectura para miembros, edición para admins
CREATE POLICY "Groups readable by members" ON public.groups FOR SELECT 
USING (EXISTS (SELECT 1 FROM public.group_members WHERE group_id = public.groups.id AND user_id = auth.uid()));

CREATE POLICY "Groups editable by admins" ON public.groups FOR UPDATE
USING (EXISTS (SELECT 1 FROM public.group_members WHERE group_id = public.groups.id AND user_id = auth.uid() AND role = 'admin'));

-- Transactions: Privadas o Grupales
CREATE POLICY "Transactions visibility" ON public.transactions FOR SELECT 
USING (
  (group_id IS NULL AND user_id = auth.uid()) OR 
  (group_id IS NOT NULL AND EXISTS (SELECT 1 FROM public.group_members WHERE group_id = public.transactions.group_id AND user_id = auth.uid()))
);

CREATE POLICY "Transactions editing" ON public.transactions FOR UPDATE
USING (
  (group_id IS NULL AND user_id = auth.uid()) OR 
  (group_id IS NOT NULL AND (user_id = auth.uid() OR EXISTS (SELECT 1 FROM public.group_members WHERE group_id = public.transactions.group_id AND user_id = auth.uid() AND role = 'admin')))
);
