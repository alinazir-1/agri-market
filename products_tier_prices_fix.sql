alter table public.products
add column if not exists tier_prices jsonb not null default '[]'::jsonb;
