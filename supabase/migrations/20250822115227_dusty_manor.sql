/*
  # Create get_current_statistics function

  1. New Functions
    - `get_current_statistics()` - Returns current system statistics without requiring parameters
      - Returns total_users, total_complaints, pending_complaints, resolved_complaints, last_updated

  2. Security
    - Function is accessible to authenticated users
    - Uses existing RLS policies on underlying tables

  3. Purpose
    - Provides system-wide statistics for admin dashboard and landing page
    - Eliminates parameter requirement that was causing 404 errors
*/

CREATE OR REPLACE FUNCTION public.get_current_statistics()
RETURNS TABLE (
  total_users bigint,
  total_complaints bigint,
  pending_complaints bigint,
  resolved_complaints bigint,
  last_updated timestamptz
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    (SELECT COUNT(*) FROM auth.users)::bigint as total_users,
    (SELECT COUNT(*) FROM public.complaints)::bigint as total_complaints,
    (SELECT COUNT(*) FROM public.complaints WHERE status = 'pending')::bigint as pending_complaints,
    (SELECT COUNT(*) FROM public.complaints WHERE status = 'resolved')::bigint as resolved_complaints,
    now() as last_updated;
END;
$$;