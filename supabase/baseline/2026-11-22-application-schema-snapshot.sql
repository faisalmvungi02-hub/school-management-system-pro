-- PLUS OS application-schema snapshot generated from live Supabase catalogs on 2026-11-22.
-- Scope: public + private application schemas only. No table data, Auth/Storage internals,
-- extension installation state, Vault secrets, API grants, auth settings, Edge Functions,
-- Realtime publication settings, or platform-managed objects are included.
-- IMPORTANT: This is a catalog-derived schema snapshot, NOT a verified pg_dump restore.
-- Restore only into a disposable Supabase test project after provisioning required extensions.
-- Validate ordering/dependencies, grants, policies, and a full restore before calling it recovery-ready.

SET search_path = public, private;

CREATE SCHEMA IF NOT EXISTS private;

CREATE TABLE IF NOT EXISTS private.audit_logs (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  school_id uuid,
  actor_user_id uuid,
  action text NOT NULL,
  table_name text NOT NULL,
  record_id uuid,
  changed_columns text[] DEFAULT ARRAY[]::text[] NOT NULL,
  changed_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS private.school_payment_gateway_settings (
  school_id uuid NOT NULL,
  active_provider text DEFAULT 'selcom'::text NOT NULL,
  updated_by uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.academic_years (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  name text NOT NULL,
  starts_on date NOT NULL,
  ends_on date NOT NULL,
  is_current boolean DEFAULT false NOT NULL,
  status text DEFAULT 'planned'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.admission_applications (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  application_number text NOT NULL,
  academic_year_id uuid NOT NULL,
  applicant_first_name text NOT NULL,
  applicant_last_name text NOT NULL,
  applying_grade text NOT NULL,
  guardian_name text NOT NULL,
  guardian_phone text NOT NULL,
  status text DEFAULT 'submitted'::text NOT NULL,
  reviewed_by uuid,
  reviewed_at timestamp with time zone,
  decision_notes text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.admission_documents (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  application_id uuid NOT NULL,
  document_type text NOT NULL,
  object_path text NOT NULL,
  verification_status text DEFAULT 'pending'::text NOT NULL,
  uploaded_by uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.ai_assistant_messages (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  session_id uuid NOT NULL,
  sender_role text NOT NULL,
  content text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.ai_assistant_sessions (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  user_id uuid NOT NULL,
  context_type text DEFAULT 'general'::text NOT NULL,
  title text,
  status text DEFAULT 'active'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.ai_usage_ledger (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  user_id uuid NOT NULL,
  session_id uuid,
  provider text NOT NULL,
  model text NOT NULL,
  input_tokens bigint DEFAULT 0 NOT NULL,
  output_tokens bigint DEFAULT 0 NOT NULL,
  estimated_cost numeric(14,6) DEFAULT 0 NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.announcements (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  title text NOT NULL,
  body text NOT NULL,
  audience text DEFAULT 'school'::text NOT NULL,
  publish_at timestamp with time zone,
  expires_at timestamp with time zone,
  created_by_membership_id uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.assessment_scores (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  assessment_id uuid NOT NULL,
  student_id uuid NOT NULL,
  score numeric(10,2) NOT NULL,
  remarks text,
  entered_by_staff_id uuid,
  entered_at timestamp with time zone DEFAULT now() NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.assessments (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  class_subject_id uuid NOT NULL,
  title text NOT NULL,
  assessment_type text NOT NULL,
  max_score numeric(10,2) NOT NULL,
  weight_percentage numeric(5,2),
  assessment_date date,
  created_by_staff_id uuid,
  status text DEFAULT 'draft'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.assignment_submissions (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  assignment_id uuid NOT NULL,
  student_id uuid NOT NULL,
  attempt_number integer DEFAULT 1 NOT NULL,
  submission_text text,
  object_path text,
  status text DEFAULT 'submitted'::text NOT NULL,
  submitted_at timestamp with time zone,
  score numeric(8,2),
  feedback text,
  graded_by_staff_id uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  graded_at timestamp with time zone
);

CREATE TABLE IF NOT EXISTS public.assignments (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  class_subject_id uuid NOT NULL,
  teacher_staff_id uuid NOT NULL,
  title text NOT NULL,
  instructions text NOT NULL,
  assignment_type text DEFAULT 'homework'::text NOT NULL,
  max_score numeric(8,2),
  assigned_at timestamp with time zone DEFAULT now() NOT NULL,
  due_at timestamp with time zone,
  allow_late_submission boolean DEFAULT false NOT NULL,
  max_attempts integer DEFAULT 1 NOT NULL,
  status text DEFAULT 'draft'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.attendance_records (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  attendance_session_id uuid NOT NULL,
  student_id uuid NOT NULL,
  attendance_status text NOT NULL,
  note text,
  marked_by_staff_id uuid,
  marked_at timestamp with time zone DEFAULT now() NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.attendance_sessions (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  class_id uuid NOT NULL,
  class_subject_id uuid,
  session_date date NOT NULL,
  period_label text DEFAULT 'Daily'::text NOT NULL,
  taken_by_staff_id uuid,
  status text DEFAULT 'open'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.class_subjects (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  class_id uuid NOT NULL,
  subject_id uuid NOT NULL,
  teacher_staff_id uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.classes (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  academic_year_id uuid NOT NULL,
  name text NOT NULL,
  grade_level text,
  stream text,
  capacity integer,
  status text DEFAULT 'active'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.counselling_cases (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  student_id uuid NOT NULL,
  assigned_staff_id uuid,
  case_category text NOT NULL,
  priority text DEFAULT 'normal'::text NOT NULL,
  status text DEFAULT 'open'::text NOT NULL,
  restricted_access boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.counselling_notes (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  case_id uuid NOT NULL,
  author_staff_id uuid NOT NULL,
  note_body text NOT NULL,
  sensitivity text DEFAULT 'restricted'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.departments (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  name text NOT NULL,
  code text,
  description text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.discipline_cases (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  student_id uuid NOT NULL,
  reported_by_staff_id uuid,
  incident_date timestamp with time zone NOT NULL,
  category text NOT NULL,
  severity text DEFAULT 'low'::text NOT NULL,
  description text NOT NULL,
  action_taken text,
  status text DEFAULT 'open'::text NOT NULL,
  parent_notified_at timestamp with time zone,
  resolved_by_staff_id uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.district_memberships (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  district_id uuid NOT NULL,
  user_id uuid NOT NULL,
  role_code text NOT NULL,
  status text DEFAULT 'active'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.districts (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  name text NOT NULL,
  code text NOT NULL,
  region_name text,
  country_code text DEFAULT 'TZ'::text NOT NULL,
  status text DEFAULT 'active'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.documents (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  student_id uuid,
  title text NOT NULL,
  document_type text NOT NULL,
  access_scope text DEFAULT 'school'::text NOT NULL,
  object_path text,
  uploaded_by uuid,
  created_by_membership_id uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.fee_categories (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  code text NOT NULL,
  name text NOT NULL,
  description text,
  is_active boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.fee_plan_items (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  fee_plan_id uuid NOT NULL,
  fee_category_id uuid NOT NULL,
  description text NOT NULL,
  amount numeric(12,2) NOT NULL,
  due_on date,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.fee_plans (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  academic_year_id uuid NOT NULL,
  class_id uuid,
  code text NOT NULL,
  name text NOT NULL,
  currency_code text DEFAULT 'TZS'::text NOT NULL,
  is_active boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.guardians (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  user_id uuid,
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text,
  phone text NOT NULL,
  address text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.invoice_items (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  fee_category_id uuid,
  description text NOT NULL,
  quantity numeric(10,2) DEFAULT 1 NOT NULL,
  unit_price numeric(12,2) NOT NULL,
  line_total numeric(14,2) GENERATED ALWAYS AS (round((quantity * unit_price), 2)) STORED,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.invoices (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  student_id uuid NOT NULL,
  academic_year_id uuid NOT NULL,
  fee_plan_id uuid,
  invoice_number text NOT NULL,
  currency_code text DEFAULT 'TZS'::text NOT NULL,
  status text DEFAULT 'draft'::text NOT NULL,
  issued_on date,
  due_on date,
  notes text,
  issued_by_staff_id uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.learning_resources (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  class_subject_id uuid,
  title text NOT NULL,
  description text,
  resource_type text NOT NULL,
  object_path text,
  external_url text,
  access_scope text DEFAULT 'class'::text NOT NULL,
  created_by_staff_id uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.lesson_plans (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  class_subject_id uuid NOT NULL,
  teacher_staff_id uuid NOT NULL,
  title text NOT NULL,
  learning_objectives text[] DEFAULT '{}'::text[] NOT NULL,
  lesson_content text,
  planned_for date NOT NULL,
  status text DEFAULT 'draft'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.library_books (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  accession_number text NOT NULL,
  title text NOT NULL,
  authors text[] DEFAULT '{}'::text[] NOT NULL,
  category text,
  total_copies integer DEFAULT 1 NOT NULL,
  status text DEFAULT 'available'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.library_loans (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  book_id uuid NOT NULL,
  student_id uuid,
  staff_member_id uuid,
  due_at timestamp with time zone NOT NULL,
  returned_at timestamp with time zone,
  status text DEFAULT 'issued'::text NOT NULL,
  fine_amount numeric(12,2) DEFAULT 0 NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.meal_attendance (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  student_id uuid NOT NULL,
  meal_date date NOT NULL,
  meal_type text NOT NULL,
  attended boolean DEFAULT true NOT NULL,
  recorded_by_staff_id uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.meal_menus (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  menu_date date NOT NULL,
  meal_type text NOT NULL,
  menu_items jsonb DEFAULT '[]'::jsonb NOT NULL,
  published boolean DEFAULT false NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.membership_roles (
  membership_id uuid NOT NULL,
  school_id uuid NOT NULL,
  role_code text NOT NULL,
  assigned_by uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.notifications (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid,
  user_id uuid NOT NULL,
  title text NOT NULL,
  body text NOT NULL,
  category text DEFAULT 'general'::text NOT NULL,
  related_url text,
  read_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.payment_allocations (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  payment_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  allocated_amount numeric(12,2) NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.payment_gateway_events (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid,
  provider text NOT NULL,
  provider_event_id text NOT NULL,
  provider_reference text,
  event_type text NOT NULL,
  processing_status text DEFAULT 'received'::text NOT NULL,
  signature_verified boolean DEFAULT false NOT NULL,
  payload_hash text,
  safe_metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
  error_message text,
  received_at timestamp with time zone DEFAULT now() NOT NULL,
  processed_at timestamp with time zone
);

CREATE TABLE IF NOT EXISTS public.payments (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  student_id uuid NOT NULL,
  payment_number text NOT NULL,
  amount numeric(12,2) NOT NULL,
  currency_code text DEFAULT 'TZS'::text NOT NULL,
  payment_method text NOT NULL,
  payment_provider text DEFAULT 'manual'::text NOT NULL,
  provider_reference text,
  payment_status text DEFAULT 'pending'::text NOT NULL,
  paid_at timestamp with time zone,
  recorded_by_staff_id uuid,
  notes text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.permissions (
  code text NOT NULL,
  description text DEFAULT ''::text NOT NULL
);

CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid NOT NULL,
  full_name text,
  phone text,
  avatar_path text,
  preferred_language text DEFAULT 'sw'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.role_permissions (
  role_code text NOT NULL,
  permission_code text NOT NULL
);

CREATE TABLE IF NOT EXISTS public.roles (
  code text NOT NULL,
  name text NOT NULL,
  description text DEFAULT ''::text NOT NULL,
  is_system boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.school_assets (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  asset_code text NOT NULL,
  asset_name text NOT NULL,
  category text NOT NULL,
  condition_status text DEFAULT 'good'::text NOT NULL,
  assigned_to_staff_id uuid,
  location text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.school_audit_events (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  school_id uuid NOT NULL,
  actor_user_id uuid,
  event_type text NOT NULL,
  entity_type text NOT NULL,
  entity_id text,
  event_payload jsonb DEFAULT '{}'::jsonb NOT NULL,
  occurred_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.school_invitations (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  email text NOT NULL,
  role_code text NOT NULL,
  token_hash text,
  status text DEFAULT 'pending'::text NOT NULL,
  invited_by uuid,
  expires_at timestamp with time zone DEFAULT (now() + '7 days'::interval) NOT NULL,
  accepted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.school_memberships (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  user_id uuid NOT NULL,
  status text DEFAULT 'active'::text NOT NULL,
  joined_at timestamp with time zone DEFAULT now() NOT NULL,
  invited_by uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.school_message_logs (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  channel text NOT NULL,
  recipient text NOT NULL,
  template_code text,
  provider text,
  provider_reference text,
  message_status text DEFAULT 'queued'::text NOT NULL,
  error_code text,
  sent_at timestamp with time zone,
  delivered_at timestamp with time zone,
  metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.school_settings (
  school_id uuid NOT NULL,
  settings jsonb DEFAULT '{}'::jsonb NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.school_subscriptions (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  plan_code text NOT NULL,
  status text DEFAULT 'trial'::text NOT NULL,
  billing_cycle text DEFAULT 'monthly'::text NOT NULL,
  currency_code text DEFAULT 'TZS'::text NOT NULL,
  amount numeric(14,2) DEFAULT 0 NOT NULL,
  starts_at timestamp with time zone DEFAULT now() NOT NULL,
  ends_at timestamp with time zone,
  next_billing_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.schools (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  district_id uuid,
  name text NOT NULL,
  slug text NOT NULL,
  registration_number text,
  school_type text DEFAULT 'other'::text NOT NULL,
  country_code text DEFAULT 'TZ'::text NOT NULL,
  currency_code text DEFAULT 'TZS'::text NOT NULL,
  timezone text DEFAULT 'Africa/Dar_es_Salaam'::text NOT NULL,
  status text DEFAULT 'active'::text NOT NULL,
  created_by uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  deleted_at timestamp with time zone
);

CREATE TABLE IF NOT EXISTS public.selcom_checkout_intents (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  student_id uuid NOT NULL,
  payer_user_id uuid NOT NULL,
  client_idempotency_key uuid NOT NULL,
  order_id text NOT NULL,
  merchant_trans_id text NOT NULL,
  amount numeric(14,2) NOT NULL,
  currency_code text DEFAULT 'TZS'::text NOT NULL,
  status text DEFAULT 'creating'::text NOT NULL,
  payer_msisdn_last4 text,
  selcom_reference text,
  selcom_transid text,
  selcom_channel text,
  payment_id uuid,
  safe_metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
  error_code text,
  error_message text,
  expires_at timestamp with time zone DEFAULT (now() + '00:30:00'::interval) NOT NULL,
  processed_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.snippe_checkout_intents (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  student_id uuid NOT NULL,
  payer_user_id uuid NOT NULL,
  client_idempotency_key uuid NOT NULL,
  order_id text NOT NULL,
  amount numeric(14,2) NOT NULL,
  currency_code text DEFAULT 'TZS'::text NOT NULL,
  status text DEFAULT 'creating'::text NOT NULL,
  payer_msisdn_last4 text,
  snippe_reference text,
  snippe_external_reference text,
  snippe_channel text,
  payment_id uuid,
  safe_metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
  error_code text,
  error_message text,
  expires_at timestamp with time zone DEFAULT (now() + '04:00:00'::interval) NOT NULL,
  processed_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.sports_events (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  team_id uuid,
  event_name text NOT NULL,
  opponent text,
  venue text,
  starts_at timestamp with time zone NOT NULL,
  ends_at timestamp with time zone,
  result_summary text,
  status text DEFAULT 'scheduled'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.sports_team_members (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  team_id uuid NOT NULL,
  student_id uuid NOT NULL,
  joined_on date DEFAULT CURRENT_DATE NOT NULL,
  status text DEFAULT 'active'::text NOT NULL
);

CREATE TABLE IF NOT EXISTS public.sports_teams (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  name text NOT NULL,
  sport text NOT NULL,
  coach_staff_id uuid,
  season_label text,
  status text DEFAULT 'active'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.staff_attendance (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  staff_member_id uuid NOT NULL,
  attendance_date date NOT NULL,
  check_in timestamp with time zone,
  check_out timestamp with time zone,
  status text DEFAULT 'present'::text NOT NULL,
  recorded_by uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.staff_leave_requests (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  staff_member_id uuid NOT NULL,
  leave_type text NOT NULL,
  starts_on date NOT NULL,
  ends_on date NOT NULL,
  status text DEFAULT 'pending'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.staff_members (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  user_id uuid,
  department_id uuid,
  employee_number text NOT NULL,
  first_name text NOT NULL,
  middle_name text,
  last_name text NOT NULL,
  email text,
  phone text,
  job_title text,
  employment_status text DEFAULT 'active'::text NOT NULL,
  hired_on date,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.student_enrollments (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  student_id uuid NOT NULL,
  class_id uuid NOT NULL,
  academic_year_id uuid NOT NULL,
  enrolled_on date DEFAULT CURRENT_DATE NOT NULL,
  exited_on date,
  status text DEFAULT 'active'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.student_guardians (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  student_id uuid NOT NULL,
  guardian_id uuid NOT NULL,
  relationship text NOT NULL,
  is_primary boolean DEFAULT false NOT NULL,
  receives_academic_updates boolean DEFAULT true NOT NULL,
  receives_finance_updates boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.student_health_records (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  student_id uuid NOT NULL,
  record_type text NOT NULL,
  recorded_at timestamp with time zone DEFAULT now() NOT NULL,
  summary text NOT NULL,
  restricted_access boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.student_transport_assignments (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  student_id uuid NOT NULL,
  route_id uuid NOT NULL,
  stop_id uuid,
  effective_from date DEFAULT CURRENT_DATE NOT NULL,
  effective_to date,
  status text DEFAULT 'active'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.student_workspace_projects (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  student_id uuid NOT NULL,
  title text NOT NULL,
  description text,
  workspace_type text DEFAULT 'general'::text NOT NULL,
  status text DEFAULT 'active'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.students (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  user_id uuid,
  admission_number text NOT NULL,
  first_name text NOT NULL,
  middle_name text,
  last_name text NOT NULL,
  preferred_name text,
  date_of_birth date,
  admission_date date DEFAULT CURRENT_DATE NOT NULL,
  student_status text DEFAULT 'active'::text NOT NULL,
  notes text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.subjects (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  department_id uuid,
  code text,
  name text NOT NULL,
  description text,
  status text DEFAULT 'active'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.subscription_invoices (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  subscription_id uuid NOT NULL,
  invoice_number text NOT NULL,
  amount_due numeric(14,2) NOT NULL,
  amount_paid numeric(14,2) DEFAULT 0 NOT NULL,
  currency_code text DEFAULT 'TZS'::text NOT NULL,
  issued_at timestamp with time zone DEFAULT now() NOT NULL,
  due_at timestamp with time zone NOT NULL,
  paid_at timestamp with time zone,
  status text DEFAULT 'issued'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.terms (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  academic_year_id uuid NOT NULL,
  name text NOT NULL,
  starts_on date NOT NULL,
  ends_on date NOT NULL,
  status text DEFAULT 'planned'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.timetable_slots (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  academic_year_id uuid NOT NULL,
  class_id uuid NOT NULL,
  class_subject_id uuid NOT NULL,
  teacher_staff_id uuid,
  weekday smallint NOT NULL,
  starts_at time without time zone NOT NULL,
  ends_at time without time zone NOT NULL,
  room_label text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.transport_routes (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  route_name text NOT NULL,
  vehicle_registration text,
  driver_staff_id uuid,
  capacity integer,
  status text DEFAULT 'active'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.transport_stops (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  route_id uuid NOT NULL,
  stop_name text NOT NULL,
  stop_order integer NOT NULL,
  pickup_time time without time zone,
  dropoff_time time without time zone,
  latitude numeric(10,7),
  longitude numeric(10,7)
);

CREATE TABLE IF NOT EXISTS public.workspace_collaborators (
  school_id uuid NOT NULL,
  project_id uuid NOT NULL,
  user_id uuid NOT NULL,
  access_level text DEFAULT 'viewer'::text NOT NULL,
  invited_by uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.workspace_files (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  school_id uuid NOT NULL,
  project_id uuid NOT NULL,
  file_name text NOT NULL,
  object_path text NOT NULL,
  uploaded_by uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE SEQUENCE IF NOT EXISTS private.audit_logs_id_seq;

CREATE SEQUENCE IF NOT EXISTS public.school_audit_events_id_seq;

ALTER TABLE private.audit_logs ADD CONSTRAINT audit_logs_action_check CHECK (action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text]));

ALTER TABLE private.audit_logs ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);

ALTER TABLE private.school_payment_gateway_settings ADD CONSTRAINT school_payment_gateway_settings_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE private.school_payment_gateway_settings ADD CONSTRAINT school_payment_gateway_settings_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE CASCADE;

ALTER TABLE private.school_payment_gateway_settings ADD CONSTRAINT school_payment_gateway_settings_pkey PRIMARY KEY (school_id);

ALTER TABLE private.school_payment_gateway_settings ADD CONSTRAINT school_payment_gateway_settings_active_provider_check CHECK (active_provider = ANY (ARRAY['selcom'::text, 'snippe'::text]));

ALTER TABLE public.academic_years ADD CONSTRAINT academic_years_status_check CHECK (status = ANY (ARRAY['planned'::text, 'active'::text, 'completed'::text, 'archived'::text]));

ALTER TABLE public.academic_years ADD CONSTRAINT academic_years_check CHECK (ends_on > starts_on);

ALTER TABLE public.academic_years ADD CONSTRAINT academic_years_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.academic_years ADD CONSTRAINT academic_years_school_id_name_key UNIQUE (school_id, name);

ALTER TABLE public.academic_years ADD CONSTRAINT academic_years_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.academic_years ADD CONSTRAINT academic_years_pkey PRIMARY KEY (id);

ALTER TABLE public.admission_applications ADD CONSTRAINT admission_applications_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.admission_applications ADD CONSTRAINT admission_applications_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.admission_applications ADD CONSTRAINT admission_applications_pkey PRIMARY KEY (id);

ALTER TABLE public.admission_applications ADD CONSTRAINT admission_applications_school_id_academic_year_id_fkey FOREIGN KEY (school_id, academic_year_id) REFERENCES academic_years(school_id, id);

ALTER TABLE public.admission_applications ADD CONSTRAINT admission_applications_status_check CHECK (status = ANY (ARRAY['draft'::text, 'submitted'::text, 'under_review'::text, 'assessment'::text, 'accepted'::text, 'waitlisted'::text, 'rejected'::text, 'withdrawn'::text, 'enrolled'::text]));

ALTER TABLE public.admission_applications ADD CONSTRAINT admission_applications_school_id_application_number_key UNIQUE (school_id, application_number);

ALTER TABLE public.admission_applications ADD CONSTRAINT admission_applications_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES auth.users(id);

ALTER TABLE public.admission_documents ADD CONSTRAINT admission_documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES auth.users(id);

ALTER TABLE public.admission_documents ADD CONSTRAINT admission_documents_verification_status_check CHECK (verification_status = ANY (ARRAY['pending'::text, 'verified'::text, 'rejected'::text]));

ALTER TABLE public.admission_documents ADD CONSTRAINT admission_documents_pkey PRIMARY KEY (id);

ALTER TABLE public.admission_documents ADD CONSTRAINT admission_documents_school_id_object_path_key UNIQUE (school_id, object_path);

ALTER TABLE public.admission_documents ADD CONSTRAINT admission_documents_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.admission_documents ADD CONSTRAINT admission_documents_school_id_application_id_fkey FOREIGN KEY (school_id, application_id) REFERENCES admission_applications(school_id, id) ON DELETE CASCADE;

ALTER TABLE public.ai_assistant_messages ADD CONSTRAINT ai_assistant_messages_sender_role_check CHECK (sender_role = ANY (ARRAY['user'::text, 'assistant'::text, 'system'::text, 'tool'::text]));

ALTER TABLE public.ai_assistant_messages ADD CONSTRAINT ai_assistant_messages_pkey PRIMARY KEY (id);

ALTER TABLE public.ai_assistant_messages ADD CONSTRAINT ai_assistant_messages_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.ai_assistant_messages ADD CONSTRAINT ai_assistant_messages_school_id_session_id_fkey FOREIGN KEY (school_id, session_id) REFERENCES ai_assistant_sessions(school_id, id) ON DELETE CASCADE;

ALTER TABLE public.ai_assistant_sessions ADD CONSTRAINT ai_assistant_sessions_pkey PRIMARY KEY (id);

ALTER TABLE public.ai_assistant_sessions ADD CONSTRAINT ai_assistant_sessions_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.ai_assistant_sessions ADD CONSTRAINT ai_assistant_sessions_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.ai_assistant_sessions ADD CONSTRAINT ai_assistant_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);

ALTER TABLE public.ai_assistant_sessions ADD CONSTRAINT ai_assistant_sessions_context_type_check CHECK (context_type = ANY (ARRAY['general'::text, 'assignment'::text, 'research'::text, 'workspace'::text, 'teacher_support'::text, 'administration'::text]));

ALTER TABLE public.ai_assistant_sessions ADD CONSTRAINT ai_assistant_sessions_status_check CHECK (status = ANY (ARRAY['active'::text, 'archived'::text, 'closed'::text]));

ALTER TABLE public.ai_usage_ledger ADD CONSTRAINT ai_usage_ledger_estimated_cost_check CHECK (estimated_cost >= 0::numeric);

ALTER TABLE public.ai_usage_ledger ADD CONSTRAINT ai_usage_ledger_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);

ALTER TABLE public.ai_usage_ledger ADD CONSTRAINT ai_usage_ledger_output_tokens_check CHECK (output_tokens >= 0);

ALTER TABLE public.ai_usage_ledger ADD CONSTRAINT ai_usage_ledger_input_tokens_check CHECK (input_tokens >= 0);

ALTER TABLE public.ai_usage_ledger ADD CONSTRAINT ai_usage_ledger_school_id_session_id_fkey FOREIGN KEY (school_id, session_id) REFERENCES ai_assistant_sessions(school_id, id);

ALTER TABLE public.ai_usage_ledger ADD CONSTRAINT ai_usage_ledger_pkey PRIMARY KEY (id);

ALTER TABLE public.ai_usage_ledger ADD CONSTRAINT ai_usage_ledger_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.announcements ADD CONSTRAINT announcements_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.announcements ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);

ALTER TABLE public.announcements ADD CONSTRAINT announcements_check CHECK (expires_at IS NULL OR publish_at IS NULL OR expires_at > publish_at);

ALTER TABLE public.announcements ADD CONSTRAINT announcements_audience_check CHECK (audience = ANY (ARRAY['school'::text, 'staff'::text, 'students'::text, 'parents'::text]));

ALTER TABLE public.announcements ADD CONSTRAINT announcements_created_by_membership_id_school_id_fkey FOREIGN KEY (created_by_membership_id, school_id) REFERENCES school_memberships(id, school_id) ON DELETE SET NULL;

ALTER TABLE public.announcements ADD CONSTRAINT announcements_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.assessment_scores ADD CONSTRAINT assessment_scores_pkey PRIMARY KEY (id);

ALTER TABLE public.assessment_scores ADD CONSTRAINT assessment_scores_school_id_entered_by_staff_id_fkey FOREIGN KEY (school_id, entered_by_staff_id) REFERENCES staff_members(school_id, id) ON DELETE SET NULL;

ALTER TABLE public.assessment_scores ADD CONSTRAINT assessment_scores_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.assessment_scores ADD CONSTRAINT assessment_scores_school_id_assessment_id_fkey FOREIGN KEY (school_id, assessment_id) REFERENCES assessments(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.assessment_scores ADD CONSTRAINT assessment_scores_score_check CHECK (score >= 0::numeric);

ALTER TABLE public.assessment_scores ADD CONSTRAINT assessment_scores_school_id_assessment_id_student_id_key UNIQUE (school_id, assessment_id, student_id);

ALTER TABLE public.assessments ADD CONSTRAINT assessments_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.assessments ADD CONSTRAINT assessments_pkey PRIMARY KEY (id);

ALTER TABLE public.assessments ADD CONSTRAINT assessments_status_check CHECK (status = ANY (ARRAY['draft'::text, 'published'::text, 'locked'::text, 'archived'::text]));

ALTER TABLE public.assessments ADD CONSTRAINT assessments_weight_percentage_check CHECK (weight_percentage IS NULL OR weight_percentage >= 0::numeric AND weight_percentage <= 100::numeric);

ALTER TABLE public.assessments ADD CONSTRAINT assessments_max_score_check CHECK (max_score > 0::numeric);

ALTER TABLE public.assessments ADD CONSTRAINT assessments_assessment_type_check CHECK (assessment_type = ANY (ARRAY['test'::text, 'quiz'::text, 'assignment'::text, 'midterm'::text, 'final'::text, 'practical'::text, 'project'::text, 'other'::text]));

ALTER TABLE public.assessments ADD CONSTRAINT assessments_school_id_created_by_staff_id_fkey FOREIGN KEY (school_id, created_by_staff_id) REFERENCES staff_members(school_id, id) ON DELETE SET NULL;

ALTER TABLE public.assessments ADD CONSTRAINT assessments_school_id_class_subject_id_fkey FOREIGN KEY (school_id, class_subject_id) REFERENCES class_subjects(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.assignment_submissions ADD CONSTRAINT assignment_submissions_school_id_graded_by_staff_id_fkey FOREIGN KEY (school_id, graded_by_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.assignment_submissions ADD CONSTRAINT assignment_submissions_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id);

ALTER TABLE public.assignment_submissions ADD CONSTRAINT assignment_submissions_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.assignment_submissions ADD CONSTRAINT assignment_submissions_school_id_assignment_id_student_id_a_key UNIQUE (school_id, assignment_id, student_id, attempt_number);

ALTER TABLE public.assignment_submissions ADD CONSTRAINT assignment_submissions_school_id_assignment_id_fkey FOREIGN KEY (school_id, assignment_id) REFERENCES assignments(school_id, id) ON DELETE CASCADE;

ALTER TABLE public.assignment_submissions ADD CONSTRAINT assignment_submissions_pkey PRIMARY KEY (id);

ALTER TABLE public.assignment_submissions ADD CONSTRAINT assignment_submissions_check CHECK (submission_text IS NOT NULL OR object_path IS NOT NULL);

ALTER TABLE public.assignment_submissions ADD CONSTRAINT assignment_submissions_score_check CHECK (score >= 0::numeric);

ALTER TABLE public.assignment_submissions ADD CONSTRAINT assignment_submissions_status_check CHECK (status = ANY (ARRAY['draft'::text, 'submitted'::text, 'late'::text, 'returned'::text, 'graded'::text, 'resubmission_requested'::text]));

ALTER TABLE public.assignment_submissions ADD CONSTRAINT assignment_submissions_attempt_number_check CHECK (attempt_number >= 1 AND attempt_number <= 20);

ALTER TABLE public.assignments ADD CONSTRAINT assignments_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.assignments ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);

ALTER TABLE public.assignments ADD CONSTRAINT assignments_check CHECK (due_at IS NULL OR due_at > assigned_at);

ALTER TABLE public.assignments ADD CONSTRAINT assignments_assignment_type_check CHECK (assignment_type = ANY (ARRAY['homework'::text, 'project'::text, 'essay'::text, 'practical'::text, 'quiz'::text, 'research'::text, 'other'::text]));

ALTER TABLE public.assignments ADD CONSTRAINT assignments_max_score_check CHECK (max_score > 0::numeric);

ALTER TABLE public.assignments ADD CONSTRAINT assignments_max_attempts_check CHECK (max_attempts >= 1 AND max_attempts <= 20);

ALTER TABLE public.assignments ADD CONSTRAINT assignments_status_check CHECK (status = ANY (ARRAY['draft'::text, 'published'::text, 'closed'::text, 'archived'::text]));

ALTER TABLE public.assignments ADD CONSTRAINT assignments_school_id_teacher_staff_id_fkey FOREIGN KEY (school_id, teacher_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.assignments ADD CONSTRAINT assignments_school_id_class_subject_id_fkey FOREIGN KEY (school_id, class_subject_id) REFERENCES class_subjects(school_id, id);

ALTER TABLE public.assignments ADD CONSTRAINT assignments_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_school_id_attendance_session_id_fkey FOREIGN KEY (school_id, attendance_session_id) REFERENCES attendance_sessions(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_school_id_marked_by_staff_id_fkey FOREIGN KEY (school_id, marked_by_staff_id) REFERENCES staff_members(school_id, id) ON DELETE SET NULL;

ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_school_id_attendance_session_id_student__key UNIQUE (school_id, attendance_session_id, student_id);

ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_pkey PRIMARY KEY (id);

ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_attendance_status_check CHECK (attendance_status = ANY (ARRAY['present'::text, 'absent'::text, 'late'::text, 'excused'::text, 'sick'::text]));

ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.attendance_sessions ADD CONSTRAINT attendance_sessions_school_id_class_subject_id_fkey FOREIGN KEY (school_id, class_subject_id) REFERENCES class_subjects(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.attendance_sessions ADD CONSTRAINT attendance_sessions_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.attendance_sessions ADD CONSTRAINT attendance_sessions_pkey PRIMARY KEY (id);

ALTER TABLE public.attendance_sessions ADD CONSTRAINT attendance_sessions_status_check CHECK (status = ANY (ARRAY['open'::text, 'submitted'::text, 'locked'::text, 'cancelled'::text]));

ALTER TABLE public.attendance_sessions ADD CONSTRAINT attendance_sessions_school_id_class_id_fkey FOREIGN KEY (school_id, class_id) REFERENCES classes(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.attendance_sessions ADD CONSTRAINT attendance_sessions_school_id_taken_by_staff_id_fkey FOREIGN KEY (school_id, taken_by_staff_id) REFERENCES staff_members(school_id, id) ON DELETE SET NULL;

ALTER TABLE public.class_subjects ADD CONSTRAINT class_subjects_school_id_subject_id_fkey FOREIGN KEY (school_id, subject_id) REFERENCES subjects(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.class_subjects ADD CONSTRAINT class_subjects_school_id_class_id_subject_id_key UNIQUE (school_id, class_id, subject_id);

ALTER TABLE public.class_subjects ADD CONSTRAINT class_subjects_school_id_class_id_fkey FOREIGN KEY (school_id, class_id) REFERENCES classes(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.class_subjects ADD CONSTRAINT class_subjects_pkey PRIMARY KEY (id);

ALTER TABLE public.class_subjects ADD CONSTRAINT class_subjects_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.class_subjects ADD CONSTRAINT class_subjects_school_id_teacher_staff_id_fkey FOREIGN KEY (school_id, teacher_staff_id) REFERENCES staff_members(school_id, id) ON DELETE SET NULL;

ALTER TABLE public.classes ADD CONSTRAINT classes_capacity_check CHECK (capacity IS NULL OR capacity > 0);

ALTER TABLE public.classes ADD CONSTRAINT classes_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.classes ADD CONSTRAINT classes_status_check CHECK (status = ANY (ARRAY['active'::text, 'inactive'::text, 'archived'::text]));

ALTER TABLE public.classes ADD CONSTRAINT classes_pkey PRIMARY KEY (id);

ALTER TABLE public.classes ADD CONSTRAINT classes_school_id_academic_year_id_fkey FOREIGN KEY (school_id, academic_year_id) REFERENCES academic_years(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.classes ADD CONSTRAINT classes_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.counselling_cases ADD CONSTRAINT counselling_cases_status_check CHECK (status = ANY (ARRAY['open'::text, 'in_progress'::text, 'referred'::text, 'closed'::text]));

ALTER TABLE public.counselling_cases ADD CONSTRAINT counselling_cases_pkey PRIMARY KEY (id);

ALTER TABLE public.counselling_cases ADD CONSTRAINT counselling_cases_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.counselling_cases ADD CONSTRAINT counselling_cases_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.counselling_cases ADD CONSTRAINT counselling_cases_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id);

ALTER TABLE public.counselling_cases ADD CONSTRAINT counselling_cases_school_id_assigned_staff_id_fkey FOREIGN KEY (school_id, assigned_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.counselling_cases ADD CONSTRAINT counselling_cases_priority_check CHECK (priority = ANY (ARRAY['low'::text, 'normal'::text, 'high'::text, 'urgent'::text]));

ALTER TABLE public.counselling_notes ADD CONSTRAINT counselling_notes_school_id_author_staff_id_fkey FOREIGN KEY (school_id, author_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.counselling_notes ADD CONSTRAINT counselling_notes_sensitivity_check CHECK (sensitivity = ANY (ARRAY['restricted'::text, 'confidential'::text]));

ALTER TABLE public.counselling_notes ADD CONSTRAINT counselling_notes_pkey PRIMARY KEY (id);

ALTER TABLE public.counselling_notes ADD CONSTRAINT counselling_notes_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.counselling_notes ADD CONSTRAINT counselling_notes_school_id_case_id_fkey FOREIGN KEY (school_id, case_id) REFERENCES counselling_cases(school_id, id) ON DELETE CASCADE;

ALTER TABLE public.departments ADD CONSTRAINT departments_school_id_name_key UNIQUE (school_id, name);

ALTER TABLE public.departments ADD CONSTRAINT departments_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.departments ADD CONSTRAINT departments_school_id_code_key UNIQUE (school_id, code);

ALTER TABLE public.departments ADD CONSTRAINT departments_pkey PRIMARY KEY (id);

ALTER TABLE public.departments ADD CONSTRAINT departments_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.discipline_cases ADD CONSTRAINT discipline_cases_pkey PRIMARY KEY (id);

ALTER TABLE public.discipline_cases ADD CONSTRAINT discipline_cases_school_id_resolved_by_staff_id_fkey FOREIGN KEY (school_id, resolved_by_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.discipline_cases ADD CONSTRAINT discipline_cases_school_id_reported_by_staff_id_fkey FOREIGN KEY (school_id, reported_by_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.discipline_cases ADD CONSTRAINT discipline_cases_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id);

ALTER TABLE public.discipline_cases ADD CONSTRAINT discipline_cases_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.discipline_cases ADD CONSTRAINT discipline_cases_status_check CHECK (status = ANY (ARRAY['open'::text, 'investigating'::text, 'resolved'::text, 'referred'::text, 'closed'::text]));

ALTER TABLE public.discipline_cases ADD CONSTRAINT discipline_cases_severity_check CHECK (severity = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'critical'::text]));

ALTER TABLE public.district_memberships ADD CONSTRAINT district_memberships_pkey PRIMARY KEY (id);

ALTER TABLE public.district_memberships ADD CONSTRAINT district_memberships_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.district_memberships ADD CONSTRAINT district_memberships_district_id_fkey FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE RESTRICT;

ALTER TABLE public.district_memberships ADD CONSTRAINT district_memberships_district_id_user_id_role_code_key UNIQUE (district_id, user_id, role_code);

ALTER TABLE public.district_memberships ADD CONSTRAINT district_memberships_status_check CHECK (status = ANY (ARRAY['invited'::text, 'active'::text, 'suspended'::text, 'left'::text]));

ALTER TABLE public.district_memberships ADD CONSTRAINT district_memberships_role_code_fkey FOREIGN KEY (role_code) REFERENCES roles(code) ON DELETE RESTRICT;

ALTER TABLE public.districts ADD CONSTRAINT districts_pkey PRIMARY KEY (id);

ALTER TABLE public.districts ADD CONSTRAINT districts_code_key UNIQUE (code);

ALTER TABLE public.districts ADD CONSTRAINT districts_status_check CHECK (status = ANY (ARRAY['active'::text, 'suspended'::text, 'archived'::text]));

ALTER TABLE public.documents ADD CONSTRAINT documents_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.documents ADD CONSTRAINT documents_access_scope_check CHECK (access_scope = ANY (ARRAY['school'::text, 'academic'::text, 'finance'::text, 'uploader'::text, 'student_guardian'::text]));

ALTER TABLE public.documents ADD CONSTRAINT documents_pkey PRIMARY KEY (id);

ALTER TABLE public.documents ADD CONSTRAINT documents_object_path_key UNIQUE (object_path);

ALTER TABLE public.documents ADD CONSTRAINT documents_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.documents ADD CONSTRAINT documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public.documents ADD CONSTRAINT documents_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.documents ADD CONSTRAINT documents_created_by_membership_id_school_id_fkey FOREIGN KEY (created_by_membership_id, school_id) REFERENCES school_memberships(id, school_id) ON DELETE SET NULL;

ALTER TABLE public.fee_categories ADD CONSTRAINT fee_categories_school_id_code_key UNIQUE (school_id, code);

ALTER TABLE public.fee_categories ADD CONSTRAINT fee_categories_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.fee_categories ADD CONSTRAINT fee_categories_pkey PRIMARY KEY (id);

ALTER TABLE public.fee_categories ADD CONSTRAINT fee_categories_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.fee_plan_items ADD CONSTRAINT fee_plan_items_school_id_fee_plan_id_fkey FOREIGN KEY (school_id, fee_plan_id) REFERENCES fee_plans(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.fee_plan_items ADD CONSTRAINT fee_plan_items_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.fee_plan_items ADD CONSTRAINT fee_plan_items_amount_check CHECK (amount >= 0::numeric);

ALTER TABLE public.fee_plan_items ADD CONSTRAINT fee_plan_items_pkey PRIMARY KEY (id);

ALTER TABLE public.fee_plan_items ADD CONSTRAINT fee_plan_items_school_id_fee_category_id_fkey FOREIGN KEY (school_id, fee_category_id) REFERENCES fee_categories(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.fee_plans ADD CONSTRAINT fee_plans_pkey PRIMARY KEY (id);

ALTER TABLE public.fee_plans ADD CONSTRAINT fee_plans_school_id_class_id_fkey FOREIGN KEY (school_id, class_id) REFERENCES classes(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.fee_plans ADD CONSTRAINT fee_plans_school_id_academic_year_id_fkey FOREIGN KEY (school_id, academic_year_id) REFERENCES academic_years(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.fee_plans ADD CONSTRAINT fee_plans_school_id_code_key UNIQUE (school_id, code);

ALTER TABLE public.fee_plans ADD CONSTRAINT fee_plans_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.guardians ADD CONSTRAINT guardians_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.guardians ADD CONSTRAINT guardians_pkey PRIMARY KEY (id);

ALTER TABLE public.guardians ADD CONSTRAINT guardians_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.guardians ADD CONSTRAINT guardians_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public.invoice_items ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);

ALTER TABLE public.invoice_items ADD CONSTRAINT invoice_items_quantity_check CHECK (quantity > 0::numeric);

ALTER TABLE public.invoice_items ADD CONSTRAINT invoice_items_unit_price_check CHECK (unit_price >= 0::numeric);

ALTER TABLE public.invoice_items ADD CONSTRAINT invoice_items_school_id_invoice_id_fkey FOREIGN KEY (school_id, invoice_id) REFERENCES invoices(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.invoice_items ADD CONSTRAINT invoice_items_school_id_fee_category_id_fkey FOREIGN KEY (school_id, fee_category_id) REFERENCES fee_categories(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.invoices ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);

ALTER TABLE public.invoices ADD CONSTRAINT invoices_status_check CHECK (status = ANY (ARRAY['draft'::text, 'issued'::text, 'partially_paid'::text, 'paid'::text, 'overdue'::text, 'void'::text]));

ALTER TABLE public.invoices ADD CONSTRAINT invoices_school_id_issued_by_staff_id_fkey FOREIGN KEY (school_id, issued_by_staff_id) REFERENCES staff_members(school_id, id) ON DELETE SET NULL;

ALTER TABLE public.invoices ADD CONSTRAINT invoices_school_id_fee_plan_id_fkey FOREIGN KEY (school_id, fee_plan_id) REFERENCES fee_plans(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.invoices ADD CONSTRAINT invoices_school_id_academic_year_id_fkey FOREIGN KEY (school_id, academic_year_id) REFERENCES academic_years(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.invoices ADD CONSTRAINT invoices_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.invoices ADD CONSTRAINT invoices_school_id_invoice_number_key UNIQUE (school_id, invoice_number);

ALTER TABLE public.invoices ADD CONSTRAINT invoices_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.learning_resources ADD CONSTRAINT learning_resources_school_id_created_by_staff_id_fkey FOREIGN KEY (school_id, created_by_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.learning_resources ADD CONSTRAINT learning_resources_scope_requires_class CHECK (access_scope = 'school'::text OR class_subject_id IS NOT NULL);

ALTER TABLE public.learning_resources ADD CONSTRAINT learning_resources_school_id_class_subject_id_fkey FOREIGN KEY (school_id, class_subject_id) REFERENCES class_subjects(school_id, id);

ALTER TABLE public.learning_resources ADD CONSTRAINT learning_resources_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.learning_resources ADD CONSTRAINT learning_resources_pkey PRIMARY KEY (id);

ALTER TABLE public.learning_resources ADD CONSTRAINT learning_resources_resource_type_check CHECK (resource_type = ANY (ARRAY['document'::text, 'video'::text, 'audio'::text, 'link'::text, 'presentation'::text, 'worksheet'::text, 'other'::text]));

ALTER TABLE public.learning_resources ADD CONSTRAINT learning_resources_access_scope_check CHECK (access_scope = ANY (ARRAY['school'::text, 'class'::text, 'teacher_only'::text, 'student'::text]));

ALTER TABLE public.learning_resources ADD CONSTRAINT learning_resources_check CHECK (object_path IS NOT NULL OR external_url IS NOT NULL);

ALTER TABLE public.lesson_plans ADD CONSTRAINT lesson_plans_school_id_class_subject_id_fkey FOREIGN KEY (school_id, class_subject_id) REFERENCES class_subjects(school_id, id);

ALTER TABLE public.lesson_plans ADD CONSTRAINT lesson_plans_status_check CHECK (status = ANY (ARRAY['draft'::text, 'submitted'::text, 'approved'::text, 'completed'::text, 'cancelled'::text]));

ALTER TABLE public.lesson_plans ADD CONSTRAINT lesson_plans_pkey PRIMARY KEY (id);

ALTER TABLE public.lesson_plans ADD CONSTRAINT lesson_plans_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.lesson_plans ADD CONSTRAINT lesson_plans_school_id_teacher_staff_id_fkey FOREIGN KEY (school_id, teacher_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.library_books ADD CONSTRAINT library_books_status_check CHECK (status = ANY (ARRAY['available'::text, 'restricted'::text, 'archived'::text]));

ALTER TABLE public.library_books ADD CONSTRAINT library_books_pkey PRIMARY KEY (id);

ALTER TABLE public.library_books ADD CONSTRAINT library_books_total_copies_check CHECK (total_copies > 0);

ALTER TABLE public.library_books ADD CONSTRAINT library_books_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.library_books ADD CONSTRAINT library_books_school_id_accession_number_key UNIQUE (school_id, accession_number);

ALTER TABLE public.library_books ADD CONSTRAINT library_books_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.library_loans ADD CONSTRAINT library_loans_school_id_book_id_fkey FOREIGN KEY (school_id, book_id) REFERENCES library_books(school_id, id);

ALTER TABLE public.library_loans ADD CONSTRAINT library_loans_school_id_staff_member_id_fkey FOREIGN KEY (school_id, staff_member_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.library_loans ADD CONSTRAINT library_loans_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id);

ALTER TABLE public.library_loans ADD CONSTRAINT library_loans_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.library_loans ADD CONSTRAINT library_loans_pkey PRIMARY KEY (id);

ALTER TABLE public.library_loans ADD CONSTRAINT library_loans_check CHECK (num_nonnulls(student_id, staff_member_id) = 1);

ALTER TABLE public.library_loans ADD CONSTRAINT library_loans_fine_amount_check CHECK (fine_amount >= 0::numeric);

ALTER TABLE public.library_loans ADD CONSTRAINT library_loans_status_check CHECK (status = ANY (ARRAY['issued'::text, 'returned'::text, 'overdue'::text, 'lost'::text]));

ALTER TABLE public.meal_attendance ADD CONSTRAINT meal_attendance_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.meal_attendance ADD CONSTRAINT meal_attendance_meal_type_check CHECK (meal_type = ANY (ARRAY['breakfast'::text, 'lunch'::text, 'dinner'::text, 'snack'::text]));

ALTER TABLE public.meal_attendance ADD CONSTRAINT meal_attendance_school_id_recorded_by_staff_id_fkey FOREIGN KEY (school_id, recorded_by_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.meal_attendance ADD CONSTRAINT meal_attendance_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id);

ALTER TABLE public.meal_attendance ADD CONSTRAINT meal_attendance_school_id_student_id_meal_date_meal_type_key UNIQUE (school_id, student_id, meal_date, meal_type);

ALTER TABLE public.meal_attendance ADD CONSTRAINT meal_attendance_pkey PRIMARY KEY (id);

ALTER TABLE public.meal_menus ADD CONSTRAINT meal_menus_pkey PRIMARY KEY (id);

ALTER TABLE public.meal_menus ADD CONSTRAINT meal_menus_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.meal_menus ADD CONSTRAINT meal_menus_meal_type_check CHECK (meal_type = ANY (ARRAY['breakfast'::text, 'lunch'::text, 'dinner'::text, 'snack'::text]));

ALTER TABLE public.meal_menus ADD CONSTRAINT meal_menus_school_id_menu_date_meal_type_key UNIQUE (school_id, menu_date, meal_type);

ALTER TABLE public.meal_menus ADD CONSTRAINT meal_menus_menu_items_check CHECK (jsonb_typeof(menu_items) = 'array'::text);

ALTER TABLE public.membership_roles ADD CONSTRAINT membership_roles_membership_id_school_id_fkey FOREIGN KEY (membership_id, school_id) REFERENCES school_memberships(id, school_id) ON DELETE CASCADE;

ALTER TABLE public.membership_roles ADD CONSTRAINT membership_roles_pkey PRIMARY KEY (membership_id, role_code);

ALTER TABLE public.membership_roles ADD CONSTRAINT membership_roles_role_code_fkey FOREIGN KEY (role_code) REFERENCES roles(code) ON DELETE RESTRICT;

ALTER TABLE public.membership_roles ADD CONSTRAINT membership_roles_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public.notifications ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);

ALTER TABLE public.notifications ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.notifications ADD CONSTRAINT notifications_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.payment_allocations ADD CONSTRAINT payment_allocations_school_id_invoice_id_fkey FOREIGN KEY (school_id, invoice_id) REFERENCES invoices(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.payment_allocations ADD CONSTRAINT payment_allocations_pkey PRIMARY KEY (id);

ALTER TABLE public.payment_allocations ADD CONSTRAINT payment_allocations_school_id_payment_id_invoice_id_key UNIQUE (school_id, payment_id, invoice_id);

ALTER TABLE public.payment_allocations ADD CONSTRAINT payment_allocations_allocated_amount_check CHECK (allocated_amount > 0::numeric);

ALTER TABLE public.payment_allocations ADD CONSTRAINT payment_allocations_school_id_payment_id_fkey FOREIGN KEY (school_id, payment_id) REFERENCES payments(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.payment_gateway_events ADD CONSTRAINT payment_gateway_events_pkey PRIMARY KEY (id);

ALTER TABLE public.payment_gateway_events ADD CONSTRAINT payment_gateway_events_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.payment_gateway_events ADD CONSTRAINT payment_gateway_events_processing_status_check CHECK (processing_status = ANY (ARRAY['received'::text, 'verified'::text, 'processed'::text, 'rejected'::text, 'failed'::text]));

ALTER TABLE public.payment_gateway_events ADD CONSTRAINT payment_gateway_events_provider_provider_event_id_key UNIQUE (provider, provider_event_id);

ALTER TABLE public.payments ADD CONSTRAINT payments_payment_method_check CHECK (payment_method = ANY (ARRAY['cash'::text, 'bank_transfer'::text, 'mobile_money'::text, 'card'::text, 'cheque'::text, 'other'::text]));

ALTER TABLE public.payments ADD CONSTRAINT payments_amount_check CHECK (amount > 0::numeric);

ALTER TABLE public.payments ADD CONSTRAINT payments_payment_status_check CHECK (payment_status = ANY (ARRAY['pending'::text, 'confirmed'::text, 'failed'::text, 'reversed'::text, 'refunded'::text]));

ALTER TABLE public.payments ADD CONSTRAINT payments_pkey PRIMARY KEY (id);

ALTER TABLE public.payments ADD CONSTRAINT payments_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.payments ADD CONSTRAINT payments_school_id_payment_number_key UNIQUE (school_id, payment_number);

ALTER TABLE public.payments ADD CONSTRAINT payments_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.payments ADD CONSTRAINT payments_school_id_recorded_by_staff_id_fkey FOREIGN KEY (school_id, recorded_by_staff_id) REFERENCES staff_members(school_id, id) ON DELETE SET NULL;

ALTER TABLE public.payments ADD CONSTRAINT payments_payment_provider_check CHECK (payment_provider = ANY (ARRAY['manual'::text, 'selcom'::text, 'snippe'::text, 'other'::text]));

ALTER TABLE public.permissions ADD CONSTRAINT permissions_pkey PRIMARY KEY (code);

ALTER TABLE public.profiles ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.profiles ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);

ALTER TABLE public.role_permissions ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_code, permission_code);

ALTER TABLE public.role_permissions ADD CONSTRAINT role_permissions_role_code_fkey FOREIGN KEY (role_code) REFERENCES roles(code) ON DELETE CASCADE;

ALTER TABLE public.role_permissions ADD CONSTRAINT role_permissions_permission_code_fkey FOREIGN KEY (permission_code) REFERENCES permissions(code) ON DELETE CASCADE;

ALTER TABLE public.roles ADD CONSTRAINT roles_pkey PRIMARY KEY (code);

ALTER TABLE public.school_assets ADD CONSTRAINT school_assets_school_id_asset_code_key UNIQUE (school_id, asset_code);

ALTER TABLE public.school_assets ADD CONSTRAINT school_assets_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.school_assets ADD CONSTRAINT school_assets_pkey PRIMARY KEY (id);

ALTER TABLE public.school_assets ADD CONSTRAINT school_assets_school_id_assigned_to_staff_id_fkey FOREIGN KEY (school_id, assigned_to_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.school_assets ADD CONSTRAINT school_assets_condition_status_check CHECK (condition_status = ANY (ARRAY['new'::text, 'good'::text, 'fair'::text, 'poor'::text, 'damaged'::text, 'disposed'::text]));

ALTER TABLE public.school_audit_events ADD CONSTRAINT school_audit_events_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.school_audit_events ADD CONSTRAINT school_audit_events_pkey PRIMARY KEY (id);

ALTER TABLE public.school_audit_events ADD CONSTRAINT school_audit_events_event_payload_check CHECK (jsonb_typeof(event_payload) = 'object'::text);

ALTER TABLE public.school_audit_events ADD CONSTRAINT school_audit_events_actor_user_id_fkey FOREIGN KEY (actor_user_id) REFERENCES auth.users(id);

ALTER TABLE public.school_invitations ADD CONSTRAINT school_invitations_status_check CHECK (status = ANY (ARRAY['pending'::text, 'accepted'::text, 'expired'::text, 'revoked'::text]));

ALTER TABLE public.school_invitations ADD CONSTRAINT school_invitations_pkey PRIMARY KEY (id);

ALTER TABLE public.school_invitations ADD CONSTRAINT school_invitations_token_hash_key UNIQUE (token_hash);

ALTER TABLE public.school_invitations ADD CONSTRAINT school_invitations_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.school_invitations ADD CONSTRAINT school_invitations_role_code_fkey FOREIGN KEY (role_code) REFERENCES roles(code) ON DELETE RESTRICT;

ALTER TABLE public.school_invitations ADD CONSTRAINT school_invitations_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public.school_memberships ADD CONSTRAINT school_memberships_school_id_user_id_key UNIQUE (school_id, user_id);

ALTER TABLE public.school_memberships ADD CONSTRAINT school_memberships_status_check CHECK (status = ANY (ARRAY['invited'::text, 'active'::text, 'suspended'::text, 'left'::text]));

ALTER TABLE public.school_memberships ADD CONSTRAINT school_memberships_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public.school_memberships ADD CONSTRAINT school_memberships_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.school_memberships ADD CONSTRAINT school_memberships_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.school_memberships ADD CONSTRAINT school_memberships_id_school_id_key UNIQUE (id, school_id);

ALTER TABLE public.school_memberships ADD CONSTRAINT school_memberships_pkey PRIMARY KEY (id);

ALTER TABLE public.school_message_logs ADD CONSTRAINT school_message_logs_metadata_check CHECK (jsonb_typeof(metadata) = 'object'::text);

ALTER TABLE public.school_message_logs ADD CONSTRAINT school_message_logs_channel_check CHECK (channel = ANY (ARRAY['sms'::text, 'whatsapp'::text, 'email'::text, 'push'::text, 'in_app'::text]));

ALTER TABLE public.school_message_logs ADD CONSTRAINT school_message_logs_message_status_check CHECK (message_status = ANY (ARRAY['queued'::text, 'sent'::text, 'delivered'::text, 'failed'::text, 'read'::text]));

ALTER TABLE public.school_message_logs ADD CONSTRAINT school_message_logs_pkey PRIMARY KEY (id);

ALTER TABLE public.school_message_logs ADD CONSTRAINT school_message_logs_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.school_settings ADD CONSTRAINT school_settings_settings_check CHECK (jsonb_typeof(settings) = 'object'::text);

ALTER TABLE public.school_settings ADD CONSTRAINT school_settings_pkey PRIMARY KEY (school_id);

ALTER TABLE public.school_settings ADD CONSTRAINT school_settings_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.school_settings ADD CONSTRAINT school_settings_no_credential_keys CHECK (settings::text !~* '"(secret|password|token|api[_-]?key|apikey|client[_-]?secret|private[_-]?key|service[_-]?role)"[[:space:]]*:'::text);

ALTER TABLE public.school_subscriptions ADD CONSTRAINT school_subscriptions_check CHECK (ends_at IS NULL OR ends_at > starts_at);

ALTER TABLE public.school_subscriptions ADD CONSTRAINT school_subscriptions_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.school_subscriptions ADD CONSTRAINT school_subscriptions_amount_check CHECK (amount >= 0::numeric);

ALTER TABLE public.school_subscriptions ADD CONSTRAINT school_subscriptions_billing_cycle_check CHECK (billing_cycle = ANY (ARRAY['monthly'::text, 'quarterly'::text, 'annual'::text]));

ALTER TABLE public.school_subscriptions ADD CONSTRAINT school_subscriptions_status_check CHECK (status = ANY (ARRAY['trial'::text, 'active'::text, 'past_due'::text, 'suspended'::text, 'cancelled'::text, 'expired'::text]));

ALTER TABLE public.school_subscriptions ADD CONSTRAINT school_subscriptions_currency_code_check CHECK (currency_code ~ '^[A-Z]{3}$'::text);

ALTER TABLE public.school_subscriptions ADD CONSTRAINT school_subscriptions_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.school_subscriptions ADD CONSTRAINT school_subscriptions_pkey PRIMARY KEY (id);

ALTER TABLE public.schools ADD CONSTRAINT schools_pkey PRIMARY KEY (id);

ALTER TABLE public.schools ADD CONSTRAINT schools_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public.schools ADD CONSTRAINT schools_district_id_fkey FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE SET NULL;

ALTER TABLE public.schools ADD CONSTRAINT schools_id_district_id_key UNIQUE (id, district_id);

ALTER TABLE public.schools ADD CONSTRAINT schools_slug_check CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'::text);

ALTER TABLE public.schools ADD CONSTRAINT schools_school_type_check CHECK (school_type = ANY (ARRAY['primary'::text, 'secondary'::text, 'combined'::text, 'college'::text, 'other'::text]));

ALTER TABLE public.schools ADD CONSTRAINT schools_status_check CHECK (status = ANY (ARRAY['active'::text, 'suspended'::text, 'archived'::text]));

ALTER TABLE public.schools ADD CONSTRAINT schools_slug_key UNIQUE (slug);

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_pkey PRIMARY KEY (id);

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_payer_msisdn_last4_check CHECK (payer_msisdn_last4 IS NULL OR payer_msisdn_last4 ~ '^[0-9]{4}$'::text);

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_status_check CHECK (status = ANY (ARRAY['creating'::text, 'pending'::text, 'reconciliation_required'::text, 'completed'::text, 'failed'::text, 'cancelled'::text, 'expired'::text]));

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_currency_code_check CHECK (currency_code = 'TZS'::text);

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_amount_check CHECK (amount > 0::numeric AND amount = trunc(amount));

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_school_invoice_fk FOREIGN KEY (school_id, invoice_id) REFERENCES invoices(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_school_student_fk FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_school_payment_fk FOREIGN KEY (school_id, payment_id) REFERENCES payments(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_payer_user_id_fkey FOREIGN KEY (payer_user_id) REFERENCES auth.users(id) ON DELETE RESTRICT;

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_payer_idempotency_key UNIQUE (payer_user_id, client_idempotency_key);

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_transid_key UNIQUE (merchant_trans_id);

ALTER TABLE public.selcom_checkout_intents ADD CONSTRAINT selcom_checkout_intents_order_id_key UNIQUE (order_id);

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_payer_msisdn_last4_check CHECK (payer_msisdn_last4 IS NULL OR payer_msisdn_last4 ~ '^[0-9]{4}$'::text);

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_pkey PRIMARY KEY (id);

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_payer_idempotency_key UNIQUE (payer_user_id, client_idempotency_key);

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_school_payment_fk FOREIGN KEY (school_id, payment_id) REFERENCES payments(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_school_student_fk FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_school_invoice_fk FOREIGN KEY (school_id, invoice_id) REFERENCES invoices(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_payer_user_id_fkey FOREIGN KEY (payer_user_id) REFERENCES auth.users(id) ON DELETE RESTRICT;

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_order_id_key UNIQUE (order_id);

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_reference_key UNIQUE (snippe_reference);

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_amount_check CHECK (amount >= 500::numeric AND amount = trunc(amount));

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_currency_code_check CHECK (currency_code = 'TZS'::text);

ALTER TABLE public.snippe_checkout_intents ADD CONSTRAINT snippe_checkout_intents_status_check CHECK (status = ANY (ARRAY['creating'::text, 'pending'::text, 'active'::text, 'reconciliation_required'::text, 'completed'::text, 'failed'::text, 'voided'::text, 'expired'::text]));

ALTER TABLE public.sports_events ADD CONSTRAINT sports_events_status_check CHECK (status = ANY (ARRAY['scheduled'::text, 'completed'::text, 'cancelled'::text]));

ALTER TABLE public.sports_events ADD CONSTRAINT sports_events_school_id_team_id_fkey FOREIGN KEY (school_id, team_id) REFERENCES sports_teams(school_id, id);

ALTER TABLE public.sports_events ADD CONSTRAINT sports_events_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.sports_events ADD CONSTRAINT sports_events_pkey PRIMARY KEY (id);

ALTER TABLE public.sports_events ADD CONSTRAINT sports_events_check CHECK (ends_at IS NULL OR ends_at > starts_at);

ALTER TABLE public.sports_team_members ADD CONSTRAINT sports_team_members_pkey PRIMARY KEY (id);

ALTER TABLE public.sports_team_members ADD CONSTRAINT sports_team_members_status_check CHECK (status = ANY (ARRAY['active'::text, 'inactive'::text, 'injured'::text, 'suspended'::text]));

ALTER TABLE public.sports_team_members ADD CONSTRAINT sports_team_members_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id);

ALTER TABLE public.sports_team_members ADD CONSTRAINT sports_team_members_school_id_team_id_fkey FOREIGN KEY (school_id, team_id) REFERENCES sports_teams(school_id, id) ON DELETE CASCADE;

ALTER TABLE public.sports_team_members ADD CONSTRAINT sports_team_members_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.sports_team_members ADD CONSTRAINT sports_team_members_school_id_team_id_student_id_key UNIQUE (school_id, team_id, student_id);

ALTER TABLE public.sports_teams ADD CONSTRAINT sports_teams_school_id_name_sport_key UNIQUE (school_id, name, sport);

ALTER TABLE public.sports_teams ADD CONSTRAINT sports_teams_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.sports_teams ADD CONSTRAINT sports_teams_school_id_coach_staff_id_fkey FOREIGN KEY (school_id, coach_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.sports_teams ADD CONSTRAINT sports_teams_pkey PRIMARY KEY (id);

ALTER TABLE public.sports_teams ADD CONSTRAINT sports_teams_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.sports_teams ADD CONSTRAINT sports_teams_status_check CHECK (status = ANY (ARRAY['active'::text, 'inactive'::text, 'archived'::text]));

ALTER TABLE public.staff_attendance ADD CONSTRAINT staff_attendance_school_id_staff_member_id_attendance_date_key UNIQUE (school_id, staff_member_id, attendance_date);

ALTER TABLE public.staff_attendance ADD CONSTRAINT staff_attendance_recorded_by_fkey FOREIGN KEY (recorded_by) REFERENCES auth.users(id);

ALTER TABLE public.staff_attendance ADD CONSTRAINT staff_attendance_school_id_staff_member_id_fkey FOREIGN KEY (school_id, staff_member_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.staff_attendance ADD CONSTRAINT staff_attendance_pkey PRIMARY KEY (id);

ALTER TABLE public.staff_attendance ADD CONSTRAINT staff_attendance_check CHECK (check_out IS NULL OR check_in IS NOT NULL AND check_out > check_in);

ALTER TABLE public.staff_attendance ADD CONSTRAINT staff_attendance_status_check CHECK (status = ANY (ARRAY['present'::text, 'absent'::text, 'late'::text, 'leave'::text, 'half_day'::text]));

ALTER TABLE public.staff_attendance ADD CONSTRAINT staff_attendance_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.staff_leave_requests ADD CONSTRAINT staff_leave_requests_school_id_staff_member_id_fkey FOREIGN KEY (school_id, staff_member_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.staff_leave_requests ADD CONSTRAINT staff_leave_requests_status_check CHECK (status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text, 'cancelled'::text]));

ALTER TABLE public.staff_leave_requests ADD CONSTRAINT staff_leave_requests_check CHECK (ends_on >= starts_on);

ALTER TABLE public.staff_leave_requests ADD CONSTRAINT staff_leave_requests_pkey PRIMARY KEY (id);

ALTER TABLE public.staff_leave_requests ADD CONSTRAINT staff_leave_requests_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.staff_members ADD CONSTRAINT staff_members_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.staff_members ADD CONSTRAINT staff_members_employment_status_check CHECK (employment_status = ANY (ARRAY['active'::text, 'on_leave'::text, 'suspended'::text, 'terminated'::text]));

ALTER TABLE public.staff_members ADD CONSTRAINT staff_members_pkey PRIMARY KEY (id);

ALTER TABLE public.staff_members ADD CONSTRAINT staff_members_school_id_employee_number_key UNIQUE (school_id, employee_number);

ALTER TABLE public.staff_members ADD CONSTRAINT staff_members_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.staff_members ADD CONSTRAINT staff_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public.staff_members ADD CONSTRAINT staff_members_school_id_department_id_fkey FOREIGN KEY (school_id, department_id) REFERENCES departments(school_id, id) ON DELETE SET NULL;

ALTER TABLE public.student_enrollments ADD CONSTRAINT student_enrollments_school_id_academic_year_id_fkey FOREIGN KEY (school_id, academic_year_id) REFERENCES academic_years(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.student_enrollments ADD CONSTRAINT student_enrollments_school_id_class_id_fkey FOREIGN KEY (school_id, class_id) REFERENCES classes(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.student_enrollments ADD CONSTRAINT student_enrollments_check CHECK (exited_on IS NULL OR exited_on >= enrolled_on);

ALTER TABLE public.student_enrollments ADD CONSTRAINT student_enrollments_pkey PRIMARY KEY (id);

ALTER TABLE public.student_enrollments ADD CONSTRAINT student_enrollments_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.student_enrollments ADD CONSTRAINT student_enrollments_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.student_enrollments ADD CONSTRAINT student_enrollments_status_check CHECK (status = ANY (ARRAY['active'::text, 'completed'::text, 'transferred'::text, 'withdrawn'::text]));

ALTER TABLE public.student_guardians ADD CONSTRAINT student_guardians_school_id_student_id_guardian_id_key UNIQUE (school_id, student_id, guardian_id);

ALTER TABLE public.student_guardians ADD CONSTRAINT student_guardians_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.student_guardians ADD CONSTRAINT student_guardians_school_id_guardian_id_fkey FOREIGN KEY (school_id, guardian_id) REFERENCES guardians(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.student_guardians ADD CONSTRAINT student_guardians_pkey PRIMARY KEY (id);

ALTER TABLE public.student_health_records ADD CONSTRAINT student_health_records_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.student_health_records ADD CONSTRAINT student_health_records_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id);

ALTER TABLE public.student_health_records ADD CONSTRAINT student_health_records_record_type_check CHECK (record_type = ANY (ARRAY['visit'::text, 'incident'::text, 'allergy'::text, 'medication'::text, 'immunization'::text, 'other'::text]));

ALTER TABLE public.student_health_records ADD CONSTRAINT student_health_records_pkey PRIMARY KEY (id);

ALTER TABLE public.student_transport_assignments ADD CONSTRAINT student_transport_assignments_school_id_route_id_fkey FOREIGN KEY (school_id, route_id) REFERENCES transport_routes(school_id, id);

ALTER TABLE public.student_transport_assignments ADD CONSTRAINT student_transport_assignments_school_id_stop_id_fkey FOREIGN KEY (school_id, stop_id) REFERENCES transport_stops(school_id, id);

ALTER TABLE public.student_transport_assignments ADD CONSTRAINT student_transport_assignments_pkey PRIMARY KEY (id);

ALTER TABLE public.student_transport_assignments ADD CONSTRAINT student_transport_assignments_check CHECK (effective_to IS NULL OR effective_to >= effective_from);

ALTER TABLE public.student_transport_assignments ADD CONSTRAINT student_transport_assignments_status_check CHECK (status = ANY (ARRAY['active'::text, 'paused'::text, 'ended'::text]));

ALTER TABLE public.student_transport_assignments ADD CONSTRAINT student_transport_assignments_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.student_transport_assignments ADD CONSTRAINT student_transport_assignments_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id);

ALTER TABLE public.student_workspace_projects ADD CONSTRAINT student_workspace_projects_pkey PRIMARY KEY (id);

ALTER TABLE public.student_workspace_projects ADD CONSTRAINT student_workspace_projects_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.student_workspace_projects ADD CONSTRAINT student_workspace_projects_workspace_type_check CHECK (workspace_type = ANY (ARRAY['document'::text, 'spreadsheet'::text, 'presentation'::text, 'design'::text, 'code'::text, 'research'::text, 'general'::text]));

ALTER TABLE public.student_workspace_projects ADD CONSTRAINT student_workspace_projects_school_id_student_id_fkey FOREIGN KEY (school_id, student_id) REFERENCES students(school_id, id) ON DELETE CASCADE;

ALTER TABLE public.student_workspace_projects ADD CONSTRAINT student_workspace_projects_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.student_workspace_projects ADD CONSTRAINT student_workspace_projects_status_check CHECK (status = ANY (ARRAY['active'::text, 'submitted'::text, 'archived'::text]));

ALTER TABLE public.students ADD CONSTRAINT students_pkey PRIMARY KEY (id);

ALTER TABLE public.students ADD CONSTRAINT students_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public.students ADD CONSTRAINT students_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.students ADD CONSTRAINT students_school_id_admission_number_key UNIQUE (school_id, admission_number);

ALTER TABLE public.students ADD CONSTRAINT students_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.students ADD CONSTRAINT students_student_status_check CHECK (student_status = ANY (ARRAY['active'::text, 'inactive'::text, 'transferred'::text, 'graduated'::text, 'withdrawn'::text, 'suspended'::text]));

ALTER TABLE public.subjects ADD CONSTRAINT subjects_school_id_department_id_fkey FOREIGN KEY (school_id, department_id) REFERENCES departments(school_id, id) ON DELETE SET NULL;

ALTER TABLE public.subjects ADD CONSTRAINT subjects_status_check CHECK (status = ANY (ARRAY['active'::text, 'inactive'::text, 'archived'::text]));

ALTER TABLE public.subjects ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);

ALTER TABLE public.subjects ADD CONSTRAINT subjects_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.subjects ADD CONSTRAINT subjects_school_id_code_key UNIQUE (school_id, code);

ALTER TABLE public.subjects ADD CONSTRAINT subjects_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.subscription_invoices ADD CONSTRAINT subscription_invoices_currency_code_check CHECK (currency_code ~ '^[A-Z]{3}$'::text);

ALTER TABLE public.subscription_invoices ADD CONSTRAINT subscription_invoices_amount_due_check CHECK (amount_due >= 0::numeric);

ALTER TABLE public.subscription_invoices ADD CONSTRAINT subscription_invoices_status_check CHECK (status = ANY (ARRAY['draft'::text, 'issued'::text, 'partially_paid'::text, 'paid'::text, 'overdue'::text, 'void'::text]));

ALTER TABLE public.subscription_invoices ADD CONSTRAINT subscription_invoices_pkey PRIMARY KEY (id);

ALTER TABLE public.subscription_invoices ADD CONSTRAINT subscription_invoices_school_id_invoice_number_key UNIQUE (school_id, invoice_number);

ALTER TABLE public.subscription_invoices ADD CONSTRAINT subscription_invoices_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.subscription_invoices ADD CONSTRAINT subscription_invoices_school_id_subscription_id_fkey FOREIGN KEY (school_id, subscription_id) REFERENCES school_subscriptions(school_id, id);

ALTER TABLE public.subscription_invoices ADD CONSTRAINT subscription_invoices_check CHECK (amount_paid >= 0::numeric AND amount_paid <= amount_due);

ALTER TABLE public.terms ADD CONSTRAINT terms_school_id_academic_year_id_name_key UNIQUE (school_id, academic_year_id, name);

ALTER TABLE public.terms ADD CONSTRAINT terms_check CHECK (ends_on > starts_on);

ALTER TABLE public.terms ADD CONSTRAINT terms_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT;

ALTER TABLE public.terms ADD CONSTRAINT terms_school_id_academic_year_id_fkey FOREIGN KEY (school_id, academic_year_id) REFERENCES academic_years(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.terms ADD CONSTRAINT terms_status_check CHECK (status = ANY (ARRAY['planned'::text, 'active'::text, 'completed'::text, 'archived'::text]));

ALTER TABLE public.terms ADD CONSTRAINT terms_pkey PRIMARY KEY (id);

ALTER TABLE public.terms ADD CONSTRAINT terms_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.timetable_slots ADD CONSTRAINT timetable_slots_pkey PRIMARY KEY (id);

ALTER TABLE public.timetable_slots ADD CONSTRAINT timetable_slots_school_id_teacher_staff_id_fkey FOREIGN KEY (school_id, teacher_staff_id) REFERENCES staff_members(school_id, id) ON DELETE SET NULL;

ALTER TABLE public.timetable_slots ADD CONSTRAINT timetable_slots_school_id_class_subject_id_fkey FOREIGN KEY (school_id, class_subject_id) REFERENCES class_subjects(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.timetable_slots ADD CONSTRAINT timetable_slots_school_id_class_id_fkey FOREIGN KEY (school_id, class_id) REFERENCES classes(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.timetable_slots ADD CONSTRAINT timetable_slots_school_id_academic_year_id_fkey FOREIGN KEY (school_id, academic_year_id) REFERENCES academic_years(school_id, id) ON DELETE RESTRICT;

ALTER TABLE public.timetable_slots ADD CONSTRAINT timetable_slots_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.timetable_slots ADD CONSTRAINT timetable_slots_check CHECK (ends_at > starts_at);

ALTER TABLE public.timetable_slots ADD CONSTRAINT timetable_slots_weekday_check CHECK (weekday >= 1 AND weekday <= 7);

ALTER TABLE public.transport_routes ADD CONSTRAINT transport_routes_status_check CHECK (status = ANY (ARRAY['active'::text, 'inactive'::text, 'maintenance'::text]));

ALTER TABLE public.transport_routes ADD CONSTRAINT transport_routes_pkey PRIMARY KEY (id);

ALTER TABLE public.transport_routes ADD CONSTRAINT transport_routes_school_id_driver_staff_id_fkey FOREIGN KEY (school_id, driver_staff_id) REFERENCES staff_members(school_id, id);

ALTER TABLE public.transport_routes ADD CONSTRAINT transport_routes_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.transport_routes ADD CONSTRAINT transport_routes_school_id_route_name_key UNIQUE (school_id, route_name);

ALTER TABLE public.transport_routes ADD CONSTRAINT transport_routes_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.transport_routes ADD CONSTRAINT transport_routes_capacity_check CHECK (capacity > 0);

ALTER TABLE public.transport_stops ADD CONSTRAINT transport_stops_pkey PRIMARY KEY (id);

ALTER TABLE public.transport_stops ADD CONSTRAINT transport_stops_stop_order_check CHECK (stop_order > 0);

ALTER TABLE public.transport_stops ADD CONSTRAINT transport_stops_school_id_id_key UNIQUE (school_id, id);

ALTER TABLE public.transport_stops ADD CONSTRAINT transport_stops_school_id_route_id_stop_order_key UNIQUE (school_id, route_id, stop_order);

ALTER TABLE public.transport_stops ADD CONSTRAINT transport_stops_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.transport_stops ADD CONSTRAINT transport_stops_school_id_route_id_fkey FOREIGN KEY (school_id, route_id) REFERENCES transport_routes(school_id, id) ON DELETE CASCADE;

ALTER TABLE public.workspace_collaborators ADD CONSTRAINT workspace_collaborators_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);

ALTER TABLE public.workspace_collaborators ADD CONSTRAINT workspace_collaborators_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.workspace_collaborators ADD CONSTRAINT workspace_collaborators_pkey PRIMARY KEY (school_id, project_id, user_id);

ALTER TABLE public.workspace_collaborators ADD CONSTRAINT workspace_collaborators_access_level_check CHECK (access_level = ANY (ARRAY['viewer'::text, 'editor'::text, 'owner'::text]));

ALTER TABLE public.workspace_collaborators ADD CONSTRAINT workspace_collaborators_school_id_project_id_fkey FOREIGN KEY (school_id, project_id) REFERENCES student_workspace_projects(school_id, id) ON DELETE CASCADE;

ALTER TABLE public.workspace_collaborators ADD CONSTRAINT workspace_collaborators_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES auth.users(id);

ALTER TABLE public.workspace_files ADD CONSTRAINT workspace_files_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES auth.users(id);

ALTER TABLE public.workspace_files ADD CONSTRAINT workspace_files_school_id_fkey FOREIGN KEY (school_id) REFERENCES schools(id);

ALTER TABLE public.workspace_files ADD CONSTRAINT workspace_files_school_id_project_id_fkey FOREIGN KEY (school_id, project_id) REFERENCES student_workspace_projects(school_id, id) ON DELETE CASCADE;

ALTER TABLE public.workspace_files ADD CONSTRAINT workspace_files_pkey PRIMARY KEY (id);

ALTER TABLE public.workspace_files ADD CONSTRAINT workspace_files_school_id_object_path_key UNIQUE (school_id, object_path);

CREATE INDEX school_payment_gateway_settings_updated_by_idx ON private.school_payment_gateway_settings USING btree (updated_by) WHERE (updated_by IS NOT NULL);

CREATE UNIQUE INDEX academic_years_one_current_per_school ON public.academic_years USING btree (school_id) WHERE (is_current = true);

CREATE INDEX academic_years_school_status_idx ON public.academic_years USING btree (school_id, status);

CREATE INDEX admission_applications_admission_applications_reviewed_by_fkey_ ON public.admission_applications USING btree (reviewed_by);

CREATE INDEX admission_applications_admission_applications_school_id_academi ON public.admission_applications USING btree (school_id, academic_year_id);

CREATE INDEX admission_docs_app_idx ON public.admission_documents USING btree (school_id, application_id);

CREATE INDEX admission_documents_admission_documents_uploaded_by_fkey_idx ON public.admission_documents USING btree (uploaded_by);

CREATE INDEX admission_status_idx ON public.admission_applications USING btree (school_id, status, created_at DESC);

CREATE INDEX ai_assistant_sessions_ai_assistant_sessions_user_id_fkey_idx ON public.ai_assistant_sessions USING btree (user_id);

CREATE INDEX ai_messages_session_idx ON public.ai_assistant_messages USING btree (school_id, session_id, created_at);

CREATE INDEX ai_sessions_user_idx ON public.ai_assistant_sessions USING btree (school_id, user_id, created_at DESC);

CREATE INDEX ai_usage_ledger_ai_usage_ledger_school_id_session_id_fkey_idx ON public.ai_usage_ledger USING btree (school_id, session_id);

CREATE INDEX ai_usage_ledger_ai_usage_ledger_user_id_fkey_idx ON public.ai_usage_ledger USING btree (user_id);

CREATE INDEX ai_usage_user_idx ON public.ai_usage_ledger USING btree (school_id, user_id, created_at DESC);

CREATE INDEX announcements_announcements_created_by_membership_id_school_id_ ON public.announcements USING btree (created_by_membership_id, school_id);

CREATE INDEX announcements_publish_idx ON public.announcements USING btree (school_id, publish_at DESC);

CREATE INDEX assessment_scores_assessment_scores_school_id_entered_by_staff_ ON public.assessment_scores USING btree (school_id, entered_by_staff_id);

CREATE INDEX assessment_scores_student_idx ON public.assessment_scores USING btree (school_id, student_id);

CREATE INDEX assessments_assessments_school_id_created_by_staff_id_fkey_idx ON public.assessments USING btree (school_id, created_by_staff_id);

CREATE INDEX assessments_class_subject_date_idx ON public.assessments USING btree (school_id, class_subject_id, assessment_date);

CREATE INDEX assignment_submissions_assignment_submissions_school_id_graded_ ON public.assignment_submissions USING btree (school_id, graded_by_staff_id);

CREATE INDEX assignment_submissions_student_idx ON public.assignment_submissions USING btree (school_id, student_id, submitted_at DESC);

CREATE INDEX assignments_assignments_school_id_class_subject_id_fkey_idx ON public.assignments USING btree (school_id, class_subject_id);

CREATE INDEX assignments_assignments_school_id_teacher_staff_id_fkey_idx ON public.assignments USING btree (school_id, teacher_staff_id);

CREATE INDEX attendance_records_attendance_records_school_id_marked_by_staff ON public.attendance_records USING btree (school_id, marked_by_staff_id);

CREATE INDEX attendance_records_student_idx ON public.attendance_records USING btree (school_id, student_id);

CREATE INDEX attendance_sessions_attendance_sessions_school_id_class_subject ON public.attendance_sessions USING btree (school_id, class_subject_id);

CREATE INDEX attendance_sessions_attendance_sessions_school_id_taken_by_staf ON public.attendance_sessions USING btree (school_id, taken_by_staff_id);

CREATE INDEX attendance_sessions_class_date_idx ON public.attendance_sessions USING btree (school_id, class_id, session_date DESC);

CREATE UNIQUE INDEX attendance_sessions_unique_period ON public.attendance_sessions USING btree (school_id, class_id, session_date, period_label, COALESCE(class_subject_id, '00000000-0000-0000-0000-000000000000'::uuid));

CREATE INDEX class_subjects_class_subjects_school_id_subject_id_fkey_idx ON public.class_subjects USING btree (school_id, subject_id);

CREATE INDEX class_subjects_teacher_idx ON public.class_subjects USING btree (school_id, teacher_staff_id);

CREATE INDEX classes_school_year_idx ON public.classes USING btree (school_id, academic_year_id);

CREATE UNIQUE INDEX classes_unique_name_per_year ON public.classes USING btree (school_id, academic_year_id, lower(name), COALESCE(stream, ''::text));

CREATE INDEX counselling_assigned_idx ON public.counselling_cases USING btree (school_id, assigned_staff_id, status);

CREATE INDEX counselling_cases_counselling_cases_school_id_student_id_fkey_i ON public.counselling_cases USING btree (school_id, student_id);

CREATE INDEX counselling_notes_case_idx ON public.counselling_notes USING btree (school_id, case_id, created_at DESC);

CREATE INDEX counselling_notes_counselling_notes_school_id_author_staff_id_f ON public.counselling_notes USING btree (school_id, author_staff_id);

CREATE INDEX departments_school_idx ON public.departments USING btree (school_id);

CREATE INDEX discipline_cases_discipline_cases_school_id_reported_by_staff_i ON public.discipline_cases USING btree (school_id, reported_by_staff_id);

CREATE INDEX discipline_cases_discipline_cases_school_id_resolved_by_staff_i ON public.discipline_cases USING btree (school_id, resolved_by_staff_id);

CREATE INDEX discipline_student_idx ON public.discipline_cases USING btree (school_id, student_id, incident_date DESC);

CREATE INDEX district_memberships_district_memberships_role_code_fkey_idx ON public.district_memberships USING btree (role_code);

CREATE INDEX district_memberships_user_status_idx ON public.district_memberships USING btree (user_id, status);

CREATE INDEX documents_documents_created_by_membership_id_school_id_fkey_idx ON public.documents USING btree (created_by_membership_id, school_id);

CREATE INDEX documents_documents_uploaded_by_fkey_idx ON public.documents USING btree (uploaded_by);

CREATE INDEX documents_student_idx ON public.documents USING btree (school_id, student_id);

CREATE INDEX fee_plan_items_fee_plan_items_school_id_fee_category_id_fkey_id ON public.fee_plan_items USING btree (school_id, fee_category_id);

CREATE INDEX fee_plan_items_fee_plan_items_school_id_fee_plan_id_fkey_idx ON public.fee_plan_items USING btree (school_id, fee_plan_id);

CREATE INDEX fee_plans_fee_plans_school_id_class_id_fkey_idx ON public.fee_plans USING btree (school_id, class_id);

CREATE INDEX fee_plans_school_year_idx ON public.fee_plans USING btree (school_id, academic_year_id);

CREATE INDEX guardians_guardians_user_id_fkey_idx ON public.guardians USING btree (user_id);

CREATE UNIQUE INDEX guardians_unique_user_per_school ON public.guardians USING btree (school_id, user_id) WHERE (user_id IS NOT NULL);

CREATE INDEX invoice_items_invoice_idx ON public.invoice_items USING btree (school_id, invoice_id);

CREATE INDEX invoice_items_invoice_items_school_id_fee_category_id_fkey_idx ON public.invoice_items USING btree (school_id, fee_category_id);

CREATE INDEX invoices_due_idx ON public.invoices USING btree (school_id, due_on) WHERE (status = ANY (ARRAY['issued'::text, 'partially_paid'::text, 'overdue'::text]));

CREATE INDEX invoices_invoices_school_id_academic_year_id_fkey_idx ON public.invoices USING btree (school_id, academic_year_id);

CREATE INDEX invoices_invoices_school_id_fee_plan_id_fkey_idx ON public.invoices USING btree (school_id, fee_plan_id);

CREATE INDEX invoices_invoices_school_id_issued_by_staff_id_fkey_idx ON public.invoices USING btree (school_id, issued_by_staff_id);

CREATE INDEX invoices_student_status_idx ON public.invoices USING btree (school_id, student_id, status);

CREATE INDEX learning_resources_learning_resources_school_id_created_by_staf ON public.learning_resources USING btree (school_id, created_by_staff_id);

CREATE INDEX lesson_plans_class_idx ON public.lesson_plans USING btree (school_id, class_subject_id, planned_for);

CREATE INDEX lesson_plans_lesson_plans_school_id_teacher_staff_id_fkey_idx ON public.lesson_plans USING btree (school_id, teacher_staff_id);

CREATE INDEX library_loans_book_open_idx ON public.library_loans USING btree (school_id, book_id, status) WHERE ((returned_at IS NULL) AND (status = ANY (ARRAY['issued'::text, 'overdue'::text, 'lost'::text])));

CREATE INDEX library_loans_library_loans_school_id_book_id_fkey_idx ON public.library_loans USING btree (school_id, book_id);

CREATE INDEX library_loans_library_loans_school_id_staff_member_id_fkey_idx ON public.library_loans USING btree (school_id, staff_member_id);

CREATE INDEX library_loans_student_idx ON public.library_loans USING btree (school_id, student_id, status);

CREATE INDEX meal_attendance_meal_attendance_school_id_recorded_by_staff_id_ ON public.meal_attendance USING btree (school_id, recorded_by_staff_id);

CREATE INDEX meal_attendance_student_idx ON public.meal_attendance USING btree (school_id, student_id, meal_date DESC);

CREATE INDEX membership_roles_membership_roles_assigned_by_fkey_idx ON public.membership_roles USING btree (assigned_by);

CREATE INDEX membership_roles_membership_roles_membership_id_school_id_fkey_ ON public.membership_roles USING btree (membership_id, school_id);

CREATE INDEX membership_roles_role_idx ON public.membership_roles USING btree (role_code, school_id);

CREATE INDEX message_logs_status_idx ON public.school_message_logs USING btree (school_id, message_status, created_at DESC);

CREATE INDEX notifications_notifications_school_id_fkey_idx ON public.notifications USING btree (school_id);

CREATE INDEX notifications_notifications_user_id_fkey_idx ON public.notifications USING btree (user_id);

CREATE INDEX notifications_user_unread_idx ON public.notifications USING btree (user_id, created_at DESC) WHERE (read_at IS NULL);

CREATE INDEX payment_allocations_invoice_idx ON public.payment_allocations USING btree (school_id, invoice_id);

CREATE INDEX payment_gateway_events_payment_gateway_events_school_id_fkey_id ON public.payment_gateway_events USING btree (school_id);

CREATE INDEX payment_gateway_events_status_idx ON public.payment_gateway_events USING btree (processing_status, received_at);

CREATE INDEX payments_payments_school_id_recorded_by_staff_id_fkey_idx ON public.payments USING btree (school_id, recorded_by_staff_id);

CREATE INDEX payments_student_date_idx ON public.payments USING btree (school_id, student_id, created_at DESC);

CREATE UNIQUE INDEX payments_unique_provider_reference ON public.payments USING btree (school_id, payment_provider, provider_reference) WHERE (provider_reference IS NOT NULL);

CREATE INDEX resources_class_idx ON public.learning_resources USING btree (school_id, class_subject_id);

CREATE INDEX role_permissions_role_permissions_permission_code_fkey_idx ON public.role_permissions USING btree (permission_code);

CREATE INDEX school_assets_school_assets_school_id_assigned_to_staff_id_fkey ON public.school_assets USING btree (school_id, assigned_to_staff_id);

CREATE INDEX school_audit_events_school_audit_events_actor_user_id_fkey_idx ON public.school_audit_events USING btree (actor_user_id);

CREATE INDEX school_audit_events_school_audit_events_school_id_fkey_idx ON public.school_audit_events USING btree (school_id);

CREATE INDEX school_invitations_school_invitations_invited_by_fkey_idx ON public.school_invitations USING btree (invited_by);

CREATE INDEX school_invitations_school_invitations_role_code_fkey_idx ON public.school_invitations USING btree (role_code);

CREATE INDEX school_invitations_school_status_idx ON public.school_invitations USING btree (school_id, status, expires_at);

CREATE INDEX school_memberships_school_memberships_invited_by_fkey_idx ON public.school_memberships USING btree (invited_by);

CREATE INDEX school_memberships_user_status_idx ON public.school_memberships USING btree (user_id, status);

CREATE UNIQUE INDEX school_subscriptions_one_current_per_school_uidx ON public.school_subscriptions USING btree (school_id) WHERE (status = ANY (ARRAY['trial'::text, 'active'::text, 'past_due'::text]));

CREATE INDEX schools_schools_created_by_fkey_idx ON public.schools USING btree (created_by);

CREATE INDEX schools_schools_district_id_fkey_idx ON public.schools USING btree (district_id);

CREATE INDEX selcom_checkout_intents_reconcile_idx ON public.selcom_checkout_intents USING btree (status, created_at) WHERE (status = ANY (ARRAY['creating'::text, 'pending'::text, 'reconciliation_required'::text]));

CREATE INDEX selcom_checkout_intents_school_invoice_idx ON public.selcom_checkout_intents USING btree (school_id, invoice_id, created_at DESC);

CREATE INDEX selcom_checkout_intents_school_payment_fk_idx ON public.selcom_checkout_intents USING btree (school_id, payment_id) WHERE (payment_id IS NOT NULL);

CREATE INDEX selcom_checkout_intents_school_student_fk_idx ON public.selcom_checkout_intents USING btree (school_id, student_id);

CREATE UNIQUE INDEX selcom_one_open_checkout_per_invoice_uidx ON public.selcom_checkout_intents USING btree (school_id, invoice_id) WHERE (status = ANY (ARRAY['creating'::text, 'pending'::text, 'reconciliation_required'::text]));

CREATE INDEX snippe_checkout_intents_reconcile_idx ON public.snippe_checkout_intents USING btree (status, created_at) WHERE (status = ANY (ARRAY['creating'::text, 'pending'::text, 'active'::text, 'reconciliation_required'::text]));

CREATE INDEX snippe_checkout_intents_school_invoice_idx ON public.snippe_checkout_intents USING btree (school_id, invoice_id, created_at DESC);

CREATE INDEX snippe_checkout_intents_school_payment_fk_idx ON public.snippe_checkout_intents USING btree (school_id, payment_id) WHERE (payment_id IS NOT NULL);

CREATE INDEX snippe_checkout_intents_school_student_fk_idx ON public.snippe_checkout_intents USING btree (school_id, student_id);

CREATE UNIQUE INDEX snippe_one_open_checkout_per_invoice_uidx ON public.snippe_checkout_intents USING btree (school_id, invoice_id) WHERE (status = ANY (ARRAY['creating'::text, 'pending'::text, 'active'::text, 'reconciliation_required'::text]));

CREATE INDEX sports_events_sports_events_school_id_team_id_fkey_idx ON public.sports_events USING btree (school_id, team_id);

CREATE INDEX sports_events_start_idx ON public.sports_events USING btree (school_id, starts_at);

CREATE INDEX sports_members_student_idx ON public.sports_team_members USING btree (school_id, student_id);

CREATE INDEX sports_teams_sports_teams_school_id_coach_staff_id_fkey_idx ON public.sports_teams USING btree (school_id, coach_staff_id);

CREATE INDEX staff_attendance_date_idx ON public.staff_attendance USING btree (school_id, attendance_date);

CREATE INDEX staff_attendance_staff_attendance_recorded_by_fkey_idx ON public.staff_attendance USING btree (recorded_by);

CREATE INDEX staff_leave_idx ON public.staff_leave_requests USING btree (school_id, staff_member_id, status);

CREATE INDEX staff_members_school_status_idx ON public.staff_members USING btree (school_id, employment_status);

CREATE INDEX staff_members_staff_members_school_id_department_id_fkey_idx ON public.staff_members USING btree (school_id, department_id);

CREATE INDEX staff_members_staff_members_user_id_fkey_idx ON public.staff_members USING btree (user_id);

CREATE UNIQUE INDEX staff_members_unique_user_per_school ON public.staff_members USING btree (school_id, user_id) WHERE (user_id IS NOT NULL);

CREATE INDEX student_enrollments_class_idx ON public.student_enrollments USING btree (school_id, class_id, status);

CREATE UNIQUE INDEX student_enrollments_one_active_class_per_year_uidx ON public.student_enrollments USING btree (school_id, student_id, academic_year_id) WHERE (status = 'active'::text);

CREATE INDEX student_enrollments_student_enrollments_school_id_academic_year ON public.student_enrollments USING btree (school_id, academic_year_id);

CREATE INDEX student_enrollments_student_idx ON public.student_enrollments USING btree (school_id, student_id);

CREATE INDEX student_guardians_guardian_idx ON public.student_guardians USING btree (school_id, guardian_id);

CREATE UNIQUE INDEX student_guardians_one_primary_per_student ON public.student_guardians USING btree (school_id, student_id) WHERE (is_primary = true);

CREATE INDEX student_health_idx ON public.student_health_records USING btree (school_id, student_id, recorded_at DESC);

CREATE INDEX student_transport_assignments_school_stop_idx ON public.student_transport_assignments USING btree (school_id, stop_id);

CREATE INDEX student_transport_assignments_student_transport_assignments_sch ON public.student_transport_assignments USING btree (school_id, route_id);

CREATE INDEX students_school_status_idx ON public.students USING btree (school_id, student_status);

CREATE INDEX students_students_user_id_fkey_idx ON public.students USING btree (user_id);

CREATE UNIQUE INDEX students_unique_linked_user_per_school ON public.students USING btree (school_id, user_id) WHERE (user_id IS NOT NULL);

CREATE INDEX subjects_school_department_idx ON public.subjects USING btree (school_id, department_id);

CREATE INDEX subscription_invoice_due_idx ON public.subscription_invoices USING btree (school_id, status, due_at);

CREATE INDEX subscription_invoices_subscription_invoices_school_id_subscript ON public.subscription_invoices USING btree (school_id, subscription_id);

CREATE INDEX subscription_status_idx ON public.school_subscriptions USING btree (school_id, status);

CREATE INDEX terms_school_year_idx ON public.terms USING btree (school_id, academic_year_id);

CREATE INDEX timetable_slots_class_day_idx ON public.timetable_slots USING btree (school_id, class_id, weekday, starts_at);

CREATE INDEX timetable_slots_timetable_slots_school_id_academic_year_id_fkey ON public.timetable_slots USING btree (school_id, academic_year_id);

CREATE INDEX timetable_slots_timetable_slots_school_id_class_subject_id_fkey ON public.timetable_slots USING btree (school_id, class_subject_id);

CREATE INDEX timetable_slots_timetable_slots_school_id_teacher_staff_id_fkey ON public.timetable_slots USING btree (school_id, teacher_staff_id);

CREATE INDEX transport_assignments_student_idx ON public.student_transport_assignments USING btree (school_id, student_id, status);

CREATE INDEX transport_routes_transport_routes_school_id_driver_staff_id_fke ON public.transport_routes USING btree (school_id, driver_staff_id);

CREATE INDEX workspace_collaborators_user_idx ON public.workspace_collaborators USING btree (user_id, school_id);

CREATE INDEX workspace_collaborators_workspace_collaborators_invited_by_fkey ON public.workspace_collaborators USING btree (invited_by);

CREATE INDEX workspace_files_idx ON public.workspace_files USING btree (school_id, project_id);

CREATE INDEX workspace_files_workspace_files_uploaded_by_fkey_idx ON public.workspace_files USING btree (uploaded_by);

CREATE INDEX workspace_student_idx ON public.student_workspace_projects USING btree (school_id, student_id, status);

ALTER TABLE private.audit_logs ENABLE ROW LEVEL SECURITY;

ALTER TABLE private.school_payment_gateway_settings ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.academic_years ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.admission_applications ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.admission_documents ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.ai_assistant_messages ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.ai_assistant_sessions ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.ai_usage_ledger ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.assessment_scores ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.assessments ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.assignment_submissions ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.assignments ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.attendance_sessions ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.class_subjects ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.counselling_cases ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.counselling_notes ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.discipline_cases ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.district_memberships ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.districts ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.fee_categories ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.fee_plan_items ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.fee_plans ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.guardians ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.invoice_items ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.learning_resources ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.lesson_plans ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.library_books ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.library_loans ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.meal_attendance ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.meal_menus ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.membership_roles ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.payment_allocations ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.payment_gateway_events ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.permissions ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.role_permissions ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.school_assets ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.school_audit_events ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.school_invitations ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.school_memberships ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.school_message_logs ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.school_settings ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.school_subscriptions ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.selcom_checkout_intents ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.snippe_checkout_intents ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.sports_events ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.sports_team_members ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.sports_teams ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.staff_attendance ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.staff_leave_requests ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.staff_members ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.student_enrollments ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.student_guardians ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.student_health_records ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.student_transport_assignments ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.student_workspace_projects ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.subscription_invoices ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.terms ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.timetable_slots ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.transport_routes ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.transport_stops ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.workspace_collaborators ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.workspace_files ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION private.accept_school_invitation_impl(p_token text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_user_id uuid:=auth.uid();
  v_email text;
  v_email_confirmed_at timestamptz;
  v_token_hash text;
  v_invitation public.school_invitations%rowtype;
  v_membership public.school_memberships%rowtype;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'You must be signed in to accept a school invitation.' USING ERRCODE='42501';
  END IF;
  IF p_token IS NULL OR length(trim(p_token))<32 OR length(p_token)>512 THEN
    RAISE EXCEPTION 'Invitation token is invalid.' USING ERRCODE='22023';
  END IF;

  SELECT lower(trim(u.email)),u.email_confirmed_at
  INTO v_email,v_email_confirmed_at
  FROM auth.users u WHERE u.id=v_user_id;

  IF v_email IS NULL OR v_email='' OR v_email_confirmed_at IS NULL THEN
    RAISE EXCEPTION 'A verified email address is required to accept this email invitation.' USING ERRCODE='42501';
  END IF;

  v_token_hash:=encode(extensions.digest(convert_to(p_token,'UTF8'),'sha256'),'hex');
  SELECT si.* INTO v_invitation
  FROM public.school_invitations si WHERE si.token_hash=v_token_hash FOR UPDATE;

  IF NOT FOUND OR v_invitation.status<>'pending' OR v_invitation.expires_at<=now() THEN
    RAISE EXCEPTION 'Invitation is invalid, expired or has already been used.' USING ERRCODE='22023';
  END IF;
  IF lower(trim(v_invitation.email))<>v_email THEN
    RAISE EXCEPTION 'This invitation was issued to a different email address.' USING ERRCODE='42501';
  END IF;

  SELECT sm.* INTO v_membership
  FROM public.school_memberships sm
  WHERE sm.school_id=v_invitation.school_id AND sm.user_id=v_user_id
  FOR UPDATE;

  IF FOUND THEN
    IF v_membership.status='suspended' THEN
      RAISE EXCEPTION 'This school membership is suspended. Contact the school administrator.' USING ERRCODE='42501';
    ELSIF v_membership.status IN ('invited','left') THEN
      UPDATE public.school_memberships
      SET status='active',joined_at=now(),invited_by=v_invitation.invited_by
      WHERE id=v_membership.id RETURNING * INTO v_membership;
    ELSIF v_membership.status<>'active' THEN
      RAISE EXCEPTION 'This membership cannot be activated by this invitation.' USING ERRCODE='42501';
    END IF;
  ELSE
    INSERT INTO public.school_memberships(school_id,user_id,status,invited_by)
    VALUES(v_invitation.school_id,v_user_id,'active',v_invitation.invited_by)
    RETURNING * INTO v_membership;
  END IF;

  INSERT INTO public.membership_roles(membership_id,school_id,role_code,assigned_by)
  VALUES(v_membership.id,v_invitation.school_id,v_invitation.role_code,v_invitation.invited_by)
  ON CONFLICT(membership_id,role_code) DO NOTHING;

  UPDATE public.school_invitations
  SET status='accepted',accepted_at=now()
  WHERE id=v_invitation.id AND status='pending';

  RETURN v_invitation.school_id;
END;
$function$


CREATE OR REPLACE FUNCTION private.audit_school_payment_gateway_change()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
BEGIN
  IF NEW.active_provider IS DISTINCT FROM OLD.active_provider THEN
    INSERT INTO public.school_audit_events(
      school_id,actor_user_id,event_type,entity_type,entity_id,event_payload,occurred_at
    )
    VALUES(
      NEW.school_id,
      (SELECT auth.uid()),
      'payment_gateway_changed',
      'school_payment_gateway_settings',
      NEW.school_id::text,
      jsonb_build_object(
        'previous_provider',OLD.active_provider,
        'active_provider',NEW.active_provider,
        'changed_columns',jsonb_build_array('active_provider')
      ),
      now()
    );
  END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.bootstrap_school_impl(p_name text, p_slug text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_user_id uuid:=auth.uid();
  v_slug text;
  v_school_id uuid;
  v_name text:=trim(coalesce(p_name,''));
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'You must be signed in to create a school.';
  END IF;

  IF length(v_name)<2 THEN
    RAISE EXCEPTION 'School name must contain at least 2 characters.';
  END IF;

  IF EXISTS(
    SELECT 1 FROM public.school_memberships sm
    WHERE sm.user_id=v_user_id AND sm.status='active'
  ) THEN
    RAISE EXCEPTION 'This account already has an active school membership. Ask a school owner to invite you to another school.';
  END IF;

  v_slug:=lower(trim(both '-' from regexp_replace(
    coalesce(nullif(trim(p_slug),''),v_name),
    '[^a-zA-Z0-9]+','-','g'
  )));

  IF length(v_slug)<2 THEN
    RAISE EXCEPTION 'Please provide a school name or a valid school URL slug.';
  END IF;

  INSERT INTO public.schools(name,slug,created_by)
  VALUES(v_name,v_slug,v_user_id)
  RETURNING id INTO v_school_id;

  INSERT INTO public.school_memberships(school_id,user_id,status)
  VALUES(v_school_id,v_user_id,'active');

  INSERT INTO public.membership_roles(membership_id,school_id,role_code,assigned_by)
  SELECT sm.id,sm.school_id,'school_owner',v_user_id
  FROM public.school_memberships sm
  WHERE sm.school_id=v_school_id AND sm.user_id=v_user_id;

  INSERT INTO public.school_settings(school_id,settings)
  VALUES(v_school_id,jsonb_build_object(
    'locale','sw-TZ',
    'timezone','Africa/Dar_es_Salaam',
    'currency','TZS'
  ));

  RETURN v_school_id;
END;
$function$


CREATE OR REPLACE FUNCTION private.bootstrap_school_payment_gateway_setting()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
BEGIN
  INSERT INTO private.school_payment_gateway_settings(school_id,active_provider)
  VALUES(NEW.id,'selcom')
  ON CONFLICT(school_id) DO NOTHING;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.can_access_academic_year(p_school_id uuid, p_academic_year_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT
  private.has_school_permission(p_school_id,'academics.read')
  OR EXISTS(
    SELECT 1 FROM public.classes c
    WHERE c.school_id=p_school_id
      AND c.academic_year_id=p_academic_year_id
      AND private.can_access_class(c.school_id,c.id)
  );
$function$


CREATE OR REPLACE FUNCTION private.can_access_class(p_school_id uuid, p_class_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(
  SELECT 1 FROM public.classes c
  WHERE c.school_id=p_school_id AND c.id=p_class_id
   AND (
    private.is_school_role(p_school_id,'school_owner')
    OR private.is_school_role(p_school_id,'school_admin')
    OR private.is_school_role(p_school_id,'head_teacher')
    OR private.is_school_role(p_school_id,'academic_master')
    OR EXISTS(
      SELECT 1 FROM public.schools sc
      WHERE sc.id=p_school_id AND sc.district_id IS NOT NULL
       AND private.has_district_permission(sc.district_id,'districts.read')
    )
    OR EXISTS(
      SELECT 1
      FROM public.class_subjects cs
      JOIN public.staff_members st
       ON st.school_id=cs.school_id AND st.id=cs.teacher_staff_id
      WHERE cs.school_id=c.school_id AND cs.class_id=c.id
       AND st.user_id=(SELECT auth.uid()) AND st.employment_status='active'
    )
    OR EXISTS(
      SELECT 1
      FROM public.class_subjects cs
      JOIN public.subjects su
       ON su.school_id=cs.school_id AND su.id=cs.subject_id
      JOIN public.staff_members st
       ON st.school_id=cs.school_id AND st.user_id=(SELECT auth.uid())
      WHERE cs.school_id=c.school_id AND cs.class_id=c.id
       AND st.employment_status='active'
       AND st.department_id=su.department_id
       AND private.is_school_role(p_school_id,'department_head')
    )
    OR EXISTS(
      SELECT 1 FROM public.student_enrollments se
      WHERE se.school_id=c.school_id AND se.class_id=c.id
       AND se.status='active'
       AND private.is_student_or_guardian(se.school_id,se.student_id)
    )
   )
 );
$function$


CREATE OR REPLACE FUNCTION private.can_access_class_subject(p_school_id uuid, p_class_subject_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(SELECT 1 FROM public.class_subjects cs JOIN public.subjects su ON su.school_id=cs.school_id AND su.id=cs.subject_id
 WHERE cs.school_id=p_school_id AND cs.id=p_class_subject_id AND (
 private.is_school_role(p_school_id,'school_owner') OR private.is_school_role(p_school_id,'school_admin')
 OR private.is_school_role(p_school_id,'head_teacher') OR private.is_school_role(p_school_id,'academic_master')
 OR EXISTS(SELECT 1 FROM public.schools sc WHERE sc.id=p_school_id AND sc.district_id IS NOT NULL AND private.has_district_permission(sc.district_id,'districts.read'))
 OR EXISTS(SELECT 1 FROM public.staff_members st WHERE st.school_id=cs.school_id AND st.id=cs.teacher_staff_id AND st.user_id=(SELECT auth.uid()) AND st.employment_status='active')
 OR EXISTS(SELECT 1 FROM public.staff_members me WHERE me.school_id=cs.school_id AND me.user_id=(SELECT auth.uid()) AND me.employment_status='active' AND private.is_school_role(p_school_id,'department_head') AND me.department_id=su.department_id)
 OR EXISTS(SELECT 1 FROM public.student_enrollments se WHERE se.school_id=cs.school_id AND se.class_id=cs.class_id AND se.status='active' AND private.is_student_or_guardian(se.school_id,se.student_id))
 ));
$function$


CREATE OR REPLACE FUNCTION private.can_access_document(p_document_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_doc public.documents%rowtype;
begin
  select * into v_doc
  from public.documents d
  where d.id = p_document_id;

  if not found then
    return false;
  end if;

  if v_doc.access_scope = 'school' then
    return private.has_school_permission(v_doc.school_id, 'documents.read');
  elsif v_doc.access_scope = 'academic' then
    return private.has_school_permission(v_doc.school_id, 'documents.read')
      or private.has_school_permission(v_doc.school_id, 'academics.read')
      or private.has_school_permission(v_doc.school_id, 'assessments.read');
  elsif v_doc.access_scope = 'finance' then
    return private.has_school_permission(v_doc.school_id, 'finance.read');
  elsif v_doc.access_scope = 'uploader' then
    return v_doc.uploaded_by = (select auth.uid())
      or private.has_school_permission(v_doc.school_id, 'documents.manage');
  elsif v_doc.access_scope = 'student_guardian' then
    return v_doc.student_id is not null
      and private.is_student_or_guardian(v_doc.school_id, v_doc.student_id);
  end if;

  return false;
end;
$function$


CREATE OR REPLACE FUNCTION private.can_access_document_object(p_object_name text, p_manage boolean DEFAULT false)
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE v_school_id uuid; v_document_id uuid; v_doc public.documents%rowtype;
BEGIN
 BEGIN v_school_id:=split_part(p_object_name,'/',1)::uuid; v_document_id:=split_part(p_object_name,'/',2)::uuid;
 EXCEPTION WHEN invalid_text_representation THEN RETURN false; END;
 SELECT * INTO v_doc FROM public.documents d WHERE d.id=v_document_id AND d.school_id=v_school_id;
 IF NOT FOUND THEN RETURN false; END IF;
 IF p_manage THEN RETURN private.has_school_permission(v_school_id,'documents.manage') OR (v_doc.uploaded_by=(SELECT auth.uid()) AND private.is_school_member(v_school_id)); END IF;
 RETURN private.can_access_document(v_document_id);
END;
$function$


CREATE OR REPLACE FUNCTION private.can_access_subject(p_school_id uuid, p_subject_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(
  SELECT 1 FROM public.class_subjects cs
  WHERE cs.school_id=p_school_id
    AND cs.subject_id=p_subject_id
    AND private.can_access_class_subject(cs.school_id,cs.id)
 );
$function$


CREATE OR REPLACE FUNCTION private.can_access_workspace_object(p_object_name text, p_manage boolean DEFAULT false)
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_parts text[];
  v_school_id uuid;
  v_project_id uuid;
  v_user_id uuid:=(SELECT auth.uid());
BEGIN
  IF v_user_id IS NULL THEN RETURN false; END IF;
  v_parts:=string_to_array(p_object_name,'/');
  IF array_length(v_parts,1)<4 OR v_parts[1]<>'workspace' THEN RETURN false; END IF;
  BEGIN
    v_school_id:=v_parts[2]::uuid;
    v_project_id:=v_parts[3]::uuid;
  EXCEPTION WHEN invalid_text_representation THEN
    RETURN false;
  END;

  RETURN EXISTS(
    SELECT 1 FROM public.workspace_files wf
    WHERE wf.school_id=v_school_id
      AND wf.project_id=v_project_id
      AND wf.object_path=p_object_name
  )
  AND private.has_workspace_access(v_school_id,v_project_id,v_user_id,p_manage);
END;
$function$


CREATE OR REPLACE FUNCTION private.can_manage_assessment_student(p_school_id uuid, p_assessment_id uuid, p_student_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(
  SELECT 1
  FROM public.assessments a
  JOIN public.class_subjects cs
    ON cs.school_id=a.school_id AND cs.id=a.class_subject_id
  JOIN public.student_enrollments se
    ON se.school_id=cs.school_id AND se.class_id=cs.class_id
  WHERE a.school_id=p_school_id AND a.id=p_assessment_id
    AND se.student_id=p_student_id
    AND se.status='active'
    AND (a.assessment_date IS NULL OR se.enrolled_on<=a.assessment_date)
    AND (a.assessment_date IS NULL OR se.exited_on IS NULL OR se.exited_on>=a.assessment_date)
    AND private.can_manage_class_subject(a.school_id,a.class_subject_id,'assessments.manage')
 );
$function$


CREATE OR REPLACE FUNCTION private.can_manage_attendance_record(p_school_id uuid, p_session_id uuid, p_student_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(
  SELECT 1
  FROM public.attendance_sessions s
  JOIN public.student_enrollments se
    ON se.school_id=s.school_id AND se.class_id=s.class_id
  WHERE s.school_id=p_school_id AND s.id=p_session_id
    AND se.student_id=p_student_id
    AND se.enrolled_on<=s.session_date
    AND (se.exited_on IS NULL OR se.exited_on>=s.session_date)
    AND private.can_manage_attendance_session(s.school_id,s.id)
 );
$function$


CREATE OR REPLACE FUNCTION private.can_manage_attendance_session(p_school_id uuid, p_session_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(
  SELECT 1 FROM public.attendance_sessions s
  WHERE s.school_id=p_school_id AND s.id=p_session_id
   AND private.can_manage_class(s.school_id,s.class_id,'attendance.manage')
   AND (
     s.class_subject_id IS NULL
     OR private.can_manage_class_subject(s.school_id,s.class_subject_id,'attendance.manage')
   )
 );
$function$


CREATE OR REPLACE FUNCTION private.can_manage_class(p_school_id uuid, p_class_id uuid, p_permission_code text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT private.has_school_permission(p_school_id,p_permission_code)
 AND EXISTS(
  SELECT 1 FROM public.classes c
  WHERE c.school_id=p_school_id AND c.id=p_class_id
   AND (
    private.is_school_role(p_school_id,'school_owner')
    OR private.is_school_role(p_school_id,'school_admin')
    OR private.is_school_role(p_school_id,'head_teacher')
    OR private.is_school_role(p_school_id,'academic_master')
    OR EXISTS(
      SELECT 1
      FROM public.class_subjects cs
      JOIN public.staff_members st
       ON st.school_id=cs.school_id AND st.id=cs.teacher_staff_id
      WHERE cs.school_id=c.school_id AND cs.class_id=c.id
       AND st.user_id=(SELECT auth.uid()) AND st.employment_status='active'
    )
    OR EXISTS(
      SELECT 1
      FROM public.class_subjects cs
      JOIN public.subjects su
       ON su.school_id=cs.school_id AND su.id=cs.subject_id
      JOIN public.staff_members st
       ON st.school_id=cs.school_id AND st.user_id=(SELECT auth.uid())
      WHERE cs.school_id=c.school_id AND cs.class_id=c.id
       AND st.employment_status='active'
       AND st.department_id=su.department_id
       AND private.is_school_role(p_school_id,'department_head')
    )
   )
 );
$function$


CREATE OR REPLACE FUNCTION private.can_manage_class_subject(p_school_id uuid, p_class_subject_id uuid, p_permission_code text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT private.has_school_permission(p_school_id,p_permission_code) AND EXISTS(
 SELECT 1 FROM public.class_subjects cs JOIN public.subjects su ON su.school_id=cs.school_id AND su.id=cs.subject_id
 WHERE cs.school_id=p_school_id AND cs.id=p_class_subject_id AND (
 private.is_school_role(p_school_id,'school_owner') OR private.is_school_role(p_school_id,'school_admin')
 OR private.is_school_role(p_school_id,'head_teacher') OR private.is_school_role(p_school_id,'academic_master')
 OR EXISTS(SELECT 1 FROM public.staff_members st WHERE st.school_id=cs.school_id AND st.id=cs.teacher_staff_id AND st.user_id=(SELECT auth.uid()) AND st.employment_status='active')
 OR EXISTS(SELECT 1 FROM public.staff_members me WHERE me.school_id=cs.school_id AND me.user_id=(SELECT auth.uid()) AND me.employment_status='active' AND private.is_school_role(p_school_id,'department_head') AND me.department_id=su.department_id)
 ));
$function$


CREATE OR REPLACE FUNCTION private.can_manage_counselling_case(p_school_id uuid, p_case_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(SELECT 1 FROM public.counselling_cases c WHERE c.school_id=p_school_id AND c.id=p_case_id AND (
 private.is_school_role(p_school_id,'school_owner') OR private.is_school_role(p_school_id,'school_admin')
 OR (private.has_school_permission(p_school_id,'counselling.manage') AND c.assigned_staff_id IN
 (SELECT st.id FROM public.staff_members st WHERE st.school_id=p_school_id AND st.user_id=(SELECT auth.uid()) AND st.employment_status='active'))
 ));
$function$


CREATE OR REPLACE FUNCTION private.can_student_submit_assignment(p_school_id uuid, p_assignment_id uuid, p_student_id uuid, p_attempt_number integer, p_status text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT
    (SELECT auth.uid()) IS NOT NULL
    AND private.has_school_permission(p_school_id,'assignments.submit')
    AND private.is_student_owner(p_school_id,p_student_id)
    AND p_status IN ('draft','submitted','late')
    AND EXISTS (
      SELECT 1
      FROM public.assignments a
      JOIN public.class_subjects cs
        ON cs.school_id=a.school_id AND cs.id=a.class_subject_id
      JOIN public.student_enrollments se
        ON se.school_id=cs.school_id AND se.class_id=cs.class_id
      WHERE a.school_id=p_school_id
        AND a.id=p_assignment_id
        AND se.student_id=p_student_id
        AND se.status='active'
        AND a.status='published'
        AND p_attempt_number BETWEEN 1 AND a.max_attempts
        AND (
          p_status='draft'
          OR a.due_at IS NULL
          OR now()<=a.due_at
          OR a.allow_late_submission
        )
    );
$function$


CREATE OR REPLACE FUNCTION private.can_view_assessment_student(p_school_id uuid, p_assessment_id uuid, p_student_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(
  SELECT 1
  FROM public.assessments a
  JOIN public.class_subjects cs
    ON cs.school_id=a.school_id AND cs.id=a.class_subject_id
  JOIN public.student_enrollments se
    ON se.school_id=cs.school_id AND se.class_id=cs.class_id
  WHERE a.school_id=p_school_id AND a.id=p_assessment_id
    AND se.student_id=p_student_id
    AND (a.assessment_date IS NULL OR se.enrolled_on<=a.assessment_date)
    AND (a.assessment_date IS NULL OR se.exited_on IS NULL OR se.exited_on>=a.assessment_date)
    AND (
      (
        private.is_student_or_guardian(p_school_id,p_student_id)
        AND a.status IN ('published','locked','archived')
      )
      OR (
        NOT private.is_student_or_guardian(p_school_id,p_student_id)
        AND private.has_school_permission(p_school_id,'assessments.read')
        AND private.can_access_class_subject(a.school_id,a.class_subject_id)
      )
      OR (
        private.has_school_permission(p_school_id,'students.read_all')
        AND private.can_access_class_subject(a.school_id,a.class_subject_id)
      )
    )
 );
$function$


CREATE OR REPLACE FUNCTION private.can_view_attendance_record(p_school_id uuid, p_session_id uuid, p_student_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(
  SELECT 1
  FROM public.attendance_sessions s
  JOIN public.student_enrollments se
    ON se.school_id=s.school_id AND se.class_id=s.class_id
  WHERE s.school_id=p_school_id AND s.id=p_session_id
    AND se.student_id=p_student_id
    AND se.enrolled_on<=s.session_date
    AND (se.exited_on IS NULL OR se.exited_on>=s.session_date)
    AND (
      (
        private.has_school_permission(p_school_id,'attendance.read')
        AND private.can_access_class(s.school_id,s.class_id)
      )
      OR private.is_student_or_guardian(p_school_id,p_student_id)
    )
 );
$function$


CREATE OR REPLACE FUNCTION private.can_view_invoice(p_school_id uuid, p_invoice_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select
    private.has_school_permission(p_school_id, 'finance.read')
    or exists (
      select 1 from public.invoices i
      where i.school_id = p_school_id
        and i.id = p_invoice_id
        and private.is_student_or_guardian(i.school_id, i.student_id)
    );
$function$


CREATE OR REPLACE FUNCTION private.can_view_profile(p_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select p_user_id = (select auth.uid())
    or exists (
      select 1
      from public.school_memberships mine
      join public.school_memberships theirs on theirs.school_id = mine.school_id
      where mine.user_id = (select auth.uid())
        and theirs.user_id = p_user_id
        and mine.status = 'active'
        and theirs.status = 'active'
    )
    or exists (
      select 1
      from public.district_memberships mine
      join public.district_memberships theirs on theirs.district_id = mine.district_id
      where mine.user_id = (select auth.uid())
        and theirs.user_id = p_user_id
        and mine.status = 'active'
        and theirs.status = 'active'
    );
$function$


CREATE OR REPLACE FUNCTION private.can_view_student(p_school_id uuid, p_student_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select
    private.has_school_permission(p_school_id, 'students.read_all')
    or private.is_student_or_guardian(p_school_id, p_student_id)
    or (
      private.has_school_permission(p_school_id, 'students.read_assigned')
      and exists (
        select 1
        from public.student_enrollments se
        join public.class_subjects cs
          on cs.school_id = se.school_id and cs.class_id = se.class_id
        join public.staff_members st
          on st.school_id = cs.school_id and st.id = cs.teacher_staff_id
        where se.school_id = p_school_id
          and se.student_id = p_student_id
          and se.status = 'active'
          and st.user_id = (select auth.uid())
          and st.employment_status = 'active'
      )
    );
$function$


CREATE OR REPLACE FUNCTION private.capture_audit_log()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_old jsonb := case when tg_op in ('UPDATE','DELETE') then to_jsonb(old) else '{}'::jsonb end;
  v_new jsonb := case when tg_op in ('INSERT','UPDATE') then to_jsonb(new) else '{}'::jsonb end;
  v_row jsonb;
  v_school_id uuid;
  v_record_id uuid;
  v_changed text[];
begin
  v_row := case when tg_op = 'DELETE' then v_old else v_new end;
  v_record_id := nullif(v_row ->> 'id','')::uuid;

  if tg_table_name = 'schools' then
    v_school_id := nullif(v_row ->> 'id','')::uuid;
  else
    v_school_id := nullif(v_row ->> 'school_id','')::uuid;
  end if;

  if tg_op = 'INSERT' then
    select coalesce(array_agg(k order by k), array[]::text[])
      into v_changed from jsonb_object_keys(v_new) as k;
  elsif tg_op = 'DELETE' then
    select coalesce(array_agg(k order by k), array[]::text[])
      into v_changed from jsonb_object_keys(v_old) as k;
  else
    select coalesce(array_agg(k order by k), array[]::text[])
      into v_changed
    from (
      select key as k from jsonb_each(v_new)
      union
      select key as k from jsonb_each(v_old)
    ) all_keys
    where v_old -> k is distinct from v_new -> k;
  end if;

  insert into private.audit_logs(
    school_id, actor_user_id, action, table_name, record_id, changed_columns
  )
  values (
    v_school_id, auth.uid(), tg_op, tg_table_name, v_record_id, v_changed
  );

  if tg_op = 'DELETE' then return old; end if;
  return new;
end;
$function$


CREATE OR REPLACE FUNCTION private.capture_school_audit_event()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_old jsonb := CASE WHEN TG_OP IN ('UPDATE','DELETE') THEN to_jsonb(OLD) ELSE '{}'::jsonb END;
  v_new jsonb := CASE WHEN TG_OP IN ('INSERT','UPDATE') THEN to_jsonb(NEW) ELSE '{}'::jsonb END;
  v_row jsonb;
  v_school_id uuid;
  v_entity_id text;
  v_changed text[];
BEGIN
  v_row:=CASE WHEN TG_OP='DELETE' THEN v_old ELSE v_new END;
  v_school_id:=NULLIF(v_row->>'school_id','')::uuid;
  v_entity_id:=NULLIF(v_row->>'id','');

  IF v_entity_id IS NULL THEN
    v_entity_id:=COALESCE(v_row->>'project_id','')
      || ':' || COALESCE(v_row->>'user_id','');
  END IF;

  IF TG_OP='INSERT' THEN
    SELECT COALESCE(array_agg(k ORDER BY k),ARRAY[]::text[])
      INTO v_changed FROM jsonb_object_keys(v_new) AS k;
  ELSIF TG_OP='DELETE' THEN
    SELECT COALESCE(array_agg(k ORDER BY k),ARRAY[]::text[])
      INTO v_changed FROM jsonb_object_keys(v_old) AS k;
  ELSE
    SELECT COALESCE(array_agg(keys.k ORDER BY keys.k),ARRAY[]::text[])
      INTO v_changed
    FROM (
      SELECT key AS k FROM jsonb_each(v_new)
      UNION
      SELECT key AS k FROM jsonb_each(v_old)
    ) keys
    WHERE v_old->keys.k IS DISTINCT FROM v_new->keys.k;
  END IF;

  INSERT INTO public.school_audit_events(
    school_id,actor_user_id,event_type,entity_type,entity_id,event_payload,occurred_at
  )
  VALUES(
    v_school_id,(SELECT auth.uid()),TG_OP,TG_TABLE_NAME,v_entity_id,
    jsonb_build_object('changed_columns',v_changed),now()
  );

  IF TG_OP='DELETE' THEN RETURN OLD; END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_ai_session_identity()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
BEGIN
  IF NEW.school_id IS DISTINCT FROM OLD.school_id
     OR NEW.user_id IS DISTINCT FROM OLD.user_id
     OR NEW.id IS DISTINCT FROM OLD.id THEN
    RAISE EXCEPTION 'AI session owner, school and identity are immutable.'
      USING ERRCODE='42501';
  END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_assessment_score()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_assessment public.assessments%rowtype;
  v_staff_id uuid;
BEGIN
  IF TG_OP='UPDATE' AND (
    NEW.school_id IS DISTINCT FROM OLD.school_id
    OR NEW.assessment_id IS DISTINCT FROM OLD.assessment_id
    OR NEW.student_id IS DISTINCT FROM OLD.student_id
    OR NEW.entered_by_staff_id IS DISTINCT FROM OLD.entered_by_staff_id
  ) THEN
    RAISE EXCEPTION 'Assessment score identity and original marker are immutable.'
      USING ERRCODE='42501';
  END IF;

  SELECT a.* INTO v_assessment
  FROM public.assessments a
  WHERE a.school_id=NEW.school_id AND a.id=NEW.assessment_id
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Assessment does not exist in this school.'
      USING ERRCODE='23503';
  END IF;

  IF NEW.score<0 OR NEW.score>v_assessment.max_score THEN
    RAISE EXCEPTION 'Assessment score must be between zero and the assessment maximum.'
      USING ERRCODE='23514';
  END IF;

  IF NOT EXISTS(
    SELECT 1
    FROM public.class_subjects cs
    JOIN public.student_enrollments se
      ON se.school_id=cs.school_id AND se.class_id=cs.class_id
    WHERE cs.school_id=NEW.school_id
      AND cs.id=v_assessment.class_subject_id
      AND se.student_id=NEW.student_id
      AND se.status='active'
      AND (v_assessment.assessment_date IS NULL OR se.enrolled_on<=v_assessment.assessment_date)
      AND (v_assessment.assessment_date IS NULL OR se.exited_on IS NULL OR se.exited_on>=v_assessment.assessment_date)
  ) THEN
    RAISE EXCEPTION 'Student must be actively enrolled in the assessment class.'
      USING ERRCODE='23514';
  END IF;

  IF (SELECT auth.uid()) IS NOT NULL THEN
    IF NOT private.can_manage_class_subject(
      NEW.school_id,v_assessment.class_subject_id,'assessments.manage'
    ) THEN
      RAISE EXCEPTION 'You are not assigned to manage this assessment.'
        USING ERRCODE='42501';
    END IF;

    SELECT st.id INTO v_staff_id
    FROM public.staff_members st
    WHERE st.school_id=NEW.school_id
      AND st.user_id=(SELECT auth.uid())
      AND st.employment_status='active'
    ORDER BY st.created_at
    LIMIT 1;

    IF TG_OP='INSERT' THEN
      IF NEW.entered_by_staff_id IS NOT NULL
         AND NEW.entered_by_staff_id IS DISTINCT FROM v_staff_id THEN
        RAISE EXCEPTION 'Assessment marker must be the signed-in staff member.'
          USING ERRCODE='42501';
      END IF;
      NEW.entered_by_staff_id:=v_staff_id;
      NEW.entered_at:=now();
    ELSIF NEW.score IS DISTINCT FROM OLD.score THEN
      NEW.entered_at:=now();
    END IF;
  ELSE
    IF TG_OP='INSERT' THEN NEW.entered_at:=now(); END IF;
  END IF;

  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_assessment_update()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
BEGIN
  IF NEW.school_id IS DISTINCT FROM OLD.school_id
     OR NEW.class_subject_id IS DISTINCT FROM OLD.class_subject_id THEN
    IF EXISTS(
      SELECT 1 FROM public.assessment_scores sc
      WHERE sc.school_id=OLD.school_id AND sc.assessment_id=OLD.id
    ) THEN
      RAISE EXCEPTION 'Assessment school and class subject cannot change after scores have been recorded.'
        USING ERRCODE='55000';
    END IF;
  END IF;

  IF EXISTS(
    SELECT 1 FROM public.assessment_scores sc
    WHERE sc.school_id=OLD.school_id
      AND sc.assessment_id=OLD.id
      AND sc.score>NEW.max_score
  ) THEN
    RAISE EXCEPTION 'Maximum score cannot be reduced below an already-recorded student score.'
      USING ERRCODE='23514';
  END IF;

  IF (SELECT auth.uid()) IS NOT NULL
     AND NEW.created_by_staff_id IS DISTINCT FROM OLD.created_by_staff_id
     AND NEW.created_by_staff_id IS NOT NULL
     AND NOT EXISTS(
       SELECT 1 FROM public.staff_members st
       WHERE st.school_id=NEW.school_id AND st.id=NEW.created_by_staff_id
         AND st.user_id=(SELECT auth.uid()) AND st.employment_status='active'
     ) THEN
    RAISE EXCEPTION 'Assessment creator must be the signed-in staff member.'
      USING ERRCODE='42501';
  END IF;

  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_assignment_submission()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_assignment public.assignments%rowtype;
  v_is_manager boolean := false;
  v_now timestamptz := now();
BEGIN
  IF TG_OP='UPDATE' THEN
    IF NEW.school_id IS DISTINCT FROM OLD.school_id
       OR NEW.assignment_id IS DISTINCT FROM OLD.assignment_id
       OR NEW.student_id IS DISTINCT FROM OLD.student_id
       OR NEW.attempt_number IS DISTINCT FROM OLD.attempt_number THEN
      RAISE EXCEPTION 'Submission ownership, assignment and attempt references are immutable.'
        USING ERRCODE='42501';
    END IF;
  END IF;

  IF (SELECT auth.uid()) IS NULL THEN
    IF TG_OP='UPDATE' AND NEW.score IS NOT NULL AND NEW.graded_at IS NULL THEN
      NEW.graded_at:=v_now;
    END IF;
    RETURN NEW;
  END IF;

  SELECT a.* INTO v_assignment
  FROM public.assignments a
  WHERE a.school_id=NEW.school_id AND a.id=NEW.assignment_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Assignment not found for this school.' USING ERRCODE='23503';
  END IF;

  v_is_manager:=private.can_manage_class_subject(
    NEW.school_id,v_assignment.class_subject_id,'assignments.manage'
  );

  IF v_is_manager THEN
    IF TG_OP='UPDATE' AND (
       NEW.submission_text IS DISTINCT FROM OLD.submission_text
       OR NEW.object_path IS DISTINCT FROM OLD.object_path
       OR NEW.submitted_at IS DISTINCT FROM OLD.submitted_at
    ) THEN
      RAISE EXCEPTION 'Markers may grade submissions but cannot rewrite student work or its original submission time.'
        USING ERRCODE='42501';
    END IF;

    IF NEW.score IS NOT NULL AND v_assignment.max_score IS NOT NULL
       AND NEW.score>v_assignment.max_score THEN
      RAISE EXCEPTION 'Submission score cannot exceed the assignment maximum score.' USING ERRCODE='23514';
    END IF;

    IF NEW.score IS NOT NULL THEN
      NEW.graded_at:=COALESCE(NEW.graded_at,v_now);
      IF NEW.graded_by_staff_id IS NULL THEN
        SELECT st.id INTO NEW.graded_by_staff_id
        FROM public.staff_members st
        WHERE st.school_id=NEW.school_id
          AND st.user_id=(SELECT auth.uid())
          AND st.employment_status='active'
        ORDER BY st.created_at
        LIMIT 1;
      END IF;
    ELSE
      NEW.graded_at:=NULL;
    END IF;
    RETURN NEW;
  END IF;

  IF TG_OP='UPDATE' THEN
    IF NOT private.is_student_owner(OLD.school_id,OLD.student_id) THEN
      RAISE EXCEPTION 'Only the assigned student or an authorized marker can change this submission.' USING ERRCODE='42501';
    END IF;
    IF NEW.score IS DISTINCT FROM OLD.score
       OR NEW.feedback IS DISTINCT FROM OLD.feedback
       OR NEW.graded_by_staff_id IS DISTINCT FROM OLD.graded_by_staff_id
       OR NEW.graded_at IS DISTINCT FROM OLD.graded_at THEN
      RAISE EXCEPTION 'Students cannot modify grading fields.' USING ERRCODE='42501';
    END IF;
  ELSE
    IF NOT private.is_student_owner(NEW.school_id,NEW.student_id) THEN
      RAISE EXCEPTION 'A student can only submit their own work.' USING ERRCODE='42501';
    END IF;
    IF NEW.score IS NOT NULL OR NEW.feedback IS NOT NULL
       OR NEW.graded_by_staff_id IS NOT NULL OR NEW.graded_at IS NOT NULL THEN
      RAISE EXCEPTION 'Students cannot set marks, feedback or grading metadata.' USING ERRCODE='42501';
    END IF;
  END IF;

  IF NEW.status NOT IN ('draft','submitted','late') THEN
    RAISE EXCEPTION 'Students may only save a draft or submit their work.' USING ERRCODE='42501';
  END IF;

  IF NEW.status='draft' THEN
    NEW.submitted_at:=NULL;
  ELSE
    IF v_assignment.due_at IS NOT NULL AND v_now>v_assignment.due_at
       AND NOT v_assignment.allow_late_submission THEN
      RAISE EXCEPTION 'The assignment deadline has passed and late submissions are disabled.' USING ERRCODE='23514';
    END IF;
    NEW.submitted_at:=v_now;
    NEW.status:=CASE
      WHEN v_assignment.due_at IS NOT NULL AND v_now>v_assignment.due_at
           AND v_assignment.allow_late_submission THEN 'late'
      ELSE 'submitted'
    END;
  END IF;
  NEW.graded_at:=NULL;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_attendance_record()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_session public.attendance_sessions%rowtype;
  v_staff_id uuid;
BEGIN
  IF TG_OP='UPDATE' AND (
    NEW.school_id IS DISTINCT FROM OLD.school_id
    OR NEW.attendance_session_id IS DISTINCT FROM OLD.attendance_session_id
    OR NEW.student_id IS DISTINCT FROM OLD.student_id
  ) THEN
    RAISE EXCEPTION 'Attendance record school, session and student are immutable.'
      USING ERRCODE='42501';
  END IF;

  SELECT s.* INTO v_session
  FROM public.attendance_sessions s
  WHERE s.school_id=NEW.school_id AND s.id=NEW.attendance_session_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Attendance session does not exist in this school.'
      USING ERRCODE='23503';
  END IF;

  IF NOT EXISTS(
    SELECT 1 FROM public.student_enrollments se
    WHERE se.school_id=NEW.school_id
      AND se.student_id=NEW.student_id
      AND se.class_id=v_session.class_id
      AND se.enrolled_on<=v_session.session_date
      AND (se.exited_on IS NULL OR se.exited_on>=v_session.session_date)
  ) THEN
    RAISE EXCEPTION 'Student was not enrolled in the attendance session class on the session date.'
      USING ERRCODE='23514';
  END IF;

  IF (SELECT auth.uid()) IS NOT NULL THEN
    SELECT st.id INTO v_staff_id
    FROM public.staff_members st
    WHERE st.school_id=NEW.school_id
      AND st.user_id=(SELECT auth.uid())
      AND st.employment_status='active'
    ORDER BY st.created_at
    LIMIT 1;
    NEW.marked_by_staff_id:=v_staff_id;
  END IF;

  NEW.marked_at:=now();
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_attendance_session()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE v_staff_id uuid;
BEGIN
  IF NEW.class_subject_id IS NOT NULL AND NOT EXISTS(
    SELECT 1 FROM public.class_subjects cs
    WHERE cs.school_id=NEW.school_id
      AND cs.id=NEW.class_subject_id
      AND cs.class_id=NEW.class_id
  ) THEN
    RAISE EXCEPTION 'Attendance subject must belong to the selected class.'
      USING ERRCODE='23514';
  END IF;

  IF TG_OP='UPDATE' AND (
    NEW.school_id IS DISTINCT FROM OLD.school_id
    OR NEW.class_id IS DISTINCT FROM OLD.class_id
    OR NEW.class_subject_id IS DISTINCT FROM OLD.class_subject_id
  ) THEN
    RAISE EXCEPTION 'Attendance session school, class and subject are immutable.'
      USING ERRCODE='42501';
  END IF;

  IF (SELECT auth.uid()) IS NOT NULL THEN
    SELECT st.id INTO v_staff_id
    FROM public.staff_members st
    WHERE st.school_id=NEW.school_id
      AND st.user_id=(SELECT auth.uid())
      AND st.employment_status='active'
    ORDER BY st.created_at
    LIMIT 1;
    NEW.taken_by_staff_id:=v_staff_id;
  END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_confirmed_payment_update()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
BEGIN
  IF (SELECT auth.uid()) IS NOT NULL THEN
    IF NEW.payment_provider IN ('selcom','snippe')
       OR (TG_OP='UPDATE' AND OLD.payment_provider IN ('selcom','snippe')) THEN
      RAISE EXCEPTION 'Gateway payment creation and status changes must be performed by the trusted server/webhook.'
        USING ERRCODE='42501';
    END IF;
  END IF;

  IF TG_OP='UPDATE' THEN
    IF OLD.payment_status='confirmed' THEN
      IF NEW.school_id IS DISTINCT FROM OLD.school_id
         OR NEW.student_id IS DISTINCT FROM OLD.student_id
         OR NEW.amount IS DISTINCT FROM OLD.amount
         OR NEW.currency_code IS DISTINCT FROM OLD.currency_code
         OR NEW.payment_method IS DISTINCT FROM OLD.payment_method
         OR NEW.payment_provider IS DISTINCT FROM OLD.payment_provider
         OR NEW.payment_number IS DISTINCT FROM OLD.payment_number THEN
        RAISE EXCEPTION 'Core payment details are immutable after confirmation.'
          USING ERRCODE='55000';
      END IF;
    END IF;

    IF NEW.payment_status IN ('failed','reversed','refunded')
       AND EXISTS(
         SELECT 1 FROM public.payment_allocations pa
         WHERE pa.school_id=OLD.school_id AND pa.payment_id=OLD.id
       ) THEN
      RAISE EXCEPTION 'Payment allocations must be reversed before changing a payment to failed, reversed or refunded.'
        USING ERRCODE='55000';
    END IF;
  END IF;

  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_cross_provider_checkout()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_lock_key bigint;
BEGIN
  IF NEW.status NOT IN ('creating','pending','active','reconciliation_required') THEN
    RETURN NEW;
  END IF;

  v_lock_key:=hashtextextended(NEW.school_id::text||':'||NEW.invoice_id::text,0);
  PERFORM pg_advisory_xact_lock(v_lock_key);

  IF TG_TABLE_NAME='snippe_checkout_intents' THEN
    IF EXISTS(
      SELECT 1 FROM public.selcom_checkout_intents s
      WHERE s.school_id=NEW.school_id AND s.invoice_id=NEW.invoice_id
        AND s.status IN ('creating','pending','reconciliation_required')
    ) THEN
      RAISE EXCEPTION 'Another payment gateway checkout is already in progress for this invoice.'
        USING ERRCODE='23505';
    END IF;
  ELSE
    IF EXISTS(
      SELECT 1 FROM public.snippe_checkout_intents s
      WHERE s.school_id=NEW.school_id AND s.invoice_id=NEW.invoice_id
        AND s.status IN ('creating','pending','active','reconciliation_required')
    ) THEN
      RAISE EXCEPTION 'Another payment gateway checkout is already in progress for this invoice.'
        USING ERRCODE='23505';
    END IF;
  END IF;

  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_fee_plan_consistency()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE v_class_year uuid;
BEGIN
  IF NEW.class_id IS NOT NULL THEN
    SELECT c.academic_year_id INTO v_class_year
    FROM public.classes c
    WHERE c.school_id=NEW.school_id AND c.id=NEW.class_id;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Fee plan class does not exist in this school.'
        USING ERRCODE='23503';
    END IF;
    IF v_class_year IS DISTINCT FROM NEW.academic_year_id THEN
      RAISE EXCEPTION 'Fee plan academic year must match its class academic year.'
        USING ERRCODE='23514';
    END IF;
  END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_invoice_fee_plan_consistency()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_plan_year uuid;
  v_plan_currency text;
BEGIN
  IF NEW.fee_plan_id IS NOT NULL THEN
    SELECT fp.academic_year_id,fp.currency_code
    INTO v_plan_year,v_plan_currency
    FROM public.fee_plans fp
    WHERE fp.school_id=NEW.school_id AND fp.id=NEW.fee_plan_id;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Fee plan does not exist in this school.'
        USING ERRCODE='23503';
    END IF;

    IF v_plan_year IS DISTINCT FROM NEW.academic_year_id THEN
      RAISE EXCEPTION 'Invoice academic year must match its fee plan.'
        USING ERRCODE='23514';
    END IF;

    IF v_plan_currency IS DISTINCT FROM NEW.currency_code THEN
      RAISE EXCEPTION 'Invoice currency must match its fee plan currency.'
        USING ERRCODE='23514';
    END IF;
  END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_invoice_item_draft()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE v_status text;
BEGIN
  IF TG_OP IN ('UPDATE','DELETE') THEN
    SELECT i.status INTO v_status
    FROM public.invoices i
    WHERE i.school_id=OLD.school_id AND i.id=OLD.invoice_id;
    IF NOT FOUND OR v_status<>'draft' THEN
      RAISE EXCEPTION 'Invoice items can only be changed while the invoice is in draft.'
        USING ERRCODE='55000';
    END IF;
  END IF;

  IF TG_OP IN ('INSERT','UPDATE') THEN
    SELECT i.status INTO v_status
    FROM public.invoices i
    WHERE i.school_id=NEW.school_id AND i.id=NEW.invoice_id;
    IF NOT FOUND OR v_status<>'draft' THEN
      RAISE EXCEPTION 'Invoice items can only be added to a draft invoice.'
        USING ERRCODE='55000';
    END IF;
  END IF;

  IF TG_OP='DELETE' THEN RETURN OLD; END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_invoice_status_integrity()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_total numeric(14,2);
  v_paid numeric(14,2);
BEGIN
  IF NEW.status IS NOT DISTINCT FROM OLD.status THEN RETURN NEW; END IF;

  IF NEW.status IN ('issued','partially_paid','paid','overdue') THEN
    SELECT COALESCE(sum(ii.line_total),0)::numeric(14,2)
    INTO v_total
    FROM public.invoice_items ii
    WHERE ii.school_id=NEW.school_id AND ii.invoice_id=NEW.id;

    IF v_total<=0 THEN
      RAISE EXCEPTION 'An invoice must contain positive line items before it can be issued.'
        USING ERRCODE='23514';
    END IF;

    SELECT COALESCE(sum(pa.allocated_amount),0)::numeric(14,2)
    INTO v_paid
    FROM public.payment_allocations pa
    JOIN public.payments p ON p.school_id=pa.school_id AND p.id=pa.payment_id
    WHERE pa.school_id=NEW.school_id AND pa.invoice_id=NEW.id
      AND p.payment_status='confirmed';

    IF NEW.status='paid' AND v_paid<v_total THEN
      RAISE EXCEPTION 'An invoice cannot be marked paid until confirmed allocations cover the full invoice total.'
        USING ERRCODE='23514';
    END IF;

    IF NEW.status='partially_paid' AND (v_paid<=0 OR v_paid>=v_total) THEN
      RAISE EXCEPTION 'Partially paid status must match a positive payment balance below the invoice total.'
        USING ERRCODE='23514';
    END IF;

    IF NEW.status='overdue' AND (NEW.due_on IS NULL OR NEW.due_on>=current_date OR v_paid>0) THEN
      RAISE EXCEPTION 'Overdue status requires a past due date and no confirmed allocations.'
        USING ERRCODE='23514';
    END IF;

    IF NEW.status='issued' AND v_paid>0 THEN
      RAISE EXCEPTION 'An invoice with confirmed allocations cannot be returned to issued status.'
        USING ERRCODE='23514';
    END IF;
  END IF;

  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_library_book_inventory()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE v_open_loans integer;
BEGIN
  IF NEW.school_id IS DISTINCT FROM OLD.school_id
     OR NEW.id IS DISTINCT FROM OLD.id THEN
    RAISE EXCEPTION 'Library book school and identity are immutable.'
      USING ERRCODE='42501';
  END IF;

  IF NEW.total_copies<OLD.total_copies THEN
    SELECT count(*) INTO v_open_loans
    FROM public.library_loans l
    WHERE l.school_id=OLD.school_id
      AND l.book_id=OLD.id
      AND l.status IN ('issued','overdue','lost')
      AND l.returned_at IS NULL;

    IF NEW.total_copies<v_open_loans THEN
      RAISE EXCEPTION 'Library copy count cannot be reduced below the number of open loans.'
        USING ERRCODE='23514';
    END IF;
  END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_library_loan_capacity()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_total_copies integer;
  v_open_loans integer;
  v_exclude_id uuid;
BEGIN
  v_exclude_id:=NULL;
  IF TG_OP='UPDATE' THEN
    v_exclude_id:=OLD.id;
    IF NEW.school_id IS DISTINCT FROM OLD.school_id
       OR NEW.book_id IS DISTINCT FROM OLD.book_id
       OR NEW.student_id IS DISTINCT FROM OLD.student_id
       OR NEW.staff_member_id IS DISTINCT FROM OLD.staff_member_id THEN
      RAISE EXCEPTION 'Loan school, book and borrower identity are immutable.'
        USING ERRCODE='42501';
    END IF;
  END IF;

  SELECT b.total_copies INTO v_total_copies
  FROM public.library_books b
  WHERE b.school_id=NEW.school_id AND b.id=NEW.book_id
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Library book does not exist in this school.' USING ERRCODE='23503';
  END IF;

  IF NEW.status IN ('issued','overdue','lost') AND NEW.returned_at IS NULL THEN
    SELECT count(*) INTO v_open_loans
    FROM public.library_loans l
    WHERE l.school_id=NEW.school_id
      AND l.book_id=NEW.book_id
      AND l.status IN ('issued','overdue','lost')
      AND l.returned_at IS NULL
      AND (v_exclude_id IS NULL OR l.id<>v_exclude_id);

    IF v_open_loans>=v_total_copies THEN
      RAISE EXCEPTION 'No available copy remains for this library book.' USING ERRCODE='23514';
    END IF;
  END IF;

  IF NEW.status='returned' AND NEW.returned_at IS NULL THEN
    NEW.returned_at:=now();
  ELSIF NEW.status IN ('issued','overdue','lost') THEN
    NEW.returned_at:=NULL;
  END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_student_enrollment_consistency()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_class_year uuid;
BEGIN
  SELECT c.academic_year_id INTO v_class_year
  FROM public.classes c
  WHERE c.school_id=NEW.school_id AND c.id=NEW.class_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Enrollment class does not exist in this school.'
      USING ERRCODE='23503';
  END IF;

  IF v_class_year IS DISTINCT FROM NEW.academic_year_id THEN
    RAISE EXCEPTION 'Student enrollment academic year must match the selected class academic year.'
      USING ERRCODE='23514';
  END IF;

  IF NEW.exited_on IS NOT NULL AND NEW.exited_on<NEW.enrolled_on THEN
    RAISE EXCEPTION 'Enrollment exit date cannot be earlier than the enrollment date.'
      USING ERRCODE='23514';
  END IF;

  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_student_transport_assignment()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE v_stop_route uuid;
BEGIN
  IF NEW.stop_id IS NOT NULL THEN
    SELECT s.route_id INTO v_stop_route
    FROM public.transport_stops s
    WHERE s.school_id=NEW.school_id AND s.id=NEW.stop_id;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Transport stop does not exist in this school.'
        USING ERRCODE='23503';
    END IF;
    IF v_stop_route IS DISTINCT FROM NEW.route_id THEN
      RAISE EXCEPTION 'Transport stop must belong to the assigned route.'
        USING ERRCODE='23514';
    END IF;
  END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.guard_timetable_slot_consistency()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_class_year uuid;
  v_subject_class uuid;
  v_lock_key bigint;
  v_exclude_id uuid;
BEGIN
  v_exclude_id:=NULL;
  IF TG_OP='UPDATE' THEN v_exclude_id:=OLD.id; END IF;

  SELECT c.academic_year_id INTO v_class_year
  FROM public.classes c
  WHERE c.school_id=NEW.school_id AND c.id=NEW.class_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Timetable class does not exist in this school.' USING ERRCODE='23503';
  END IF;
  IF v_class_year IS DISTINCT FROM NEW.academic_year_id THEN
    RAISE EXCEPTION 'Timetable academic year must match the selected class academic year.' USING ERRCODE='23514';
  END IF;

  SELECT cs.class_id INTO v_subject_class
  FROM public.class_subjects cs
  WHERE cs.school_id=NEW.school_id AND cs.id=NEW.class_subject_id;
  IF NOT FOUND OR v_subject_class IS DISTINCT FROM NEW.class_id THEN
    RAISE EXCEPTION 'Timetable subject assignment must belong to the selected class.' USING ERRCODE='23514';
  END IF;
  IF NEW.ends_at<=NEW.starts_at THEN
    RAISE EXCEPTION 'Timetable end time must be later than start time.' USING ERRCODE='23514';
  END IF;

  v_lock_key:=hashtextextended(
    NEW.school_id::text||':'||NEW.academic_year_id::text||':'||NEW.weekday::text,0
  );
  PERFORM pg_advisory_xact_lock(v_lock_key);

  IF EXISTS(
    SELECT 1 FROM public.timetable_slots ts
    WHERE ts.school_id=NEW.school_id
      AND ts.academic_year_id=NEW.academic_year_id
      AND ts.weekday=NEW.weekday
      AND (v_exclude_id IS NULL OR ts.id<>v_exclude_id)
      AND NEW.starts_at<ts.ends_at
      AND NEW.ends_at>ts.starts_at
      AND (
        ts.class_id=NEW.class_id
        OR (NEW.teacher_staff_id IS NOT NULL AND ts.teacher_staff_id=NEW.teacher_staff_id)
        OR (NEW.room_label IS NOT NULL AND ts.room_label IS NOT NULL
            AND lower(trim(ts.room_label))=lower(trim(NEW.room_label)))
      )
  ) THEN
    RAISE EXCEPTION 'Timetable slot overlaps an existing class, teacher or room booking.'
      USING ERRCODE='23P01';
  END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.handle_new_auth_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  insert into public.profiles(id, full_name, phone)
  values (
    new.id,
    coalesce(nullif(trim(new.raw_user_meta_data ->> 'full_name'), ''), 'User'),
    new.phone
  )
  on conflict (id) do nothing;
  return new;
end;
$function$


CREATE OR REPLACE FUNCTION private.has_district_permission(p_district_id uuid, p_permission_code text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select exists (
    select 1
    from public.district_memberships dm
    join public.role_permissions rp on rp.role_code = dm.role_code
    where dm.district_id = p_district_id
      and dm.user_id = (select auth.uid())
      and dm.status = 'active'
      and rp.permission_code = p_permission_code
  );
$function$


CREATE OR REPLACE FUNCTION private.has_school_permission(p_school_id uuid, p_permission_code text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select
    exists (
      select 1
      from public.school_memberships sm
      join public.membership_roles mr
        on mr.membership_id = sm.id and mr.school_id = sm.school_id
      join public.role_permissions rp on rp.role_code = mr.role_code
      where sm.school_id = p_school_id
        and sm.user_id = (select auth.uid())
        and sm.status = 'active'
        and rp.permission_code = p_permission_code
    )
    or exists (
      select 1
      from public.schools s
      join public.district_memberships dm on dm.district_id = s.district_id
      join public.role_permissions rp on rp.role_code = dm.role_code
      where s.id = p_school_id
        and dm.user_id = (select auth.uid())
        and dm.status = 'active'
        and rp.permission_code = p_permission_code
    );
$function$


CREATE OR REPLACE FUNCTION private.has_workspace_access(p_school_id uuid, p_project_id uuid, p_user_id uuid, p_manage boolean DEFAULT false)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(
  SELECT 1
  FROM public.student_workspace_projects p
  JOIN public.students s
    ON s.school_id=p.school_id AND s.id=p.student_id
  WHERE p.school_id=p_school_id
    AND p.id=p_project_id
    AND (
      (
        s.user_id=p_user_id
        AND private.is_active_school_member(p_school_id,p_user_id)
      )
      OR EXISTS(
        SELECT 1
        FROM public.workspace_collaborators c
        WHERE c.school_id=p.school_id
          AND c.project_id=p.id
          AND c.user_id=p_user_id
          AND private.is_active_school_member(c.school_id,c.user_id)
          AND (
            NOT p_manage
            OR c.access_level IN ('editor','owner')
          )
      )
    )
 );
$function$


CREATE OR REPLACE FUNCTION private.is_active_school_member(p_school_id uuid, p_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(
  SELECT 1 FROM public.school_memberships sm
  WHERE sm.school_id=p_school_id AND sm.user_id=p_user_id AND sm.status='active'
 );
$function$


CREATE OR REPLACE FUNCTION private.is_school_member(p_school_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select exists (
    select 1 from public.school_memberships sm
    where sm.school_id = p_school_id
      and sm.user_id = (select auth.uid())
      and sm.status = 'active'
  );
$function$


CREATE OR REPLACE FUNCTION private.is_school_role(p_school_id uuid, p_role_code text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$ SELECT EXISTS(SELECT 1 FROM public.school_memberships sm JOIN public.membership_roles mr ON mr.membership_id=sm.id AND mr.school_id=sm.school_id WHERE sm.school_id=p_school_id AND sm.user_id=(SELECT auth.uid()) AND sm.status='active' AND mr.role_code=p_role_code); $function$


CREATE OR REPLACE FUNCTION private.is_student_or_guardian(p_school_id uuid, p_student_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select exists (
    select 1 from public.students s
    where s.id = p_student_id
      and s.school_id = p_school_id
      and s.user_id = (select auth.uid())
  )
  or exists (
    select 1
    from public.student_guardians sg
    join public.guardians g
      on g.id = sg.guardian_id and g.school_id = sg.school_id
    where sg.school_id = p_school_id
      and sg.student_id = p_student_id
      and g.user_id = (select auth.uid())
  );
$function$


CREATE OR REPLACE FUNCTION private.is_student_owner(p_school_id uuid, p_student_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$ SELECT EXISTS(SELECT 1 FROM public.students s WHERE s.school_id=p_school_id AND s.id=p_student_id AND s.user_id=(SELECT auth.uid())); $function$


CREATE OR REPLACE FUNCTION private.is_workspace_project_owner(p_school_id uuid, p_project_id uuid, p_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
 SELECT EXISTS(
  SELECT 1
  FROM public.student_workspace_projects p
  JOIN public.students s
    ON s.school_id=p.school_id AND s.id=p.student_id
  WHERE p.school_id=p_school_id
    AND p.id=p_project_id
    AND s.user_id=p_user_id
    AND private.is_active_school_member(p_school_id,p_user_id)
 );
$function$


CREATE OR REPLACE FUNCTION private.payment_gateway_is_ready(p_provider text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT CASE p_provider
    WHEN 'selcom' THEN (
      SELECT count(*)=4
      FROM vault.decrypted_secrets
      WHERE name IN ('selcom_api_key','selcom_api_secret','selcom_vendor_id','selcom_base_url')
        AND decrypted_secret<>''
    )
    WHEN 'snippe' THEN (
      SELECT count(*)=2
      FROM vault.decrypted_secrets
      WHERE name IN ('snippe_api_key','snippe_webhook_secret')
        AND decrypted_secret<>''
    )
    ELSE false
  END;
$function$


CREATE OR REPLACE FUNCTION private.set_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
begin
  new.updated_at := now();
  return new;
end;
$function$


CREATE OR REPLACE FUNCTION private.sync_allocation_invoice_status()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
BEGIN
  IF TG_OP IN ('UPDATE','DELETE') THEN
    PERFORM private.sync_invoice_payment_status(OLD.school_id,OLD.invoice_id);
  END IF;
  IF TG_OP IN ('INSERT','UPDATE') THEN
    PERFORM private.sync_invoice_payment_status(NEW.school_id,NEW.invoice_id);
  END IF;
  IF TG_OP='DELETE' THEN RETURN OLD; END IF;
  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION private.sync_invoice_payment_status(p_school_id uuid, p_invoice_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_status text;
  v_due_on date;
  v_total numeric(14,2);
  v_paid numeric(14,2);
  v_new_status text;
BEGIN
  SELECT i.status,i.due_on INTO v_status,v_due_on
  FROM public.invoices i
  WHERE i.school_id=p_school_id AND i.id=p_invoice_id
  FOR UPDATE;

  IF NOT FOUND OR v_status IN ('draft','void') THEN RETURN; END IF;

  SELECT COALESCE(sum(ii.line_total),0)::numeric(14,2)
  INTO v_total
  FROM public.invoice_items ii
  WHERE ii.school_id=p_school_id AND ii.invoice_id=p_invoice_id;

  SELECT COALESCE(sum(pa.allocated_amount),0)::numeric(14,2)
  INTO v_paid
  FROM public.payment_allocations pa
  JOIN public.payments p ON p.school_id=pa.school_id AND p.id=pa.payment_id
  WHERE pa.school_id=p_school_id AND pa.invoice_id=p_invoice_id
    AND p.payment_status='confirmed';

  IF v_total>0 AND v_paid>=v_total THEN
    v_new_status:='paid';
  ELSIF v_paid>0 THEN
    v_new_status:='partially_paid';
  ELSIF v_due_on IS NOT NULL AND v_due_on<current_date THEN
    v_new_status:='overdue';
  ELSE
    v_new_status:='issued';
  END IF;

  UPDATE public.invoices
  SET status=v_new_status
  WHERE school_id=p_school_id AND id=p_invoice_id
    AND status IS DISTINCT FROM v_new_status;
END;
$function$


CREATE OR REPLACE FUNCTION private.validate_payment_allocation()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_payment public.payments%rowtype;
  v_invoice public.invoices%rowtype;
  v_payment_allocated numeric(14,2);
  v_invoice_allocated numeric(14,2);
  v_invoice_total numeric(14,2);
  v_exclude_allocation_id uuid;
BEGIN
  v_exclude_allocation_id:=NULL;
  IF TG_OP='UPDATE' THEN
    v_exclude_allocation_id:=OLD.id;
  END IF;

  SELECT p.* INTO v_payment
  FROM public.payments p
  WHERE p.school_id=NEW.school_id AND p.id=NEW.payment_id
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Payment does not exist in this school.' USING ERRCODE='23503';
  END IF;

  SELECT i.* INTO v_invoice
  FROM public.invoices i
  WHERE i.school_id=NEW.school_id AND i.id=NEW.invoice_id
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invoice does not exist in this school.' USING ERRCODE='23503';
  END IF;

  IF v_payment.student_id<>v_invoice.student_id THEN
    RAISE EXCEPTION 'A payment can only be allocated to an invoice belonging to the same student.' USING ERRCODE='23514';
  END IF;
  IF v_payment.currency_code<>v_invoice.currency_code THEN
    RAISE EXCEPTION 'Payment and invoice currencies must match.' USING ERRCODE='23514';
  END IF;
  IF v_payment.payment_status<>'confirmed' THEN
    RAISE EXCEPTION 'Only confirmed payments can be allocated to invoices.' USING ERRCODE='23514';
  END IF;
  IF v_invoice.status NOT IN ('issued','partially_paid','overdue') THEN
    RAISE EXCEPTION 'Only issued or outstanding invoices can receive allocations.' USING ERRCODE='23514';
  END IF;

  SELECT COALESCE(sum(ii.line_total),0)::numeric(14,2)
  INTO v_invoice_total
  FROM public.invoice_items ii
  WHERE ii.school_id=NEW.school_id AND ii.invoice_id=NEW.invoice_id;
  IF v_invoice_total<=0 THEN
    RAISE EXCEPTION 'An invoice must contain positive line items before payment can be allocated.' USING ERRCODE='23514';
  END IF;

  SELECT COALESCE(sum(pa.allocated_amount),0)::numeric(14,2)
  INTO v_payment_allocated
  FROM public.payment_allocations pa
  WHERE pa.school_id=NEW.school_id AND pa.payment_id=NEW.payment_id
    AND (v_exclude_allocation_id IS NULL OR pa.id<>v_exclude_allocation_id);
  IF v_payment_allocated+NEW.allocated_amount>v_payment.amount THEN
    RAISE EXCEPTION 'Total allocations cannot exceed the confirmed payment amount.' USING ERRCODE='23514';
  END IF;

  SELECT COALESCE(sum(pa.allocated_amount),0)::numeric(14,2)
  INTO v_invoice_allocated
  FROM public.payment_allocations pa
  WHERE pa.school_id=NEW.school_id AND pa.invoice_id=NEW.invoice_id
    AND (v_exclude_allocation_id IS NULL OR pa.id<>v_exclude_allocation_id);
  IF v_invoice_allocated+NEW.allocated_amount>v_invoice_total THEN
    RAISE EXCEPTION 'Total allocations cannot exceed the invoice total.' USING ERRCODE='23514';
  END IF;

  RETURN NEW;
END;
$function$


CREATE OR REPLACE FUNCTION public.accept_school_invitation(p_token text)
 RETURNS uuid
 LANGUAGE sql
 SET search_path TO ''
AS $function$
  SELECT private.accept_school_invitation_impl(p_token);
$function$


CREATE OR REPLACE FUNCTION public.bootstrap_school(p_name text, p_slug text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE sql
 SET search_path TO ''
AS $function$
  SELECT private.bootstrap_school_impl(p_name,p_slug);
$function$


CREATE OR REPLACE FUNCTION public.get_active_school_payment_gateway(p_school_id uuid)
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT active_provider
  FROM private.school_payment_gateway_settings
  WHERE school_id=p_school_id;
$function$


CREATE OR REPLACE FUNCTION public.get_school_payment_gateway_settings(p_school_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE
 SET search_path TO ''
AS $function$
DECLARE
  v_active text;
  v_selcom_ready boolean;
  v_snippe_ready boolean;
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN
    RAISE EXCEPTION 'Authentication is required.' USING ERRCODE='42501';
  END IF;

  IF NOT private.has_school_permission(p_school_id,'gateways.manage')
     AND NOT private.has_school_permission(p_school_id,'finance.read') THEN
    RAISE EXCEPTION 'You are not allowed to view this school payment gateway configuration.'
      USING ERRCODE='42501';
  END IF;

  SELECT active_provider INTO v_active
  FROM private.school_payment_gateway_settings
  WHERE school_id=p_school_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Payment gateway settings have not been initialized for this school.'
      USING ERRCODE='55000';
  END IF;

  SELECT private.payment_gateway_is_ready('selcom'),
         private.payment_gateway_is_ready('snippe')
  INTO v_selcom_ready,v_snippe_ready;

  RETURN jsonb_build_object(
    'school_id',p_school_id,
    'active_provider',v_active,
    'selection_scope','school',
    'single_active_provider',true,
    'providers',jsonb_build_array(
      jsonb_build_object(
        'code','selcom','name','Selcom Pesa',
        'configured',v_selcom_ready,
        'selected',v_active='selcom',
        'available',v_selcom_ready
      ),
      jsonb_build_object(
        'code','snippe','name','Snippe Pay',
        'configured',v_snippe_ready,
        'selected',v_active='snippe',
        'available',v_snippe_ready
      )
    )
  );
END;
$function$


CREATE OR REPLACE FUNCTION public.platform_manage_payment_gateway_secrets(p_secrets jsonb DEFAULT NULL::jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  item record;
  existing_id uuid;
  allowed_names text[] := array[
    'selcom_api_key','selcom_api_secret','selcom_vendor_id','selcom_base_url',
    'snippe_api_key','snippe_webhook_secret'
  ];
  readiness jsonb;
begin
  -- Authorization is enforced by EXECUTE grants: service_role only.
  -- The function is SECURITY DEFINER solely to write/read the private Vault schema.
  if p_secrets is not null then
    if jsonb_typeof(p_secrets) <> 'object' then
      raise exception 'Secrets payload must be an object';
    end if;

    for item in
      select key, value
      from jsonb_each(p_secrets)
    loop
      if not (item.key = any(allowed_names)) then
        raise exception 'Unsupported credential field';
      end if;
      if jsonb_typeof(item.value) <> 'string' then
        raise exception 'Credential values must be strings';
      end if;
      if item.value #>> '{}' is null or length(btrim(item.value #>> '{}')) = 0 then
        continue;
      end if;
      if length(item.value #>> '{}') > 4096 then
        raise exception 'Credential value is too long';
      end if;
      if item.key = 'selcom_base_url' and item.value #>> '{}' !~ '^https://[A-Za-z0-9.-]+(:[0-9]{1,5})?(/.*)?$' then
        raise exception 'Selcom base URL must be a valid HTTPS URL';
      end if;

      select id into existing_id
      from vault.secrets
      where name = item.key
      limit 1;

      if existing_id is null then
        perform vault.create_secret(
          item.value #>> '{}',
          item.key,
          'PLUS OS payment gateway credential'
        );
      else
        perform vault.update_secret(
          existing_id,
          item.value #>> '{}',
          item.key,
          'PLUS OS payment gateway credential'
        );
      end if;
      existing_id := null;
    end loop;
  end if;

  select jsonb_build_object(
    'selcom', (
      select count(*) = 4
      from vault.decrypted_secrets
      where name in ('selcom_api_key','selcom_api_secret','selcom_vendor_id','selcom_base_url')
        and decrypted_secret <> ''
    ),
    'snippe', (
      select count(*) = 2
      from vault.decrypted_secrets
      where name in ('snippe_api_key','snippe_webhook_secret')
        and decrypted_secret <> ''
    )
  ) into readiness;

  return readiness;
end;
$function$


CREATE OR REPLACE FUNCTION public.selcom_get_gateway_config()
 RETURNS jsonb
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT jsonb_build_object(
    'api_key',(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name='selcom_api_key' LIMIT 1),
    'api_secret',(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name='selcom_api_secret' LIMIT 1),
    'vendor_id',(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name='selcom_vendor_id' LIMIT 1),
    'base_url',(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name='selcom_base_url' LIMIT 1),
    'digest_method',coalesce((SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name='selcom_digest_method' LIMIT 1),'HS256'),
    'reconcile_token',(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name='plus_os_selcom_reconcile_token' LIMIT 1),
    'complete',
      (SELECT count(*)=4 FROM vault.decrypted_secrets
       WHERE name IN ('selcom_api_key','selcom_api_secret','selcom_vendor_id','selcom_base_url')
         AND decrypted_secret<>'')
  );
$function$


CREATE OR REPLACE FUNCTION public.selcom_get_invoice_balance(p_invoice_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE
 SET search_path TO ''
AS $function$
DECLARE
  v_invoice public.invoices%rowtype;
  v_student_name text;
  v_total numeric(14,2);
  v_paid numeric(14,2);
  v_outstanding numeric(14,2);
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN
    RAISE EXCEPTION 'Authentication is required.' USING ERRCODE='42501';
  END IF;

  SELECT i.* INTO v_invoice
  FROM public.invoices i
  WHERE i.id=p_invoice_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invoice was not found or is not accessible to this account.'
      USING ERRCODE='42501';
  END IF;

  IF v_invoice.status NOT IN ('issued','partially_paid','overdue') THEN
    RAISE EXCEPTION 'Only issued or outstanding invoices can be paid.'
      USING ERRCODE='55000';
  END IF;

  SELECT COALESCE(sum(ii.line_total),0)::numeric(14,2)
  INTO v_total
  FROM public.invoice_items ii
  WHERE ii.school_id=v_invoice.school_id
    AND ii.invoice_id=v_invoice.id;

  SELECT COALESCE(sum(pa.allocated_amount),0)::numeric(14,2)
  INTO v_paid
  FROM public.payment_allocations pa
  JOIN public.payments p
    ON p.school_id=pa.school_id AND p.id=pa.payment_id
  WHERE pa.school_id=v_invoice.school_id
    AND pa.invoice_id=v_invoice.id
    AND p.payment_status='confirmed';

  v_outstanding:=greatest(v_total-v_paid,0);

  SELECT concat_ws(' ',s.first_name,s.middle_name,s.last_name)
  INTO v_student_name
  FROM public.students s
  WHERE s.school_id=v_invoice.school_id
    AND s.id=v_invoice.student_id;

  IF v_outstanding<=0 THEN
    RAISE EXCEPTION 'This invoice has no outstanding balance.'
      USING ERRCODE='55000';
  END IF;

  IF v_invoice.currency_code<>'TZS' THEN
    RAISE EXCEPTION 'Selcom Pesa checkout currently supports TZS invoices only.'
      USING ERRCODE='22023';
  END IF;

  IF v_outstanding<>trunc(v_outstanding) THEN
    RAISE EXCEPTION 'The outstanding TZS balance must be a whole shilling amount.'
      USING ERRCODE='22023';
  END IF;

  RETURN jsonb_build_object(
    'invoice_id',v_invoice.id,
    'school_id',v_invoice.school_id,
    'student_id',v_invoice.student_id,
    'invoice_number',v_invoice.invoice_number,
    'invoice_status',v_invoice.status,
    'currency_code',v_invoice.currency_code,
    'invoice_total',v_total,
    'paid_amount',v_paid,
    'outstanding_amount',v_outstanding,
    'student_name',v_student_name
  );
END;
$function$


CREATE OR REPLACE FUNCTION public.selcom_reconcile_token_valid(p_candidate text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT p_candidate IS NOT NULL
    AND length(p_candidate)>=32
    AND p_candidate=(SELECT decrypted_secret
       FROM vault.decrypted_secrets
       WHERE name='plus_os_selcom_reconcile_token'
       LIMIT 1);
$function$


CREATE OR REPLACE FUNCTION public.selcom_reconcile_verified_payment(p_order_id text, p_transid text, p_reference text, p_amount numeric, p_currency_code text, p_channel text, p_msisdn_last4 text, p_payload_hash text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_intent public.selcom_checkout_intents%rowtype;
  v_invoice public.invoices%rowtype;
  v_total numeric(14,2);
  v_paid numeric(14,2);
  v_outstanding numeric(14,2);
  v_payment_id uuid;
  v_payment_number text;
  v_event_id text;
BEGIN
  IF nullif(trim(p_order_id),'') IS NULL
     OR nullif(trim(p_transid),'') IS NULL
     OR nullif(trim(p_reference),'') IS NULL
     OR p_amount IS NULL OR p_amount<=0
     OR p_amount<>trunc(p_amount)
     OR p_currency_code<>'TZS'
     OR p_payload_hash !~ '^[0-9a-f]{64}$' THEN
    RAISE EXCEPTION 'Verified Selcom transaction data is incomplete or invalid.'
      USING ERRCODE='22023';
  END IF;

  IF p_msisdn_last4 IS NOT NULL AND p_msisdn_last4 !~ '^[0-9]{4}$' THEN
    RAISE EXCEPTION 'Payer phone suffix is invalid.' USING ERRCODE='22023';
  END IF;

  SELECT ci.* INTO v_intent
  FROM public.selcom_checkout_intents ci
  WHERE ci.order_id=p_order_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No local checkout intent matches this Selcom order.'
      USING ERRCODE='23503';
  END IF;

  IF v_intent.status='completed' THEN
    RETURN jsonb_build_object(
      'ok',true,'duplicate',true,
      'payment_id',v_intent.payment_id,
      'order_id',v_intent.order_id
    );
  END IF;

  IF v_intent.status NOT IN ('creating','pending','reconciliation_required') THEN
    RAISE EXCEPTION 'Checkout intent is not eligible for payment reconciliation.'
      USING ERRCODE='55000';
  END IF;

  IF p_amount<>v_intent.amount
     OR p_currency_code<>v_intent.currency_code THEN
    RAISE EXCEPTION 'Selcom-reported amount or currency does not match the stored checkout intent.'
      USING ERRCODE='23514';
  END IF;

  IF v_intent.selcom_reference IS NOT NULL
     AND v_intent.selcom_reference<>p_reference THEN
    RAISE EXCEPTION 'Selcom reference does not match the previously recorded order reference.'
      USING ERRCODE='23514';
  END IF;

  IF v_intent.selcom_transid IS NOT NULL
     AND v_intent.selcom_transid<>p_transid THEN
    RAISE EXCEPTION 'Selcom transaction ID does not match the previously recorded transaction.'
      USING ERRCODE='23514';
  END IF;

  SELECT i.* INTO v_invoice
  FROM public.invoices i
  WHERE i.school_id=v_intent.school_id
    AND i.id=v_intent.invoice_id
    AND i.student_id=v_intent.student_id
  FOR UPDATE;

  IF NOT FOUND OR v_invoice.status IN ('draft','void','paid') THEN
    RAISE EXCEPTION 'The invoice is no longer eligible to receive this payment.'
      USING ERRCODE='55000';
  END IF;

  SELECT COALESCE(sum(ii.line_total),0)::numeric(14,2)
  INTO v_total
  FROM public.invoice_items ii
  WHERE ii.school_id=v_intent.school_id
    AND ii.invoice_id=v_intent.invoice_id;

  SELECT COALESCE(sum(pa.allocated_amount),0)::numeric(14,2)
  INTO v_paid
  FROM public.payment_allocations pa
  JOIN public.payments p
    ON p.school_id=pa.school_id AND p.id=pa.payment_id
  WHERE pa.school_id=v_intent.school_id
    AND pa.invoice_id=v_intent.invoice_id
    AND p.payment_status='confirmed';

  v_outstanding:=greatest(v_total-v_paid,0);

  IF v_total<=0 OR p_amount>v_outstanding THEN
    RAISE EXCEPTION 'Verified Selcom payment exceeds the current outstanding invoice balance.'
      USING ERRCODE='23514';
  END IF;

  v_payment_number:='SEL-'||substr(
    encode(extensions.digest(convert_to(v_intent.order_id,'UTF8'),'sha256'),'hex'),1,24
  );

  INSERT INTO public.payments(
    school_id,student_id,payment_number,amount,currency_code,
    payment_method,payment_provider,provider_reference,payment_status,
    paid_at,notes
  )
  VALUES(
    v_intent.school_id,v_intent.student_id,v_payment_number,p_amount,'TZS',
    'mobile_money','selcom',p_reference,'confirmed',
    now(),'Selcom Pesa order '||v_intent.order_id
  )
  RETURNING id INTO v_payment_id;

  INSERT INTO public.payment_allocations(
    school_id,payment_id,invoice_id,allocated_amount
  )
  VALUES(
    v_intent.school_id,v_payment_id,v_intent.invoice_id,p_amount
  );

  v_event_id:=v_intent.order_id||':'||p_reference;

  INSERT INTO public.payment_gateway_events(
    school_id,provider,provider_event_id,provider_reference,event_type,
    processing_status,signature_verified,payload_hash,safe_metadata,processed_at
  )
  VALUES(
    v_intent.school_id,'selcom',v_event_id,p_reference,'payment.completed',
    'processed',true,p_payload_hash,
    jsonb_build_object(
      'order_id',v_intent.order_id,
      'transid',p_transid,
      'channel',left(coalesce(p_channel,'unknown'),40),
      'payer_msisdn_last4',p_msisdn_last4,
      'payment_status','COMPLETED',
      'verification_source','signed_callback_and_selcom_order_status_api'
    ),
    now()
  );

  UPDATE public.selcom_checkout_intents
  SET status='completed',
      selcom_reference=p_reference,
      selcom_transid=p_transid,
      selcom_channel=left(coalesce(p_channel,'unknown'),40),
      payer_msisdn_last4=p_msisdn_last4,
      payment_id=v_payment_id,
      safe_metadata=jsonb_build_object(
        'payment_status','COMPLETED',
        'verification_source','signed_callback_and_selcom_order_status_api'
      ),
      error_code=NULL,
      error_message=NULL,
      processed_at=now()
  WHERE id=v_intent.id;

  RETURN jsonb_build_object(
    'ok',true,'duplicate',false,
    'payment_id',v_payment_id,
    'order_id',v_intent.order_id,
    'invoice_id',v_intent.invoice_id
  );
END;
$function$


CREATE OR REPLACE FUNCTION public.set_school_payment_gateway(p_school_id uuid, p_provider text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
DECLARE v_rows integer;
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN
    RAISE EXCEPTION 'Authentication is required.' USING ERRCODE='42501';
  END IF;

  IF p_provider NOT IN ('selcom','snippe') THEN
    RAISE EXCEPTION 'Unsupported payment gateway provider.'
      USING ERRCODE='22023';
  END IF;

  IF NOT private.has_school_permission(p_school_id,'gateways.manage') THEN
    RAISE EXCEPTION 'Only an authorized school owner or administrator can change the active payment gateway.'
      USING ERRCODE='42501';
  END IF;

  IF NOT private.payment_gateway_is_ready(p_provider) THEN
    RAISE EXCEPTION 'This payment gateway has not been configured by PLUS OS platform operations.'
      USING ERRCODE='55000';
  END IF;

  UPDATE private.school_payment_gateway_settings
  SET active_provider=p_provider,
      updated_by=(SELECT auth.uid()),
      updated_at=now()
  WHERE school_id=p_school_id;

  GET DIAGNOSTICS v_rows=ROW_COUNT;
  IF v_rows<>1 THEN
    RAISE EXCEPTION 'Payment gateway settings have not been initialized for this school.'
      USING ERRCODE='55000';
  END IF;

  RETURN public.get_school_payment_gateway_settings(p_school_id);
END;
$function$


CREATE OR REPLACE FUNCTION public.snippe_get_gateway_config()
 RETURNS jsonb
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT jsonb_build_object(
    'api_key',(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name='snippe_api_key' LIMIT 1),
    'webhook_secret',(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name='snippe_webhook_secret' LIMIT 1),
    'base_url','https://api.snippe.sh',
    'complete',private.payment_gateway_is_ready('snippe')
  );
$function$


CREATE OR REPLACE FUNCTION public.snippe_reconcile_verified_payment(p_order_id text, p_reference text, p_external_reference text, p_amount numeric, p_currency_code text, p_channel text, p_payload_hash text, p_provider_event_id text, p_signature_verified boolean)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
DECLARE
  v_intent public.snippe_checkout_intents%rowtype;
  v_invoice public.invoices%rowtype;
  v_total numeric(14,2);
  v_paid numeric(14,2);
  v_outstanding numeric(14,2);
  v_payment_id uuid;
  v_payment_number text;
BEGIN
  IF nullif(trim(p_order_id),'') IS NULL
     OR nullif(trim(p_reference),'') IS NULL
     OR p_amount IS NULL OR p_amount<500 OR p_amount<>trunc(p_amount)
     OR p_currency_code<>'TZS'
     OR p_payload_hash !~ '^[0-9a-f]{64}$'
     OR nullif(trim(p_provider_event_id),'') IS NULL
     OR p_signature_verified IS NULL THEN
    RAISE EXCEPTION 'Verified Snippe transaction data is incomplete or invalid.'
      USING ERRCODE='22023';
  END IF;

  SELECT * INTO v_intent
  FROM public.snippe_checkout_intents
  WHERE order_id=p_order_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No local checkout intent matches this Snippe order.'
      USING ERRCODE='23503';
  END IF;

  IF v_intent.status='completed' THEN
    RETURN jsonb_build_object('ok',true,'duplicate',true,
      'payment_id',v_intent.payment_id,'order_id',v_intent.order_id);
  END IF;

  IF v_intent.status NOT IN ('creating','pending','active','reconciliation_required') THEN
    RAISE EXCEPTION 'Snippe checkout is not eligible for reconciliation.'
      USING ERRCODE='55000';
  END IF;

  IF p_amount<>v_intent.amount OR p_currency_code<>v_intent.currency_code THEN
    RAISE EXCEPTION 'Snippe-reported amount or currency does not match the stored checkout intent.'
      USING ERRCODE='23514';
  END IF;

  IF v_intent.snippe_reference IS NOT NULL AND v_intent.snippe_reference<>p_reference THEN
    RAISE EXCEPTION 'Snippe reference does not match the existing checkout intent.'
      USING ERRCODE='23514';
  END IF;

  SELECT * INTO v_invoice
  FROM public.invoices
  WHERE school_id=v_intent.school_id AND id=v_intent.invoice_id
    AND student_id=v_intent.student_id
  FOR UPDATE;

  IF NOT FOUND OR v_invoice.status IN ('draft','void','paid') THEN
    RAISE EXCEPTION 'Invoice is no longer eligible to receive this payment.'
      USING ERRCODE='55000';
  END IF;

  SELECT COALESCE(sum(line_total),0)::numeric(14,2)
  INTO v_total
  FROM public.invoice_items
  WHERE school_id=v_intent.school_id AND invoice_id=v_intent.invoice_id;

  SELECT COALESCE(sum(pa.allocated_amount),0)::numeric(14,2)
  INTO v_paid
  FROM public.payment_allocations pa
  JOIN public.payments p ON p.school_id=pa.school_id AND p.id=pa.payment_id
  WHERE pa.school_id=v_intent.school_id
    AND pa.invoice_id=v_intent.invoice_id
    AND p.payment_status='confirmed';

  v_outstanding:=greatest(v_total-v_paid,0);
  IF v_total<=0 OR p_amount>v_outstanding THEN
    RAISE EXCEPTION 'Verified Snippe payment exceeds the current outstanding invoice balance.'
      USING ERRCODE='23514';
  END IF;

  v_payment_number:='SNP-'||substr(
    encode(extensions.digest(convert_to(v_intent.order_id||':'||p_reference,'UTF8'),'sha256'),'hex'),1,24
  );

  INSERT INTO public.payments(
    school_id,student_id,payment_number,amount,currency_code,
    payment_method,payment_provider,provider_reference,payment_status,
    paid_at,notes
  )
  VALUES(
    v_intent.school_id,v_intent.student_id,v_payment_number,p_amount,'TZS',
    'mobile_money','snippe',p_reference,'confirmed',now(),
    'Snippe payment order '||v_intent.order_id
  )
  RETURNING id INTO v_payment_id;

  INSERT INTO public.payment_allocations(school_id,payment_id,invoice_id,allocated_amount)
  VALUES(v_intent.school_id,v_payment_id,v_intent.invoice_id,p_amount);

  INSERT INTO public.payment_gateway_events(
    school_id,provider,provider_event_id,provider_reference,event_type,
    processing_status,signature_verified,payload_hash,safe_metadata,processed_at
  )
  VALUES(
    v_intent.school_id,'snippe',p_provider_event_id,p_reference,'payment.completed',
    'processed',p_signature_verified,p_payload_hash,
    jsonb_build_object(
      'order_id',v_intent.order_id,
      'external_reference',left(coalesce(p_external_reference,''),100),
      'channel',left(coalesce(p_channel,'mobile_money'),40),
      'payment_status','completed',
      'verification_source',CASE WHEN p_signature_verified
        THEN 'signed_callback_and_snippe_payment_status_api'
        ELSE 'snippe_payment_status_api_reconciliation' END
    ),now()
  );

  UPDATE public.snippe_checkout_intents
  SET status='completed',
      snippe_reference=p_reference,
      snippe_external_reference=left(coalesce(p_external_reference,''),100),
      snippe_channel=left(coalesce(p_channel,'mobile_money'),40),
      payment_id=v_payment_id,
      safe_metadata=jsonb_build_object(
        'payment_status','completed',
        'verification_source',CASE WHEN p_signature_verified
          THEN 'signed_callback_and_snippe_payment_status_api'
          ELSE 'snippe_payment_status_api_reconciliation' END
      ),
      error_code=NULL,error_message=NULL,processed_at=now()
  WHERE id=v_intent.id;

  RETURN jsonb_build_object('ok',true,'duplicate',false,
    'payment_id',v_payment_id,'order_id',v_intent.order_id,'invoice_id',v_intent.invoice_id);
END;
$function$


CREATE POLICY audit_logs_select_authorized ON private.audit_logs AS permissive FOR SELECT TO authenticated USING (((school_id IS NOT NULL) AND private.has_school_permission(school_id, 'audit.read'::text)));

CREATE POLICY school_gateway_settings_select ON private.school_payment_gateway_settings AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'gateways.manage'::text) OR private.has_school_permission(school_id, 'finance.read'::text)));

CREATE POLICY school_gateway_settings_update ON private.school_payment_gateway_settings AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'gateways.manage'::text)) WITH CHECK ((private.has_school_permission(school_id, 'gateways.manage'::text) AND (updated_by = ( SELECT auth.uid() AS uid)) AND private.payment_gateway_is_ready(active_provider)));

CREATE POLICY academic_years_insert ON public.academic_years AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY academic_years_select ON public.academic_years AS permissive FOR SELECT TO authenticated USING (private.can_access_academic_year(school_id, id));

CREATE POLICY academic_years_update ON public.academic_years AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'academics.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY admission_app_insert ON public.admission_applications AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'admissions.manage'::text));

CREATE POLICY admission_app_select ON public.admission_applications AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'admissions.read'::text));

CREATE POLICY admission_app_update ON public.admission_applications AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'admissions.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'admissions.manage'::text));

CREATE POLICY admission_docs_insert ON public.admission_documents AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'admissions.manage'::text));

CREATE POLICY admission_docs_select ON public.admission_documents AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'admissions.read'::text));

CREATE POLICY admission_docs_update ON public.admission_documents AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'admissions.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'admissions.manage'::text));

CREATE POLICY ai_messages_insert ON public.ai_assistant_messages AS permissive FOR INSERT TO authenticated WITH CHECK (((sender_role = 'user'::text) AND (EXISTS ( SELECT 1
   FROM ai_assistant_sessions s
  WHERE ((s.id = ai_assistant_messages.session_id) AND (s.school_id = ai_assistant_messages.school_id) AND (s.user_id = ( SELECT auth.uid() AS uid)))))));

CREATE POLICY ai_messages_select ON public.ai_assistant_messages AS permissive FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM ai_assistant_sessions s
  WHERE ((s.id = ai_assistant_messages.session_id) AND (s.school_id = ai_assistant_messages.school_id) AND (s.user_id = ( SELECT auth.uid() AS uid))))));

CREATE POLICY ai_sessions_insert ON public.ai_assistant_sessions AS permissive FOR INSERT TO authenticated WITH CHECK (((user_id = ( SELECT auth.uid() AS uid)) AND private.is_school_member(school_id) AND private.has_school_permission(school_id, 'ai.use'::text)));

CREATE POLICY ai_sessions_select ON public.ai_assistant_sessions AS permissive FOR SELECT TO authenticated USING (((user_id = ( SELECT auth.uid() AS uid)) OR private.has_school_permission(school_id, 'ai.audit'::text)));

CREATE POLICY ai_sessions_update ON public.ai_assistant_sessions AS permissive FOR UPDATE TO authenticated USING (((user_id = ( SELECT auth.uid() AS uid)) AND private.is_school_member(school_id))) WITH CHECK (((user_id = ( SELECT auth.uid() AS uid)) AND private.is_school_member(school_id)));

CREATE POLICY ai_usage_select ON public.ai_usage_ledger AS permissive FOR SELECT TO authenticated USING (((user_id = ( SELECT auth.uid() AS uid)) OR private.has_school_permission(school_id, 'ai.audit'::text)));

CREATE POLICY announcements_insert ON public.announcements AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'communications.manage'::text));

CREATE POLICY announcements_select ON public.announcements AS permissive FOR SELECT TO authenticated USING ((private.is_school_member(school_id) OR private.has_school_permission(school_id, 'communications.read'::text)));

CREATE POLICY announcements_update ON public.announcements AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'communications.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'communications.manage'::text));

CREATE POLICY assessment_scores_insert ON public.assessment_scores AS permissive FOR INSERT TO authenticated WITH CHECK (private.can_manage_assessment_student(school_id, assessment_id, student_id));

CREATE POLICY assessment_scores_select ON public.assessment_scores AS permissive FOR SELECT TO authenticated USING (private.can_view_assessment_student(school_id, assessment_id, student_id));

CREATE POLICY assessment_scores_update ON public.assessment_scores AS permissive FOR UPDATE TO authenticated USING (private.can_manage_assessment_student(school_id, assessment_id, student_id)) WITH CHECK (private.can_manage_assessment_student(school_id, assessment_id, student_id));

CREATE POLICY assessments_insert ON public.assessments AS permissive FOR INSERT TO authenticated WITH CHECK ((private.can_manage_class_subject(school_id, class_subject_id, 'assessments.manage'::text) AND ((created_by_staff_id IS NULL) OR (EXISTS ( SELECT 1
   FROM staff_members st
  WHERE ((st.school_id = assessments.school_id) AND (st.id = assessments.created_by_staff_id) AND (st.user_id = ( SELECT auth.uid() AS uid)) AND (st.employment_status = 'active'::text)))))));

CREATE POLICY assessments_select ON public.assessments AS permissive FOR SELECT TO authenticated USING (((private.has_school_permission(school_id, 'assessments.manage'::text) AND private.can_manage_class_subject(school_id, class_subject_id, 'assessments.manage'::text)) OR ((status = ANY (ARRAY['published'::text, 'locked'::text, 'archived'::text])) AND private.has_school_permission(school_id, 'assessments.read'::text) AND private.can_access_class_subject(school_id, class_subject_id))));

CREATE POLICY assessments_update ON public.assessments AS permissive FOR UPDATE TO authenticated USING (private.can_manage_class_subject(school_id, class_subject_id, 'assessments.manage'::text)) WITH CHECK (private.can_manage_class_subject(school_id, class_subject_id, 'assessments.manage'::text));

CREATE POLICY assignment_submissions_insert ON public.assignment_submissions AS permissive FOR INSERT TO authenticated WITH CHECK (private.can_student_submit_assignment(school_id, assignment_id, student_id, attempt_number, status));

CREATE POLICY assignment_submissions_select ON public.assignment_submissions AS permissive FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM assignments a
  WHERE ((a.school_id = assignment_submissions.school_id) AND (a.id = assignment_submissions.assignment_id) AND (private.can_manage_class_subject(a.school_id, a.class_subject_id, 'assignments.manage'::text) OR (private.is_student_or_guardian(assignment_submissions.school_id, assignment_submissions.student_id) AND private.can_access_class_subject(a.school_id, a.class_subject_id)))))));

CREATE POLICY assignment_submissions_update ON public.assignment_submissions AS permissive FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM assignments a
  WHERE ((a.school_id = assignment_submissions.school_id) AND (a.id = assignment_submissions.assignment_id) AND (private.can_manage_class_subject(a.school_id, a.class_subject_id, 'assignments.manage'::text) OR (private.is_student_owner(assignment_submissions.school_id, assignment_submissions.student_id) AND (assignment_submissions.status = ANY (ARRAY['draft'::text, 'resubmission_requested'::text])))))))) WITH CHECK ((private.can_manage_class_subject(school_id, ( SELECT a.class_subject_id
   FROM assignments a
  WHERE ((a.school_id = assignment_submissions.school_id) AND (a.id = assignment_submissions.assignment_id))), 'assignments.manage'::text) OR private.can_student_submit_assignment(school_id, assignment_id, student_id, attempt_number, status)));

CREATE POLICY assignments_insert ON public.assignments AS permissive FOR INSERT TO authenticated WITH CHECK ((private.can_manage_class_subject(school_id, class_subject_id, 'assignments.manage'::text) AND (teacher_staff_id = ( SELECT cs.teacher_staff_id
   FROM class_subjects cs
  WHERE ((cs.school_id = assignments.school_id) AND (cs.id = assignments.class_subject_id))))));

CREATE POLICY assignments_select ON public.assignments AS permissive FOR SELECT TO authenticated USING (((private.has_school_permission(school_id, 'assignments.manage'::text) AND private.can_manage_class_subject(school_id, class_subject_id, 'assignments.manage'::text)) OR ((status = 'published'::text) AND private.has_school_permission(school_id, 'assignments.read'::text) AND private.can_access_class_subject(school_id, class_subject_id))));

CREATE POLICY assignments_update ON public.assignments AS permissive FOR UPDATE TO authenticated USING (private.can_manage_class_subject(school_id, class_subject_id, 'assignments.manage'::text)) WITH CHECK ((private.can_manage_class_subject(school_id, class_subject_id, 'assignments.manage'::text) AND (teacher_staff_id = ( SELECT cs.teacher_staff_id
   FROM class_subjects cs
  WHERE ((cs.school_id = assignments.school_id) AND (cs.id = assignments.class_subject_id))))));

CREATE POLICY attendance_records_insert ON public.attendance_records AS permissive FOR INSERT TO authenticated WITH CHECK ((private.can_manage_attendance_record(school_id, attendance_session_id, student_id) AND ((marked_by_staff_id IS NULL) OR (EXISTS ( SELECT 1
   FROM staff_members st
  WHERE ((st.school_id = attendance_records.school_id) AND (st.id = attendance_records.marked_by_staff_id) AND (st.user_id = ( SELECT auth.uid() AS uid)) AND (st.employment_status = 'active'::text)))))));

CREATE POLICY attendance_records_select ON public.attendance_records AS permissive FOR SELECT TO authenticated USING (private.can_view_attendance_record(school_id, attendance_session_id, student_id));

CREATE POLICY attendance_records_update ON public.attendance_records AS permissive FOR UPDATE TO authenticated USING (private.can_manage_attendance_record(school_id, attendance_session_id, student_id)) WITH CHECK ((private.can_manage_attendance_record(school_id, attendance_session_id, student_id) AND ((marked_by_staff_id IS NULL) OR (EXISTS ( SELECT 1
   FROM staff_members st
  WHERE ((st.school_id = attendance_records.school_id) AND (st.id = attendance_records.marked_by_staff_id) AND (st.user_id = ( SELECT auth.uid() AS uid)) AND (st.employment_status = 'active'::text)))))));

CREATE POLICY attendance_sessions_insert ON public.attendance_sessions AS permissive FOR INSERT TO authenticated WITH CHECK ((private.can_manage_class(school_id, class_id, 'attendance.manage'::text) AND ((class_subject_id IS NULL) OR private.can_manage_class_subject(school_id, class_subject_id, 'attendance.manage'::text)) AND ((taken_by_staff_id IS NULL) OR (EXISTS ( SELECT 1
   FROM staff_members st
  WHERE ((st.school_id = attendance_sessions.school_id) AND (st.id = attendance_sessions.taken_by_staff_id) AND (st.user_id = ( SELECT auth.uid() AS uid)) AND (st.employment_status = 'active'::text)))))));

CREATE POLICY attendance_sessions_select ON public.attendance_sessions AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'attendance.read'::text) AND private.can_access_class(school_id, class_id)));

CREATE POLICY attendance_sessions_update ON public.attendance_sessions AS permissive FOR UPDATE TO authenticated USING ((private.can_manage_class(school_id, class_id, 'attendance.manage'::text) AND ((class_subject_id IS NULL) OR private.can_manage_class_subject(school_id, class_subject_id, 'attendance.manage'::text)))) WITH CHECK ((private.can_manage_class(school_id, class_id, 'attendance.manage'::text) AND ((class_subject_id IS NULL) OR private.can_manage_class_subject(school_id, class_subject_id, 'attendance.manage'::text)) AND ((taken_by_staff_id IS NULL) OR (EXISTS ( SELECT 1
   FROM staff_members st
  WHERE ((st.school_id = attendance_sessions.school_id) AND (st.id = attendance_sessions.taken_by_staff_id) AND (st.user_id = ( SELECT auth.uid() AS uid)) AND (st.employment_status = 'active'::text)))))));

CREATE POLICY class_subjects_insert ON public.class_subjects AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY class_subjects_select ON public.class_subjects AS permissive FOR SELECT TO authenticated USING (((private.has_school_permission(school_id, 'academics.read'::text) OR private.has_school_permission(school_id, 'timetable.read'::text)) AND private.can_access_class_subject(school_id, id)));

CREATE POLICY class_subjects_update ON public.class_subjects AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'academics.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY classes_insert ON public.classes AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY classes_select ON public.classes AS permissive FOR SELECT TO authenticated USING (((private.has_school_permission(school_id, 'academics.read'::text) OR private.has_school_permission(school_id, 'timetable.read'::text)) AND private.can_access_class(school_id, id)));

CREATE POLICY classes_update ON public.classes AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'academics.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY counselling_cases_insert ON public.counselling_cases AS permissive FOR INSERT TO authenticated WITH CHECK ((private.is_school_role(school_id, 'school_owner'::text) OR private.is_school_role(school_id, 'school_admin'::text) OR (private.has_school_permission(school_id, 'counselling.manage'::text) AND (assigned_staff_id IN ( SELECT st.id
   FROM staff_members st
  WHERE ((st.school_id = counselling_cases.school_id) AND (st.user_id = ( SELECT auth.uid() AS uid)) AND (st.employment_status = 'active'::text)))))));

CREATE POLICY counselling_cases_select ON public.counselling_cases AS permissive FOR SELECT TO authenticated USING ((private.is_school_role(school_id, 'school_owner'::text) OR private.is_school_role(school_id, 'school_admin'::text) OR (private.has_school_permission(school_id, 'counselling.read'::text) AND (assigned_staff_id IN ( SELECT st.id
   FROM staff_members st
  WHERE ((st.school_id = counselling_cases.school_id) AND (st.user_id = ( SELECT auth.uid() AS uid)) AND (st.employment_status = 'active'::text)))))));

CREATE POLICY counselling_cases_update ON public.counselling_cases AS permissive FOR UPDATE TO authenticated USING (private.can_manage_counselling_case(school_id, id)) WITH CHECK (private.can_manage_counselling_case(school_id, id));

CREATE POLICY counselling_notes_insert ON public.counselling_notes AS permissive FOR INSERT TO authenticated WITH CHECK (((author_staff_id IN ( SELECT st.id
   FROM staff_members st
  WHERE ((st.school_id = counselling_notes.school_id) AND (st.user_id = ( SELECT auth.uid() AS uid)) AND (st.employment_status = 'active'::text)))) AND private.can_manage_counselling_case(school_id, case_id)));

CREATE POLICY counselling_notes_select ON public.counselling_notes AS permissive FOR SELECT TO authenticated USING (private.can_manage_counselling_case(school_id, case_id));

CREATE POLICY departments_insert ON public.departments AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY departments_select ON public.departments AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'academics.read'::text));

CREATE POLICY departments_update ON public.departments AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'academics.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY discipline_cases_insert ON public.discipline_cases AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'discipline.manage'::text));

CREATE POLICY discipline_cases_select ON public.discipline_cases AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'discipline.read'::text) OR private.has_school_permission(school_id, 'discipline.manage'::text)));

CREATE POLICY discipline_cases_update ON public.discipline_cases AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'discipline.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'discipline.manage'::text));

CREATE POLICY district_memberships_select ON public.district_memberships AS permissive FOR SELECT TO authenticated USING (((user_id = ( SELECT auth.uid() AS uid)) OR private.has_district_permission(district_id, 'district.members.manage'::text)));

CREATE POLICY districts_select ON public.districts AS permissive FOR SELECT TO authenticated USING (private.has_district_permission(id, 'districts.read'::text));

CREATE POLICY documents_insert ON public.documents AS permissive FOR INSERT TO authenticated WITH CHECK ((private.has_school_permission(school_id, 'documents.manage'::text) AND ((uploaded_by IS NULL) OR (uploaded_by = ( SELECT auth.uid() AS uid))) AND ((created_by_membership_id IS NULL) OR (EXISTS ( SELECT 1
   FROM school_memberships sm
  WHERE ((sm.id = documents.created_by_membership_id) AND (sm.school_id = documents.school_id) AND (sm.user_id = ( SELECT auth.uid() AS uid)) AND (sm.status = 'active'::text)))))));

CREATE POLICY documents_select ON public.documents AS permissive FOR SELECT TO authenticated USING (private.can_access_document(id));

CREATE POLICY documents_update ON public.documents AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'documents.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'documents.manage'::text));

CREATE POLICY fee_categories_insert ON public.fee_categories AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY fee_categories_select ON public.fee_categories AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'finance.read'::text));

CREATE POLICY fee_categories_update ON public.fee_categories AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'finance.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY fee_plan_items_insert ON public.fee_plan_items AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY fee_plan_items_select ON public.fee_plan_items AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'finance.read'::text));

CREATE POLICY fee_plan_items_update ON public.fee_plan_items AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'finance.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY fee_plans_insert ON public.fee_plans AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY fee_plans_select ON public.fee_plans AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'finance.read'::text));

CREATE POLICY fee_plans_update ON public.fee_plans AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'finance.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY guardians_insert ON public.guardians AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'guardians.manage'::text));

CREATE POLICY guardians_select ON public.guardians AS permissive FOR SELECT TO authenticated USING (((user_id = ( SELECT auth.uid() AS uid)) OR private.has_school_permission(school_id, 'guardians.read'::text)));

CREATE POLICY guardians_update ON public.guardians AS permissive FOR UPDATE TO authenticated USING (((user_id = ( SELECT auth.uid() AS uid)) OR private.has_school_permission(school_id, 'guardians.manage'::text))) WITH CHECK (((user_id = ( SELECT auth.uid() AS uid)) OR private.has_school_permission(school_id, 'guardians.manage'::text)));

CREATE POLICY invoice_items_insert ON public.invoice_items AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY invoice_items_select ON public.invoice_items AS permissive FOR SELECT TO authenticated USING (private.can_view_invoice(school_id, invoice_id));

CREATE POLICY invoice_items_update ON public.invoice_items AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'finance.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY invoices_insert ON public.invoices AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY invoices_select ON public.invoices AS permissive FOR SELECT TO authenticated USING (private.can_view_invoice(school_id, id));

CREATE POLICY invoices_update ON public.invoices AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'finance.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY learning_resources_insert ON public.learning_resources AS permissive FOR INSERT TO authenticated WITH CHECK ((((access_scope = 'school'::text) AND (class_subject_id IS NULL) AND (private.is_school_role(school_id, 'school_owner'::text) OR private.is_school_role(school_id, 'school_admin'::text) OR private.is_school_role(school_id, 'head_teacher'::text) OR private.is_school_role(school_id, 'academic_master'::text))) OR ((class_subject_id IS NOT NULL) AND private.can_manage_class_subject(school_id, class_subject_id, 'lessons.manage'::text))));

CREATE POLICY learning_resources_select ON public.learning_resources AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'lessons.read'::text) AND (((access_scope = 'school'::text) AND (private.is_school_role(school_id, 'school_owner'::text) OR private.is_school_role(school_id, 'school_admin'::text) OR private.is_school_role(school_id, 'head_teacher'::text) OR private.is_school_role(school_id, 'academic_master'::text))) OR ((access_scope = 'teacher_only'::text) AND private.can_manage_class_subject(school_id, class_subject_id, 'lessons.manage'::text)) OR ((access_scope = ANY (ARRAY['class'::text, 'student'::text])) AND private.can_access_class_subject(school_id, class_subject_id)))));

CREATE POLICY learning_resources_update ON public.learning_resources AS permissive FOR UPDATE TO authenticated USING ((((access_scope = 'school'::text) AND (private.is_school_role(school_id, 'school_owner'::text) OR private.is_school_role(school_id, 'school_admin'::text) OR private.is_school_role(school_id, 'head_teacher'::text) OR private.is_school_role(school_id, 'academic_master'::text))) OR ((class_subject_id IS NOT NULL) AND private.can_manage_class_subject(school_id, class_subject_id, 'lessons.manage'::text)))) WITH CHECK ((((access_scope = 'school'::text) AND (private.is_school_role(school_id, 'school_owner'::text) OR private.is_school_role(school_id, 'school_admin'::text) OR private.is_school_role(school_id, 'head_teacher'::text) OR private.is_school_role(school_id, 'academic_master'::text))) OR ((class_subject_id IS NOT NULL) AND private.can_manage_class_subject(school_id, class_subject_id, 'lessons.manage'::text))));

CREATE POLICY lesson_plans_insert ON public.lesson_plans AS permissive FOR INSERT TO authenticated WITH CHECK ((private.can_manage_class_subject(school_id, class_subject_id, 'lessons.manage'::text) AND (teacher_staff_id = ( SELECT cs.teacher_staff_id
   FROM class_subjects cs
  WHERE ((cs.school_id = lesson_plans.school_id) AND (cs.id = lesson_plans.class_subject_id))))));

CREATE POLICY lesson_plans_select ON public.lesson_plans AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'lessons.read'::text) AND private.can_access_class_subject(school_id, class_subject_id)));

CREATE POLICY lesson_plans_update ON public.lesson_plans AS permissive FOR UPDATE TO authenticated USING (private.can_manage_class_subject(school_id, class_subject_id, 'lessons.manage'::text)) WITH CHECK ((private.can_manage_class_subject(school_id, class_subject_id, 'lessons.manage'::text) AND (teacher_staff_id = ( SELECT cs.teacher_staff_id
   FROM class_subjects cs
  WHERE ((cs.school_id = lesson_plans.school_id) AND (cs.id = lesson_plans.class_subject_id))))));

CREATE POLICY library_books_insert ON public.library_books AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'library.manage'::text));

CREATE POLICY library_books_select ON public.library_books AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'library.read'::text));

CREATE POLICY library_books_update ON public.library_books AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'library.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'library.manage'::text));

CREATE POLICY library_loans_insert ON public.library_loans AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'library.manage'::text));

CREATE POLICY library_loans_select ON public.library_loans AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'library.manage'::text) OR ((student_id IS NOT NULL) AND private.is_student_or_guardian(school_id, student_id))));

CREATE POLICY library_loans_update ON public.library_loans AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'library.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'library.manage'::text));

CREATE POLICY meal_attendance_insert ON public.meal_attendance AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'meals.manage'::text));

CREATE POLICY meal_attendance_select ON public.meal_attendance AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'meals.read'::text) OR private.is_student_or_guardian(school_id, student_id)));

CREATE POLICY meal_attendance_update ON public.meal_attendance AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'meals.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'meals.manage'::text));

CREATE POLICY meal_menus_insert ON public.meal_menus AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'meals.manage'::text));

CREATE POLICY meal_menus_select ON public.meal_menus AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'meals.read'::text));

CREATE POLICY meal_menus_update ON public.meal_menus AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'meals.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'meals.manage'::text));

CREATE POLICY membership_roles_select ON public.membership_roles AS permissive FOR SELECT TO authenticated USING (((EXISTS ( SELECT 1
   FROM school_memberships sm
  WHERE ((sm.id = membership_roles.membership_id) AND (sm.user_id = ( SELECT auth.uid() AS uid)) AND (sm.status = 'active'::text)))) OR private.has_school_permission(school_id, 'members.read'::text)));

CREATE POLICY notifications_select_own ON public.notifications AS permissive FOR SELECT TO authenticated USING ((user_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY notifications_update_own ON public.notifications AS permissive FOR UPDATE TO authenticated USING ((user_id = ( SELECT auth.uid() AS uid))) WITH CHECK ((user_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY payment_allocations_insert ON public.payment_allocations AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY payment_allocations_select ON public.payment_allocations AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'finance.read'::text) OR private.can_view_invoice(school_id, invoice_id)));

CREATE POLICY payment_allocations_update ON public.payment_allocations AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'finance.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY payment_gateway_events_select ON public.payment_gateway_events AS permissive FOR SELECT TO authenticated USING (((school_id IS NOT NULL) AND private.has_school_permission(school_id, 'finance.read'::text)));

CREATE POLICY payments_insert ON public.payments AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY payments_select ON public.payments AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'finance.read'::text) OR private.is_student_or_guardian(school_id, student_id)));

CREATE POLICY payments_update ON public.payments AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'finance.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'finance.manage'::text));

CREATE POLICY permissions_select ON public.permissions AS permissive FOR SELECT TO authenticated USING (true);

CREATE POLICY profiles_select ON public.profiles AS permissive FOR SELECT TO authenticated USING (private.can_view_profile(id));

CREATE POLICY profiles_update_own ON public.profiles AS permissive FOR UPDATE TO authenticated USING ((id = ( SELECT auth.uid() AS uid))) WITH CHECK ((id = ( SELECT auth.uid() AS uid)));

CREATE POLICY role_permissions_select ON public.role_permissions AS permissive FOR SELECT TO authenticated USING (true);

CREATE POLICY roles_select ON public.roles AS permissive FOR SELECT TO authenticated USING (true);

CREATE POLICY school_assets_insert ON public.school_assets AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'assets.manage'::text));

CREATE POLICY school_assets_select ON public.school_assets AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'assets.read'::text));

CREATE POLICY school_assets_update ON public.school_assets AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'assets.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'assets.manage'::text));

CREATE POLICY school_audit_events_select ON public.school_audit_events AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'audit.read'::text));

CREATE POLICY school_invitations_insert ON public.school_invitations AS permissive FOR INSERT TO authenticated WITH CHECK ((private.has_school_permission(school_id, 'members.manage'::text) AND ((role_code <> ALL (ARRAY['school_owner'::text, 'school_admin'::text])) OR private.is_school_role(school_id, 'school_owner'::text)) AND (invited_by = ( SELECT auth.uid() AS uid)) AND (status = 'pending'::text) AND (token_hash IS NOT NULL) AND (expires_at > now())));

CREATE POLICY school_invitations_select ON public.school_invitations AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'members.manage'::text));

CREATE POLICY school_invitations_update ON public.school_invitations AS permissive FOR UPDATE TO authenticated USING ((private.has_school_permission(school_id, 'members.manage'::text) AND (status = 'pending'::text))) WITH CHECK ((private.has_school_permission(school_id, 'members.manage'::text) AND ((role_code <> ALL (ARRAY['school_owner'::text, 'school_admin'::text])) OR private.is_school_role(school_id, 'school_owner'::text)) AND (status = ANY (ARRAY['pending'::text, 'expired'::text, 'revoked'::text]))));

CREATE POLICY school_memberships_select ON public.school_memberships AS permissive FOR SELECT TO authenticated USING (((user_id = ( SELECT auth.uid() AS uid)) OR private.has_school_permission(school_id, 'members.read'::text)));

CREATE POLICY school_message_logs_insert ON public.school_message_logs AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'communications.manage'::text));

CREATE POLICY school_message_logs_select ON public.school_message_logs AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'communications.read'::text) OR private.has_school_permission(school_id, 'communications.manage'::text)));

CREATE POLICY school_settings_select ON public.school_settings AS permissive FOR SELECT TO authenticated USING ((private.is_school_member(school_id) OR private.has_school_permission(school_id, 'schools.read'::text)));

CREATE POLICY school_settings_update ON public.school_settings AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'schools.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'schools.manage'::text));

CREATE POLICY school_subscriptions_select ON public.school_subscriptions AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'subscriptions.read'::text));

CREATE POLICY schools_select ON public.schools AS permissive FOR SELECT TO authenticated USING ((private.is_school_member(id) OR private.has_school_permission(id, 'schools.read'::text)));

CREATE POLICY schools_update ON public.schools AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(id, 'schools.manage'::text)) WITH CHECK (private.has_school_permission(id, 'schools.manage'::text));

CREATE POLICY selcom_checkout_intents_service_role_only ON public.selcom_checkout_intents AS permissive FOR ALL TO service_role USING (true) WITH CHECK (true);

CREATE POLICY snippe_checkout_intents_service_role_only ON public.snippe_checkout_intents AS permissive FOR ALL TO service_role USING (true) WITH CHECK (true);

CREATE POLICY sports_events_insert ON public.sports_events AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'sports.manage'::text));

CREATE POLICY sports_events_select ON public.sports_events AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'sports.read'::text));

CREATE POLICY sports_events_update ON public.sports_events AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'sports.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'sports.manage'::text));

CREATE POLICY sports_members_insert ON public.sports_team_members AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'sports.manage'::text));

CREATE POLICY sports_members_select ON public.sports_team_members AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'sports.read'::text));

CREATE POLICY sports_members_update ON public.sports_team_members AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'sports.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'sports.manage'::text));

CREATE POLICY sports_teams_insert ON public.sports_teams AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'sports.manage'::text));

CREATE POLICY sports_teams_select ON public.sports_teams AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'sports.read'::text));

CREATE POLICY sports_teams_update ON public.sports_teams AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'sports.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'sports.manage'::text));

CREATE POLICY staff_attendance_insert ON public.staff_attendance AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'hr.manage'::text));

CREATE POLICY staff_attendance_select ON public.staff_attendance AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'hr.read'::text) OR (staff_member_id IN ( SELECT staff_members.id
   FROM staff_members
  WHERE ((staff_members.user_id = ( SELECT auth.uid() AS uid)) AND (staff_members.school_id = staff_attendance.school_id))))));

CREATE POLICY staff_attendance_update ON public.staff_attendance AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'hr.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'hr.manage'::text));

CREATE POLICY staff_leave_insert ON public.staff_leave_requests AS permissive FOR INSERT TO authenticated WITH CHECK (((status = 'pending'::text) AND (private.has_school_permission(school_id, 'hr.manage'::text) OR (staff_member_id IN ( SELECT st.id
   FROM staff_members st
  WHERE ((st.school_id = staff_leave_requests.school_id) AND (st.user_id = ( SELECT auth.uid() AS uid)) AND (st.employment_status = ANY (ARRAY['active'::text, 'on_leave'::text]))))))));

CREATE POLICY staff_leave_select ON public.staff_leave_requests AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'hr.read'::text) OR (staff_member_id IN ( SELECT staff_members.id
   FROM staff_members
  WHERE ((staff_members.user_id = ( SELECT auth.uid() AS uid)) AND (staff_members.school_id = staff_leave_requests.school_id))))));

CREATE POLICY staff_leave_update ON public.staff_leave_requests AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'hr.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'hr.manage'::text));

CREATE POLICY staff_members_insert ON public.staff_members AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'staff.manage'::text));

CREATE POLICY staff_members_select ON public.staff_members AS permissive FOR SELECT TO authenticated USING (((user_id = ( SELECT auth.uid() AS uid)) OR private.has_school_permission(school_id, 'staff.read'::text)));

CREATE POLICY staff_members_update ON public.staff_members AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'staff.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'staff.manage'::text));

CREATE POLICY student_enrollments_insert ON public.student_enrollments AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY student_enrollments_select ON public.student_enrollments AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'academics.read'::text) OR private.is_student_or_guardian(school_id, student_id)));

CREATE POLICY student_enrollments_update ON public.student_enrollments AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'academics.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY student_guardians_insert ON public.student_guardians AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'guardians.manage'::text));

CREATE POLICY student_guardians_select ON public.student_guardians AS permissive FOR SELECT TO authenticated USING ((private.can_view_student(school_id, student_id) OR (EXISTS ( SELECT 1
   FROM guardians g
  WHERE ((g.id = student_guardians.guardian_id) AND (g.school_id = student_guardians.school_id) AND (g.user_id = ( SELECT auth.uid() AS uid)))))));

CREATE POLICY student_guardians_update ON public.student_guardians AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'guardians.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'guardians.manage'::text));

CREATE POLICY student_health_insert ON public.student_health_records AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'health.manage'::text));

CREATE POLICY student_health_select ON public.student_health_records AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'health.read'::text) OR private.has_school_permission(school_id, 'health.manage'::text)));

CREATE POLICY student_health_update ON public.student_health_records AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'health.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'health.manage'::text));

CREATE POLICY transport_assignments_insert ON public.student_transport_assignments AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'transport.manage'::text));

CREATE POLICY transport_assignments_select ON public.student_transport_assignments AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'transport.read'::text) OR private.is_student_or_guardian(school_id, student_id)));

CREATE POLICY transport_assignments_update ON public.student_transport_assignments AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'transport.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'transport.manage'::text));

CREATE POLICY workspace_projects_insert ON public.student_workspace_projects AS permissive FOR INSERT TO authenticated WITH CHECK (private.is_student_owner(school_id, student_id));

CREATE POLICY workspace_projects_select ON public.student_workspace_projects AS permissive FOR SELECT TO authenticated USING (private.has_workspace_access(school_id, id, ( SELECT auth.uid() AS uid), false));

CREATE POLICY workspace_projects_update ON public.student_workspace_projects AS permissive FOR UPDATE TO authenticated USING (private.is_student_owner(school_id, student_id)) WITH CHECK (private.is_student_owner(school_id, student_id));

CREATE POLICY students_insert ON public.students AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'students.create'::text));

CREATE POLICY students_select ON public.students AS permissive FOR SELECT TO authenticated USING (private.can_view_student(school_id, id));

CREATE POLICY students_update ON public.students AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'students.update'::text)) WITH CHECK (private.has_school_permission(school_id, 'students.update'::text));

CREATE POLICY subjects_insert ON public.subjects AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY subjects_select ON public.subjects AS permissive FOR SELECT TO authenticated USING (((private.has_school_permission(school_id, 'academics.read'::text) OR private.has_school_permission(school_id, 'timetable.read'::text)) AND private.can_access_subject(school_id, id)));

CREATE POLICY subjects_update ON public.subjects AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'academics.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY subscription_invoices_select ON public.subscription_invoices AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'subscriptions.read'::text));

CREATE POLICY terms_insert ON public.terms AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY terms_select ON public.terms AS permissive FOR SELECT TO authenticated USING ((private.has_school_permission(school_id, 'academics.read'::text) OR (EXISTS ( SELECT 1
   FROM classes c
  WHERE ((c.school_id = terms.school_id) AND (c.academic_year_id = terms.academic_year_id) AND private.can_access_class(c.school_id, c.id))))));

CREATE POLICY terms_update ON public.terms AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'academics.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY timetable_slots_insert ON public.timetable_slots AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY timetable_slots_select ON public.timetable_slots AS permissive FOR SELECT TO authenticated USING (((private.has_school_permission(school_id, 'academics.read'::text) OR private.has_school_permission(school_id, 'timetable.read'::text)) AND private.can_access_class(school_id, class_id)));

CREATE POLICY timetable_slots_update ON public.timetable_slots AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'academics.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'academics.manage'::text));

CREATE POLICY transport_routes_insert ON public.transport_routes AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'transport.manage'::text));

CREATE POLICY transport_routes_select ON public.transport_routes AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'transport.read'::text));

CREATE POLICY transport_routes_update ON public.transport_routes AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'transport.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'transport.manage'::text));

CREATE POLICY transport_stops_insert ON public.transport_stops AS permissive FOR INSERT TO authenticated WITH CHECK (private.has_school_permission(school_id, 'transport.manage'::text));

CREATE POLICY transport_stops_select ON public.transport_stops AS permissive FOR SELECT TO authenticated USING (private.has_school_permission(school_id, 'transport.read'::text));

CREATE POLICY transport_stops_update ON public.transport_stops AS permissive FOR UPDATE TO authenticated USING (private.has_school_permission(school_id, 'transport.manage'::text)) WITH CHECK (private.has_school_permission(school_id, 'transport.manage'::text));

CREATE POLICY workspace_collaborators_delete ON public.workspace_collaborators AS permissive FOR DELETE TO authenticated USING ((private.is_workspace_project_owner(school_id, project_id, ( SELECT auth.uid() AS uid)) OR ((user_id = ( SELECT auth.uid() AS uid)) AND private.is_active_school_member(school_id, ( SELECT auth.uid() AS uid)))));

CREATE POLICY workspace_collaborators_insert ON public.workspace_collaborators AS permissive FOR INSERT TO authenticated WITH CHECK (((access_level = ANY (ARRAY['viewer'::text, 'editor'::text])) AND (user_id <> ( SELECT auth.uid() AS uid)) AND private.is_active_school_member(school_id, user_id) AND private.is_workspace_project_owner(school_id, project_id, ( SELECT auth.uid() AS uid))));

CREATE POLICY workspace_collaborators_select ON public.workspace_collaborators AS permissive FOR SELECT TO authenticated USING (private.has_workspace_access(school_id, project_id, ( SELECT auth.uid() AS uid), false));

CREATE POLICY workspace_collaborators_update ON public.workspace_collaborators AS permissive FOR UPDATE TO authenticated USING (private.is_workspace_project_owner(school_id, project_id, ( SELECT auth.uid() AS uid))) WITH CHECK (((access_level = ANY (ARRAY['viewer'::text, 'editor'::text])) AND (user_id <> ( SELECT auth.uid() AS uid)) AND private.is_active_school_member(school_id, user_id) AND private.is_workspace_project_owner(school_id, project_id, ( SELECT auth.uid() AS uid))));

CREATE POLICY workspace_files_delete_v2 ON public.workspace_files AS permissive FOR DELETE TO authenticated USING (private.has_workspace_access(school_id, project_id, ( SELECT auth.uid() AS uid), true));

CREATE POLICY workspace_files_insert_v2 ON public.workspace_files AS permissive FOR INSERT TO authenticated WITH CHECK ((((uploaded_by IS NULL) OR (uploaded_by = ( SELECT auth.uid() AS uid))) AND private.has_workspace_access(school_id, project_id, ( SELECT auth.uid() AS uid), true)));

CREATE POLICY workspace_files_select_v2 ON public.workspace_files AS permissive FOR SELECT TO authenticated USING (private.has_workspace_access(school_id, project_id, ( SELECT auth.uid() AS uid), false));

CREATE POLICY workspace_files_update_v2 ON public.workspace_files AS permissive FOR UPDATE TO authenticated USING (private.has_workspace_access(school_id, project_id, ( SELECT auth.uid() AS uid), true)) WITH CHECK ((((uploaded_by IS NULL) OR (uploaded_by = ( SELECT auth.uid() AS uid))) AND private.has_workspace_access(school_id, project_id, ( SELECT auth.uid() AS uid), true)));

CREATE TRIGGER school_payment_gateway_settings_audit AFTER UPDATE OF active_provider ON private.school_payment_gateway_settings FOR EACH ROW EXECUTE FUNCTION private.audit_school_payment_gateway_change();

CREATE TRIGGER academic_years_set_updated_at BEFORE UPDATE ON academic_years FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER admission_applications_audit_event AFTER INSERT OR DELETE OR UPDATE ON admission_applications FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER admission_applications_set_updated_at BEFORE UPDATE ON admission_applications FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER admission_documents_audit_event AFTER INSERT OR DELETE OR UPDATE ON admission_documents FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER ai_assistant_messages_audit_event AFTER INSERT OR DELETE OR UPDATE ON ai_assistant_messages FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER ai_assistant_sessions_audit_event AFTER INSERT OR DELETE OR UPDATE ON ai_assistant_sessions FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER ai_assistant_sessions_set_updated_at BEFORE UPDATE ON ai_assistant_sessions FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER ai_sessions_guard_identity BEFORE UPDATE ON ai_assistant_sessions FOR EACH ROW EXECUTE FUNCTION private.guard_ai_session_identity();

CREATE TRIGGER ai_usage_ledger_audit_event AFTER INSERT OR DELETE OR UPDATE ON ai_usage_ledger FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER announcements_set_updated_at BEFORE UPDATE ON announcements FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER assessment_scores_audit AFTER INSERT OR DELETE OR UPDATE ON assessment_scores FOR EACH ROW EXECUTE FUNCTION private.capture_audit_log();

CREATE TRIGGER assessment_scores_guard_integrity BEFORE INSERT OR UPDATE ON assessment_scores FOR EACH ROW EXECUTE FUNCTION private.guard_assessment_score();

CREATE TRIGGER assessment_scores_set_updated_at BEFORE UPDATE ON assessment_scores FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER assessments_audit AFTER INSERT OR DELETE OR UPDATE ON assessments FOR EACH ROW EXECUTE FUNCTION private.capture_audit_log();

CREATE TRIGGER assessments_guard_integrity BEFORE UPDATE ON assessments FOR EACH ROW EXECUTE FUNCTION private.guard_assessment_update();

CREATE TRIGGER assessments_set_updated_at BEFORE UPDATE ON assessments FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER assignment_submissions_audit_event AFTER INSERT OR DELETE OR UPDATE ON assignment_submissions FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER assignment_submissions_guard_integrity BEFORE INSERT OR UPDATE ON assignment_submissions FOR EACH ROW EXECUTE FUNCTION private.guard_assignment_submission();

CREATE TRIGGER assignment_submissions_set_updated_at BEFORE UPDATE ON assignment_submissions FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER assignments_audit_event AFTER INSERT OR DELETE OR UPDATE ON assignments FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER assignments_set_updated_at BEFORE UPDATE ON assignments FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER attendance_audit AFTER INSERT OR DELETE OR UPDATE ON attendance_records FOR EACH ROW EXECUTE FUNCTION private.capture_audit_log();

CREATE TRIGGER attendance_records_guard_integrity BEFORE INSERT OR UPDATE ON attendance_records FOR EACH ROW EXECUTE FUNCTION private.guard_attendance_record();

CREATE TRIGGER attendance_records_set_updated_at BEFORE UPDATE ON attendance_records FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER attendance_sessions_guard_integrity BEFORE INSERT OR UPDATE ON attendance_sessions FOR EACH ROW EXECUTE FUNCTION private.guard_attendance_session();

CREATE TRIGGER attendance_sessions_set_updated_at BEFORE UPDATE ON attendance_sessions FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER class_subjects_set_updated_at BEFORE UPDATE ON class_subjects FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER classes_set_updated_at BEFORE UPDATE ON classes FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER counselling_cases_audit_event AFTER INSERT OR DELETE OR UPDATE ON counselling_cases FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER counselling_cases_set_updated_at BEFORE UPDATE ON counselling_cases FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER counselling_notes_audit_event AFTER INSERT OR DELETE OR UPDATE ON counselling_notes FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER departments_set_updated_at BEFORE UPDATE ON departments FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER discipline_cases_audit_event AFTER INSERT OR DELETE OR UPDATE ON discipline_cases FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER discipline_cases_set_updated_at BEFORE UPDATE ON discipline_cases FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER districts_set_updated_at BEFORE UPDATE ON districts FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER documents_audit AFTER INSERT OR DELETE OR UPDATE ON documents FOR EACH ROW EXECUTE FUNCTION private.capture_audit_log();

CREATE TRIGGER documents_set_updated_at BEFORE UPDATE ON documents FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER fee_categories_set_updated_at BEFORE UPDATE ON fee_categories FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER fee_plan_items_set_updated_at BEFORE UPDATE ON fee_plan_items FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER fee_plans_guard_consistency BEFORE INSERT OR UPDATE ON fee_plans FOR EACH ROW EXECUTE FUNCTION private.guard_fee_plan_consistency();

CREATE TRIGGER fee_plans_set_updated_at BEFORE UPDATE ON fee_plans FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER guardians_audit AFTER INSERT OR DELETE OR UPDATE ON guardians FOR EACH ROW EXECUTE FUNCTION private.capture_audit_log();

CREATE TRIGGER guardians_set_updated_at BEFORE UPDATE ON guardians FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER invoice_items_audit_event AFTER INSERT OR DELETE OR UPDATE ON invoice_items FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER invoice_items_guard_draft BEFORE INSERT OR DELETE OR UPDATE ON invoice_items FOR EACH ROW EXECUTE FUNCTION private.guard_invoice_item_draft();

CREATE TRIGGER invoices_audit AFTER INSERT OR DELETE OR UPDATE ON invoices FOR EACH ROW EXECUTE FUNCTION private.capture_audit_log();

CREATE TRIGGER invoices_guard_fee_plan_consistency BEFORE INSERT OR UPDATE ON invoices FOR EACH ROW EXECUTE FUNCTION private.guard_invoice_fee_plan_consistency();

CREATE TRIGGER invoices_guard_status_integrity BEFORE UPDATE OF status ON invoices FOR EACH ROW EXECUTE FUNCTION private.guard_invoice_status_integrity();

CREATE TRIGGER invoices_set_updated_at BEFORE UPDATE ON invoices FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER learning_resources_audit_event AFTER INSERT OR DELETE OR UPDATE ON learning_resources FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER learning_resources_set_updated_at BEFORE UPDATE ON learning_resources FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER lesson_plans_audit_event AFTER INSERT OR DELETE OR UPDATE ON lesson_plans FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER lesson_plans_set_updated_at BEFORE UPDATE ON lesson_plans FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER library_books_audit_event AFTER INSERT OR DELETE OR UPDATE ON library_books FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER library_books_guard_inventory BEFORE UPDATE ON library_books FOR EACH ROW EXECUTE FUNCTION private.guard_library_book_inventory();

CREATE TRIGGER library_books_set_updated_at BEFORE UPDATE ON library_books FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER library_loans_audit_event AFTER INSERT OR DELETE OR UPDATE ON library_loans FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER library_loans_guard_capacity BEFORE INSERT OR UPDATE ON library_loans FOR EACH ROW EXECUTE FUNCTION private.guard_library_loan_capacity();

CREATE TRIGGER meal_attendance_audit_event AFTER INSERT OR DELETE OR UPDATE ON meal_attendance FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER meal_menus_audit_event AFTER INSERT OR DELETE OR UPDATE ON meal_menus FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER payment_allocations_audit_event AFTER INSERT OR DELETE OR UPDATE ON payment_allocations FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER payment_allocations_sync_invoice AFTER INSERT OR DELETE OR UPDATE ON payment_allocations FOR EACH ROW EXECUTE FUNCTION private.sync_allocation_invoice_status();

CREATE TRIGGER payment_allocations_validate BEFORE INSERT OR UPDATE ON payment_allocations FOR EACH ROW EXECUTE FUNCTION private.validate_payment_allocation();

CREATE TRIGGER payments_audit AFTER INSERT OR DELETE OR UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION private.capture_audit_log();

CREATE TRIGGER payments_guard_confirmed_update BEFORE INSERT OR UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION private.guard_confirmed_payment_update();

CREATE TRIGGER payments_set_updated_at BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER profiles_set_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER school_assets_audit_event AFTER INSERT OR DELETE OR UPDATE ON school_assets FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER school_assets_set_updated_at BEFORE UPDATE ON school_assets FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER school_invitations_set_updated_at BEFORE UPDATE ON school_invitations FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER memberships_audit AFTER INSERT OR DELETE OR UPDATE ON school_memberships FOR EACH ROW EXECUTE FUNCTION private.capture_audit_log();

CREATE TRIGGER school_message_logs_audit_event AFTER INSERT OR DELETE OR UPDATE ON school_message_logs FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER school_settings_set_updated_at BEFORE UPDATE ON school_settings FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER school_subscriptions_audit_event AFTER INSERT OR DELETE OR UPDATE ON school_subscriptions FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER school_subscriptions_set_updated_at BEFORE UPDATE ON school_subscriptions FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER schools_audit AFTER INSERT OR DELETE OR UPDATE ON schools FOR EACH ROW EXECUTE FUNCTION private.capture_audit_log();

CREATE TRIGGER schools_bootstrap_payment_gateway_setting AFTER INSERT ON schools FOR EACH ROW EXECUTE FUNCTION private.bootstrap_school_payment_gateway_setting();

CREATE TRIGGER schools_set_updated_at BEFORE UPDATE ON schools FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER selcom_checkout_intents_audit_event AFTER INSERT OR DELETE OR UPDATE ON selcom_checkout_intents FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER selcom_checkout_intents_cross_provider_guard BEFORE INSERT OR UPDATE ON selcom_checkout_intents FOR EACH ROW EXECUTE FUNCTION private.guard_cross_provider_checkout();

CREATE TRIGGER selcom_checkout_intents_set_updated_at BEFORE UPDATE ON selcom_checkout_intents FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER snippe_checkout_intents_audit_event AFTER INSERT OR DELETE OR UPDATE ON snippe_checkout_intents FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER snippe_checkout_intents_cross_provider_guard BEFORE INSERT OR UPDATE ON snippe_checkout_intents FOR EACH ROW EXECUTE FUNCTION private.guard_cross_provider_checkout();

CREATE TRIGGER snippe_checkout_intents_set_updated_at BEFORE UPDATE ON snippe_checkout_intents FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER sports_events_audit_event AFTER INSERT OR DELETE OR UPDATE ON sports_events FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER sports_events_set_updated_at BEFORE UPDATE ON sports_events FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER sports_team_members_audit_event AFTER INSERT OR DELETE OR UPDATE ON sports_team_members FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER sports_teams_audit_event AFTER INSERT OR DELETE OR UPDATE ON sports_teams FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER sports_teams_set_updated_at BEFORE UPDATE ON sports_teams FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER staff_attendance_audit_event AFTER INSERT OR DELETE OR UPDATE ON staff_attendance FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER staff_leave_requests_audit_event AFTER INSERT OR DELETE OR UPDATE ON staff_leave_requests FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER staff_leave_requests_set_updated_at BEFORE UPDATE ON staff_leave_requests FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER staff_audit AFTER INSERT OR DELETE OR UPDATE ON staff_members FOR EACH ROW EXECUTE FUNCTION private.capture_audit_log();

CREATE TRIGGER staff_members_set_updated_at BEFORE UPDATE ON staff_members FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER student_enrollments_guard_consistency BEFORE INSERT OR UPDATE ON student_enrollments FOR EACH ROW EXECUTE FUNCTION private.guard_student_enrollment_consistency();

CREATE TRIGGER student_enrollments_set_updated_at BEFORE UPDATE ON student_enrollments FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER student_health_records_audit_event AFTER INSERT OR DELETE OR UPDATE ON student_health_records FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER student_transport_assignments_audit_event AFTER INSERT OR DELETE OR UPDATE ON student_transport_assignments FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER student_transport_assignments_guard_consistency BEFORE INSERT OR UPDATE ON student_transport_assignments FOR EACH ROW EXECUTE FUNCTION private.guard_student_transport_assignment();

CREATE TRIGGER student_workspace_projects_audit_event AFTER INSERT OR DELETE OR UPDATE ON student_workspace_projects FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER student_workspace_projects_set_updated_at BEFORE UPDATE ON student_workspace_projects FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER students_audit AFTER INSERT OR DELETE OR UPDATE ON students FOR EACH ROW EXECUTE FUNCTION private.capture_audit_log();

CREATE TRIGGER students_set_updated_at BEFORE UPDATE ON students FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER subjects_set_updated_at BEFORE UPDATE ON subjects FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER subscription_invoices_audit_event AFTER INSERT OR DELETE OR UPDATE ON subscription_invoices FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER terms_set_updated_at BEFORE UPDATE ON terms FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER timetable_slots_guard_consistency BEFORE INSERT OR UPDATE ON timetable_slots FOR EACH ROW EXECUTE FUNCTION private.guard_timetable_slot_consistency();

CREATE TRIGGER timetable_slots_set_updated_at BEFORE UPDATE ON timetable_slots FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER transport_routes_audit_event AFTER INSERT OR DELETE OR UPDATE ON transport_routes FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER transport_routes_set_updated_at BEFORE UPDATE ON transport_routes FOR EACH ROW EXECUTE FUNCTION private.set_updated_at();

CREATE TRIGGER transport_stops_audit_event AFTER INSERT OR DELETE OR UPDATE ON transport_stops FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER workspace_collaborators_audit_event AFTER INSERT OR DELETE OR UPDATE ON workspace_collaborators FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();

CREATE TRIGGER workspace_files_audit_event AFTER INSERT OR DELETE OR UPDATE ON workspace_files FOR EACH ROW EXECUTE FUNCTION private.capture_school_audit_event();
