export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.18"
  }
  public: {
    Tables: {
      academic_years: {
        Row: {
          created_at: string
          ends_on: string
          id: string
          is_current: boolean
          name: string
          school_id: string
          starts_on: string
          status: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          ends_on: string
          id?: string
          is_current?: boolean
          name: string
          school_id: string
          starts_on: string
          status?: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          ends_on?: string
          id?: string
          is_current?: boolean
          name?: string
          school_id?: string
          starts_on?: string
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "academic_years_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      admission_applications: {
        Row: {
          academic_year_id: string
          applicant_first_name: string
          applicant_last_name: string
          application_number: string
          applying_grade: string
          created_at: string
          decision_notes: string | null
          guardian_name: string
          guardian_phone: string
          id: string
          reviewed_at: string | null
          reviewed_by: string | null
          school_id: string
          status: string
          updated_at: string
        }
        Insert: {
          academic_year_id: string
          applicant_first_name: string
          applicant_last_name: string
          application_number: string
          applying_grade: string
          created_at?: string
          decision_notes?: string | null
          guardian_name: string
          guardian_phone: string
          id?: string
          reviewed_at?: string | null
          reviewed_by?: string | null
          school_id: string
          status?: string
          updated_at?: string
        }
        Update: {
          academic_year_id?: string
          applicant_first_name?: string
          applicant_last_name?: string
          application_number?: string
          applying_grade?: string
          created_at?: string
          decision_notes?: string | null
          guardian_name?: string
          guardian_phone?: string
          id?: string
          reviewed_at?: string | null
          reviewed_by?: string | null
          school_id?: string
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "admission_applications_school_id_academic_year_id_fkey"
            columns: ["school_id", "academic_year_id"]
            isOneToOne: false
            referencedRelation: "academic_years"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "admission_applications_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      admission_documents: {
        Row: {
          application_id: string
          created_at: string
          document_type: string
          id: string
          object_path: string
          school_id: string
          uploaded_by: string | null
          verification_status: string
        }
        Insert: {
          application_id: string
          created_at?: string
          document_type: string
          id?: string
          object_path: string
          school_id: string
          uploaded_by?: string | null
          verification_status?: string
        }
        Update: {
          application_id?: string
          created_at?: string
          document_type?: string
          id?: string
          object_path?: string
          school_id?: string
          uploaded_by?: string | null
          verification_status?: string
        }
        Relationships: [
          {
            foreignKeyName: "admission_documents_school_id_application_id_fkey"
            columns: ["school_id", "application_id"]
            isOneToOne: false
            referencedRelation: "admission_applications"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "admission_documents_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      ai_assistant_messages: {
        Row: {
          content: string
          created_at: string
          id: string
          school_id: string
          sender_role: string
          session_id: string
        }
        Insert: {
          content: string
          created_at?: string
          id?: string
          school_id: string
          sender_role: string
          session_id: string
        }
        Update: {
          content?: string
          created_at?: string
          id?: string
          school_id?: string
          sender_role?: string
          session_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "ai_assistant_messages_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "ai_assistant_messages_school_id_session_id_fkey"
            columns: ["school_id", "session_id"]
            isOneToOne: false
            referencedRelation: "ai_assistant_sessions"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      ai_assistant_sessions: {
        Row: {
          context_type: string
          created_at: string
          id: string
          school_id: string
          status: string
          title: string | null
          updated_at: string
          user_id: string
        }
        Insert: {
          context_type?: string
          created_at?: string
          id?: string
          school_id: string
          status?: string
          title?: string | null
          updated_at?: string
          user_id: string
        }
        Update: {
          context_type?: string
          created_at?: string
          id?: string
          school_id?: string
          status?: string
          title?: string | null
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "ai_assistant_sessions_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      ai_usage_ledger: {
        Row: {
          created_at: string
          estimated_cost: number
          id: string
          input_tokens: number
          model: string
          output_tokens: number
          provider: string
          school_id: string
          session_id: string | null
          user_id: string
        }
        Insert: {
          created_at?: string
          estimated_cost?: number
          id?: string
          input_tokens?: number
          model: string
          output_tokens?: number
          provider: string
          school_id: string
          session_id?: string | null
          user_id: string
        }
        Update: {
          created_at?: string
          estimated_cost?: number
          id?: string
          input_tokens?: number
          model?: string
          output_tokens?: number
          provider?: string
          school_id?: string
          session_id?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "ai_usage_ledger_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "ai_usage_ledger_school_id_session_id_fkey"
            columns: ["school_id", "session_id"]
            isOneToOne: false
            referencedRelation: "ai_assistant_sessions"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      announcements: {
        Row: {
          audience: string
          body: string
          created_at: string
          created_by_membership_id: string | null
          expires_at: string | null
          id: string
          publish_at: string | null
          school_id: string
          title: string
          updated_at: string
        }
        Insert: {
          audience?: string
          body: string
          created_at?: string
          created_by_membership_id?: string | null
          expires_at?: string | null
          id?: string
          publish_at?: string | null
          school_id: string
          title: string
          updated_at?: string
        }
        Update: {
          audience?: string
          body?: string
          created_at?: string
          created_by_membership_id?: string | null
          expires_at?: string | null
          id?: string
          publish_at?: string | null
          school_id?: string
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "announcements_created_by_membership_id_school_id_fkey"
            columns: ["created_by_membership_id", "school_id"]
            isOneToOne: false
            referencedRelation: "school_memberships"
            referencedColumns: ["id", "school_id"]
          },
          {
            foreignKeyName: "announcements_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      assessment_scores: {
        Row: {
          assessment_id: string
          created_at: string
          entered_at: string
          entered_by_staff_id: string | null
          id: string
          remarks: string | null
          school_id: string
          score: number
          student_id: string
          updated_at: string
        }
        Insert: {
          assessment_id: string
          created_at?: string
          entered_at?: string
          entered_by_staff_id?: string | null
          id?: string
          remarks?: string | null
          school_id: string
          score: number
          student_id: string
          updated_at?: string
        }
        Update: {
          assessment_id?: string
          created_at?: string
          entered_at?: string
          entered_by_staff_id?: string | null
          id?: string
          remarks?: string | null
          school_id?: string
          score?: number
          student_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "assessment_scores_school_id_assessment_id_fkey"
            columns: ["school_id", "assessment_id"]
            isOneToOne: false
            referencedRelation: "assessments"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "assessment_scores_school_id_entered_by_staff_id_fkey"
            columns: ["school_id", "entered_by_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "assessment_scores_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      assessments: {
        Row: {
          assessment_date: string | null
          assessment_type: string
          class_subject_id: string
          created_at: string
          created_by_staff_id: string | null
          id: string
          max_score: number
          school_id: string
          status: string
          title: string
          updated_at: string
          weight_percentage: number | null
        }
        Insert: {
          assessment_date?: string | null
          assessment_type: string
          class_subject_id: string
          created_at?: string
          created_by_staff_id?: string | null
          id?: string
          max_score: number
          school_id: string
          status?: string
          title: string
          updated_at?: string
          weight_percentage?: number | null
        }
        Update: {
          assessment_date?: string | null
          assessment_type?: string
          class_subject_id?: string
          created_at?: string
          created_by_staff_id?: string | null
          id?: string
          max_score?: number
          school_id?: string
          status?: string
          title?: string
          updated_at?: string
          weight_percentage?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "assessments_school_id_class_subject_id_fkey"
            columns: ["school_id", "class_subject_id"]
            isOneToOne: false
            referencedRelation: "class_subjects"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "assessments_school_id_created_by_staff_id_fkey"
            columns: ["school_id", "created_by_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      assignment_submissions: {
        Row: {
          assignment_id: string
          attempt_number: number
          created_at: string
          feedback: string | null
          graded_at: string | null
          graded_by_staff_id: string | null
          id: string
          object_path: string | null
          school_id: string
          score: number | null
          status: string
          student_id: string
          submission_text: string | null
          submitted_at: string | null
          updated_at: string
        }
        Insert: {
          assignment_id: string
          attempt_number?: number
          created_at?: string
          feedback?: string | null
          graded_at?: string | null
          graded_by_staff_id?: string | null
          id?: string
          object_path?: string | null
          school_id: string
          score?: number | null
          status?: string
          student_id: string
          submission_text?: string | null
          submitted_at?: string | null
          updated_at?: string
        }
        Update: {
          assignment_id?: string
          attempt_number?: number
          created_at?: string
          feedback?: string | null
          graded_at?: string | null
          graded_by_staff_id?: string | null
          id?: string
          object_path?: string | null
          school_id?: string
          score?: number | null
          status?: string
          student_id?: string
          submission_text?: string | null
          submitted_at?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "assignment_submissions_school_id_assignment_id_fkey"
            columns: ["school_id", "assignment_id"]
            isOneToOne: false
            referencedRelation: "assignments"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "assignment_submissions_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "assignment_submissions_school_id_graded_by_staff_id_fkey"
            columns: ["school_id", "graded_by_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "assignment_submissions_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      assignments: {
        Row: {
          allow_late_submission: boolean
          assigned_at: string
          assignment_type: string
          class_subject_id: string
          created_at: string
          due_at: string | null
          id: string
          instructions: string
          max_attempts: number
          max_score: number | null
          school_id: string
          status: string
          teacher_staff_id: string
          title: string
          updated_at: string
        }
        Insert: {
          allow_late_submission?: boolean
          assigned_at?: string
          assignment_type?: string
          class_subject_id: string
          created_at?: string
          due_at?: string | null
          id?: string
          instructions: string
          max_attempts?: number
          max_score?: number | null
          school_id: string
          status?: string
          teacher_staff_id: string
          title: string
          updated_at?: string
        }
        Update: {
          allow_late_submission?: boolean
          assigned_at?: string
          assignment_type?: string
          class_subject_id?: string
          created_at?: string
          due_at?: string | null
          id?: string
          instructions?: string
          max_attempts?: number
          max_score?: number | null
          school_id?: string
          status?: string
          teacher_staff_id?: string
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "assignments_school_id_class_subject_id_fkey"
            columns: ["school_id", "class_subject_id"]
            isOneToOne: false
            referencedRelation: "class_subjects"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "assignments_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "assignments_school_id_teacher_staff_id_fkey"
            columns: ["school_id", "teacher_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      attendance_records: {
        Row: {
          attendance_session_id: string
          attendance_status: string
          created_at: string
          id: string
          marked_at: string
          marked_by_staff_id: string | null
          note: string | null
          school_id: string
          student_id: string
          updated_at: string
        }
        Insert: {
          attendance_session_id: string
          attendance_status: string
          created_at?: string
          id?: string
          marked_at?: string
          marked_by_staff_id?: string | null
          note?: string | null
          school_id: string
          student_id: string
          updated_at?: string
        }
        Update: {
          attendance_session_id?: string
          attendance_status?: string
          created_at?: string
          id?: string
          marked_at?: string
          marked_by_staff_id?: string | null
          note?: string | null
          school_id?: string
          student_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "attendance_records_school_id_attendance_session_id_fkey"
            columns: ["school_id", "attendance_session_id"]
            isOneToOne: false
            referencedRelation: "attendance_sessions"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "attendance_records_school_id_marked_by_staff_id_fkey"
            columns: ["school_id", "marked_by_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "attendance_records_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      attendance_sessions: {
        Row: {
          class_id: string
          class_subject_id: string | null
          created_at: string
          id: string
          period_label: string
          school_id: string
          session_date: string
          status: string
          taken_by_staff_id: string | null
          updated_at: string
        }
        Insert: {
          class_id: string
          class_subject_id?: string | null
          created_at?: string
          id?: string
          period_label?: string
          school_id: string
          session_date: string
          status?: string
          taken_by_staff_id?: string | null
          updated_at?: string
        }
        Update: {
          class_id?: string
          class_subject_id?: string | null
          created_at?: string
          id?: string
          period_label?: string
          school_id?: string
          session_date?: string
          status?: string
          taken_by_staff_id?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "attendance_sessions_school_id_class_id_fkey"
            columns: ["school_id", "class_id"]
            isOneToOne: false
            referencedRelation: "classes"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "attendance_sessions_school_id_class_subject_id_fkey"
            columns: ["school_id", "class_subject_id"]
            isOneToOne: false
            referencedRelation: "class_subjects"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "attendance_sessions_school_id_taken_by_staff_id_fkey"
            columns: ["school_id", "taken_by_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      class_subjects: {
        Row: {
          class_id: string
          created_at: string
          id: string
          school_id: string
          subject_id: string
          teacher_staff_id: string | null
          updated_at: string
        }
        Insert: {
          class_id: string
          created_at?: string
          id?: string
          school_id: string
          subject_id: string
          teacher_staff_id?: string | null
          updated_at?: string
        }
        Update: {
          class_id?: string
          created_at?: string
          id?: string
          school_id?: string
          subject_id?: string
          teacher_staff_id?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "class_subjects_school_id_class_id_fkey"
            columns: ["school_id", "class_id"]
            isOneToOne: false
            referencedRelation: "classes"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "class_subjects_school_id_subject_id_fkey"
            columns: ["school_id", "subject_id"]
            isOneToOne: false
            referencedRelation: "subjects"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "class_subjects_school_id_teacher_staff_id_fkey"
            columns: ["school_id", "teacher_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      classes: {
        Row: {
          academic_year_id: string
          capacity: number | null
          created_at: string
          grade_level: string | null
          id: string
          name: string
          school_id: string
          status: string
          stream: string | null
          updated_at: string
        }
        Insert: {
          academic_year_id: string
          capacity?: number | null
          created_at?: string
          grade_level?: string | null
          id?: string
          name: string
          school_id: string
          status?: string
          stream?: string | null
          updated_at?: string
        }
        Update: {
          academic_year_id?: string
          capacity?: number | null
          created_at?: string
          grade_level?: string | null
          id?: string
          name?: string
          school_id?: string
          status?: string
          stream?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "classes_school_id_academic_year_id_fkey"
            columns: ["school_id", "academic_year_id"]
            isOneToOne: false
            referencedRelation: "academic_years"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "classes_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      counselling_cases: {
        Row: {
          assigned_staff_id: string | null
          case_category: string
          created_at: string
          id: string
          priority: string
          restricted_access: boolean
          school_id: string
          status: string
          student_id: string
          updated_at: string
        }
        Insert: {
          assigned_staff_id?: string | null
          case_category: string
          created_at?: string
          id?: string
          priority?: string
          restricted_access?: boolean
          school_id: string
          status?: string
          student_id: string
          updated_at?: string
        }
        Update: {
          assigned_staff_id?: string | null
          case_category?: string
          created_at?: string
          id?: string
          priority?: string
          restricted_access?: boolean
          school_id?: string
          status?: string
          student_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "counselling_cases_school_id_assigned_staff_id_fkey"
            columns: ["school_id", "assigned_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "counselling_cases_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "counselling_cases_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      counselling_notes: {
        Row: {
          author_staff_id: string
          case_id: string
          created_at: string
          id: string
          note_body: string
          school_id: string
          sensitivity: string
        }
        Insert: {
          author_staff_id: string
          case_id: string
          created_at?: string
          id?: string
          note_body: string
          school_id: string
          sensitivity?: string
        }
        Update: {
          author_staff_id?: string
          case_id?: string
          created_at?: string
          id?: string
          note_body?: string
          school_id?: string
          sensitivity?: string
        }
        Relationships: [
          {
            foreignKeyName: "counselling_notes_school_id_author_staff_id_fkey"
            columns: ["school_id", "author_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "counselling_notes_school_id_case_id_fkey"
            columns: ["school_id", "case_id"]
            isOneToOne: false
            referencedRelation: "counselling_cases"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "counselling_notes_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      departments: {
        Row: {
          code: string | null
          created_at: string
          description: string | null
          id: string
          name: string
          school_id: string
          updated_at: string
        }
        Insert: {
          code?: string | null
          created_at?: string
          description?: string | null
          id?: string
          name: string
          school_id: string
          updated_at?: string
        }
        Update: {
          code?: string | null
          created_at?: string
          description?: string | null
          id?: string
          name?: string
          school_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "departments_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      discipline_cases: {
        Row: {
          action_taken: string | null
          category: string
          created_at: string
          description: string
          id: string
          incident_date: string
          parent_notified_at: string | null
          reported_by_staff_id: string | null
          resolved_by_staff_id: string | null
          school_id: string
          severity: string
          status: string
          student_id: string
          updated_at: string
        }
        Insert: {
          action_taken?: string | null
          category: string
          created_at?: string
          description: string
          id?: string
          incident_date: string
          parent_notified_at?: string | null
          reported_by_staff_id?: string | null
          resolved_by_staff_id?: string | null
          school_id: string
          severity?: string
          status?: string
          student_id: string
          updated_at?: string
        }
        Update: {
          action_taken?: string | null
          category?: string
          created_at?: string
          description?: string
          id?: string
          incident_date?: string
          parent_notified_at?: string | null
          reported_by_staff_id?: string | null
          resolved_by_staff_id?: string | null
          school_id?: string
          severity?: string
          status?: string
          student_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "discipline_cases_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "discipline_cases_school_id_reported_by_staff_id_fkey"
            columns: ["school_id", "reported_by_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "discipline_cases_school_id_resolved_by_staff_id_fkey"
            columns: ["school_id", "resolved_by_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "discipline_cases_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      district_memberships: {
        Row: {
          created_at: string
          district_id: string
          id: string
          role_code: string
          status: string
          user_id: string
        }
        Insert: {
          created_at?: string
          district_id: string
          id?: string
          role_code: string
          status?: string
          user_id: string
        }
        Update: {
          created_at?: string
          district_id?: string
          id?: string
          role_code?: string
          status?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "district_memberships_district_id_fkey"
            columns: ["district_id"]
            isOneToOne: false
            referencedRelation: "districts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "district_memberships_role_code_fkey"
            columns: ["role_code"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["code"]
          },
        ]
      }
      districts: {
        Row: {
          code: string
          country_code: string
          created_at: string
          id: string
          name: string
          region_name: string | null
          status: string
          updated_at: string
        }
        Insert: {
          code: string
          country_code?: string
          created_at?: string
          id?: string
          name: string
          region_name?: string | null
          status?: string
          updated_at?: string
        }
        Update: {
          code?: string
          country_code?: string
          created_at?: string
          id?: string
          name?: string
          region_name?: string | null
          status?: string
          updated_at?: string
        }
        Relationships: []
      }
      documents: {
        Row: {
          access_scope: string
          created_at: string
          created_by_membership_id: string | null
          document_type: string
          id: string
          object_path: string | null
          school_id: string
          student_id: string | null
          title: string
          updated_at: string
          uploaded_by: string | null
        }
        Insert: {
          access_scope?: string
          created_at?: string
          created_by_membership_id?: string | null
          document_type: string
          id?: string
          object_path?: string | null
          school_id: string
          student_id?: string | null
          title: string
          updated_at?: string
          uploaded_by?: string | null
        }
        Update: {
          access_scope?: string
          created_at?: string
          created_by_membership_id?: string | null
          document_type?: string
          id?: string
          object_path?: string | null
          school_id?: string
          student_id?: string | null
          title?: string
          updated_at?: string
          uploaded_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "documents_created_by_membership_id_school_id_fkey"
            columns: ["created_by_membership_id", "school_id"]
            isOneToOne: false
            referencedRelation: "school_memberships"
            referencedColumns: ["id", "school_id"]
          },
          {
            foreignKeyName: "documents_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "documents_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      fee_categories: {
        Row: {
          code: string
          created_at: string
          description: string | null
          id: string
          is_active: boolean
          name: string
          school_id: string
          updated_at: string
        }
        Insert: {
          code: string
          created_at?: string
          description?: string | null
          id?: string
          is_active?: boolean
          name: string
          school_id: string
          updated_at?: string
        }
        Update: {
          code?: string
          created_at?: string
          description?: string | null
          id?: string
          is_active?: boolean
          name?: string
          school_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fee_categories_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      fee_plan_items: {
        Row: {
          amount: number
          created_at: string
          description: string
          due_on: string | null
          fee_category_id: string
          fee_plan_id: string
          id: string
          school_id: string
          updated_at: string
        }
        Insert: {
          amount: number
          created_at?: string
          description: string
          due_on?: string | null
          fee_category_id: string
          fee_plan_id: string
          id?: string
          school_id: string
          updated_at?: string
        }
        Update: {
          amount?: number
          created_at?: string
          description?: string
          due_on?: string | null
          fee_category_id?: string
          fee_plan_id?: string
          id?: string
          school_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fee_plan_items_school_id_fee_category_id_fkey"
            columns: ["school_id", "fee_category_id"]
            isOneToOne: false
            referencedRelation: "fee_categories"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "fee_plan_items_school_id_fee_plan_id_fkey"
            columns: ["school_id", "fee_plan_id"]
            isOneToOne: false
            referencedRelation: "fee_plans"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      fee_plans: {
        Row: {
          academic_year_id: string
          class_id: string | null
          code: string
          created_at: string
          currency_code: string
          id: string
          is_active: boolean
          name: string
          school_id: string
          updated_at: string
        }
        Insert: {
          academic_year_id: string
          class_id?: string | null
          code: string
          created_at?: string
          currency_code?: string
          id?: string
          is_active?: boolean
          name: string
          school_id: string
          updated_at?: string
        }
        Update: {
          academic_year_id?: string
          class_id?: string | null
          code?: string
          created_at?: string
          currency_code?: string
          id?: string
          is_active?: boolean
          name?: string
          school_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fee_plans_school_id_academic_year_id_fkey"
            columns: ["school_id", "academic_year_id"]
            isOneToOne: false
            referencedRelation: "academic_years"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "fee_plans_school_id_class_id_fkey"
            columns: ["school_id", "class_id"]
            isOneToOne: false
            referencedRelation: "classes"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      guardians: {
        Row: {
          address: string | null
          created_at: string
          email: string | null
          first_name: string
          id: string
          last_name: string
          phone: string
          school_id: string
          updated_at: string
          user_id: string | null
        }
        Insert: {
          address?: string | null
          created_at?: string
          email?: string | null
          first_name: string
          id?: string
          last_name: string
          phone: string
          school_id: string
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          address?: string | null
          created_at?: string
          email?: string | null
          first_name?: string
          id?: string
          last_name?: string
          phone?: string
          school_id?: string
          updated_at?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "guardians_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      invoice_items: {
        Row: {
          created_at: string
          description: string
          fee_category_id: string | null
          id: string
          invoice_id: string
          line_total: number | null
          quantity: number
          school_id: string
          unit_price: number
        }
        Insert: {
          created_at?: string
          description: string
          fee_category_id?: string | null
          id?: string
          invoice_id: string
          line_total?: number | null
          quantity?: number
          school_id: string
          unit_price: number
        }
        Update: {
          created_at?: string
          description?: string
          fee_category_id?: string | null
          id?: string
          invoice_id?: string
          line_total?: number | null
          quantity?: number
          school_id?: string
          unit_price?: number
        }
        Relationships: [
          {
            foreignKeyName: "invoice_items_school_id_fee_category_id_fkey"
            columns: ["school_id", "fee_category_id"]
            isOneToOne: false
            referencedRelation: "fee_categories"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "invoice_items_school_id_invoice_id_fkey"
            columns: ["school_id", "invoice_id"]
            isOneToOne: false
            referencedRelation: "invoices"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      invoices: {
        Row: {
          academic_year_id: string
          created_at: string
          currency_code: string
          due_on: string | null
          fee_plan_id: string | null
          id: string
          invoice_number: string
          issued_by_staff_id: string | null
          issued_on: string | null
          notes: string | null
          school_id: string
          status: string
          student_id: string
          updated_at: string
        }
        Insert: {
          academic_year_id: string
          created_at?: string
          currency_code?: string
          due_on?: string | null
          fee_plan_id?: string | null
          id?: string
          invoice_number: string
          issued_by_staff_id?: string | null
          issued_on?: string | null
          notes?: string | null
          school_id: string
          status?: string
          student_id: string
          updated_at?: string
        }
        Update: {
          academic_year_id?: string
          created_at?: string
          currency_code?: string
          due_on?: string | null
          fee_plan_id?: string | null
          id?: string
          invoice_number?: string
          issued_by_staff_id?: string | null
          issued_on?: string | null
          notes?: string | null
          school_id?: string
          status?: string
          student_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "invoices_school_id_academic_year_id_fkey"
            columns: ["school_id", "academic_year_id"]
            isOneToOne: false
            referencedRelation: "academic_years"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "invoices_school_id_fee_plan_id_fkey"
            columns: ["school_id", "fee_plan_id"]
            isOneToOne: false
            referencedRelation: "fee_plans"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "invoices_school_id_issued_by_staff_id_fkey"
            columns: ["school_id", "issued_by_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "invoices_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      learning_resources: {
        Row: {
          access_scope: string
          class_subject_id: string | null
          created_at: string
          created_by_staff_id: string | null
          description: string | null
          external_url: string | null
          id: string
          object_path: string | null
          resource_type: string
          school_id: string
          title: string
          updated_at: string
        }
        Insert: {
          access_scope?: string
          class_subject_id?: string | null
          created_at?: string
          created_by_staff_id?: string | null
          description?: string | null
          external_url?: string | null
          id?: string
          object_path?: string | null
          resource_type: string
          school_id: string
          title: string
          updated_at?: string
        }
        Update: {
          access_scope?: string
          class_subject_id?: string | null
          created_at?: string
          created_by_staff_id?: string | null
          description?: string | null
          external_url?: string | null
          id?: string
          object_path?: string | null
          resource_type?: string
          school_id?: string
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "learning_resources_school_id_class_subject_id_fkey"
            columns: ["school_id", "class_subject_id"]
            isOneToOne: false
            referencedRelation: "class_subjects"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "learning_resources_school_id_created_by_staff_id_fkey"
            columns: ["school_id", "created_by_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "learning_resources_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      lesson_plans: {
        Row: {
          class_subject_id: string
          created_at: string
          id: string
          learning_objectives: string[]
          lesson_content: string | null
          planned_for: string
          school_id: string
          status: string
          teacher_staff_id: string
          title: string
          updated_at: string
        }
        Insert: {
          class_subject_id: string
          created_at?: string
          id?: string
          learning_objectives?: string[]
          lesson_content?: string | null
          planned_for: string
          school_id: string
          status?: string
          teacher_staff_id: string
          title: string
          updated_at?: string
        }
        Update: {
          class_subject_id?: string
          created_at?: string
          id?: string
          learning_objectives?: string[]
          lesson_content?: string | null
          planned_for?: string
          school_id?: string
          status?: string
          teacher_staff_id?: string
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "lesson_plans_school_id_class_subject_id_fkey"
            columns: ["school_id", "class_subject_id"]
            isOneToOne: false
            referencedRelation: "class_subjects"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "lesson_plans_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "lesson_plans_school_id_teacher_staff_id_fkey"
            columns: ["school_id", "teacher_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      library_books: {
        Row: {
          accession_number: string
          authors: string[]
          category: string | null
          created_at: string
          id: string
          school_id: string
          status: string
          title: string
          total_copies: number
          updated_at: string
        }
        Insert: {
          accession_number: string
          authors?: string[]
          category?: string | null
          created_at?: string
          id?: string
          school_id: string
          status?: string
          title: string
          total_copies?: number
          updated_at?: string
        }
        Update: {
          accession_number?: string
          authors?: string[]
          category?: string | null
          created_at?: string
          id?: string
          school_id?: string
          status?: string
          title?: string
          total_copies?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "library_books_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      library_loans: {
        Row: {
          book_id: string
          created_at: string
          due_at: string
          fine_amount: number
          id: string
          returned_at: string | null
          school_id: string
          staff_member_id: string | null
          status: string
          student_id: string | null
        }
        Insert: {
          book_id: string
          created_at?: string
          due_at: string
          fine_amount?: number
          id?: string
          returned_at?: string | null
          school_id: string
          staff_member_id?: string | null
          status?: string
          student_id?: string | null
        }
        Update: {
          book_id?: string
          created_at?: string
          due_at?: string
          fine_amount?: number
          id?: string
          returned_at?: string | null
          school_id?: string
          staff_member_id?: string | null
          status?: string
          student_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "library_loans_school_id_book_id_fkey"
            columns: ["school_id", "book_id"]
            isOneToOne: false
            referencedRelation: "library_books"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "library_loans_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "library_loans_school_id_staff_member_id_fkey"
            columns: ["school_id", "staff_member_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "library_loans_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      meal_attendance: {
        Row: {
          attended: boolean
          created_at: string
          id: string
          meal_date: string
          meal_type: string
          recorded_by_staff_id: string | null
          school_id: string
          student_id: string
        }
        Insert: {
          attended?: boolean
          created_at?: string
          id?: string
          meal_date: string
          meal_type: string
          recorded_by_staff_id?: string | null
          school_id: string
          student_id: string
        }
        Update: {
          attended?: boolean
          created_at?: string
          id?: string
          meal_date?: string
          meal_type?: string
          recorded_by_staff_id?: string | null
          school_id?: string
          student_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "meal_attendance_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "meal_attendance_school_id_recorded_by_staff_id_fkey"
            columns: ["school_id", "recorded_by_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "meal_attendance_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      meal_menus: {
        Row: {
          created_at: string
          id: string
          meal_type: string
          menu_date: string
          menu_items: Json
          published: boolean
          school_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          meal_type: string
          menu_date: string
          menu_items?: Json
          published?: boolean
          school_id: string
        }
        Update: {
          created_at?: string
          id?: string
          meal_type?: string
          menu_date?: string
          menu_items?: Json
          published?: boolean
          school_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "meal_menus_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      membership_roles: {
        Row: {
          assigned_by: string | null
          created_at: string
          membership_id: string
          role_code: string
          school_id: string
        }
        Insert: {
          assigned_by?: string | null
          created_at?: string
          membership_id: string
          role_code: string
          school_id: string
        }
        Update: {
          assigned_by?: string | null
          created_at?: string
          membership_id?: string
          role_code?: string
          school_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "membership_roles_membership_id_school_id_fkey"
            columns: ["membership_id", "school_id"]
            isOneToOne: false
            referencedRelation: "school_memberships"
            referencedColumns: ["id", "school_id"]
          },
          {
            foreignKeyName: "membership_roles_role_code_fkey"
            columns: ["role_code"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["code"]
          },
        ]
      }
      notifications: {
        Row: {
          body: string
          category: string
          created_at: string
          id: string
          read_at: string | null
          related_url: string | null
          school_id: string | null
          title: string
          user_id: string
        }
        Insert: {
          body: string
          category?: string
          created_at?: string
          id?: string
          read_at?: string | null
          related_url?: string | null
          school_id?: string | null
          title: string
          user_id: string
        }
        Update: {
          body?: string
          category?: string
          created_at?: string
          id?: string
          read_at?: string | null
          related_url?: string | null
          school_id?: string | null
          title?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "notifications_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      payment_allocations: {
        Row: {
          allocated_amount: number
          created_at: string
          id: string
          invoice_id: string
          payment_id: string
          school_id: string
        }
        Insert: {
          allocated_amount: number
          created_at?: string
          id?: string
          invoice_id: string
          payment_id: string
          school_id: string
        }
        Update: {
          allocated_amount?: number
          created_at?: string
          id?: string
          invoice_id?: string
          payment_id?: string
          school_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "payment_allocations_school_id_invoice_id_fkey"
            columns: ["school_id", "invoice_id"]
            isOneToOne: false
            referencedRelation: "invoices"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "payment_allocations_school_id_payment_id_fkey"
            columns: ["school_id", "payment_id"]
            isOneToOne: false
            referencedRelation: "payments"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      payment_gateway_events: {
        Row: {
          error_message: string | null
          event_type: string
          id: string
          payload_hash: string | null
          processed_at: string | null
          processing_status: string
          provider: string
          provider_event_id: string
          provider_reference: string | null
          received_at: string
          safe_metadata: Json
          school_id: string | null
          signature_verified: boolean
        }
        Insert: {
          error_message?: string | null
          event_type: string
          id?: string
          payload_hash?: string | null
          processed_at?: string | null
          processing_status?: string
          provider: string
          provider_event_id: string
          provider_reference?: string | null
          received_at?: string
          safe_metadata?: Json
          school_id?: string | null
          signature_verified?: boolean
        }
        Update: {
          error_message?: string | null
          event_type?: string
          id?: string
          payload_hash?: string | null
          processed_at?: string | null
          processing_status?: string
          provider?: string
          provider_event_id?: string
          provider_reference?: string | null
          received_at?: string
          safe_metadata?: Json
          school_id?: string | null
          signature_verified?: boolean
        }
        Relationships: [
          {
            foreignKeyName: "payment_gateway_events_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      payments: {
        Row: {
          amount: number
          created_at: string
          currency_code: string
          id: string
          notes: string | null
          paid_at: string | null
          payment_method: string
          payment_number: string
          payment_provider: string
          payment_status: string
          provider_reference: string | null
          recorded_by_staff_id: string | null
          school_id: string
          student_id: string
          updated_at: string
        }
        Insert: {
          amount: number
          created_at?: string
          currency_code?: string
          id?: string
          notes?: string | null
          paid_at?: string | null
          payment_method: string
          payment_number: string
          payment_provider?: string
          payment_status?: string
          provider_reference?: string | null
          recorded_by_staff_id?: string | null
          school_id: string
          student_id: string
          updated_at?: string
        }
        Update: {
          amount?: number
          created_at?: string
          currency_code?: string
          id?: string
          notes?: string | null
          paid_at?: string | null
          payment_method?: string
          payment_number?: string
          payment_provider?: string
          payment_status?: string
          provider_reference?: string | null
          recorded_by_staff_id?: string | null
          school_id?: string
          student_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "payments_school_id_recorded_by_staff_id_fkey"
            columns: ["school_id", "recorded_by_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "payments_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      permissions: {
        Row: {
          code: string
          description: string
        }
        Insert: {
          code: string
          description?: string
        }
        Update: {
          code?: string
          description?: string
        }
        Relationships: []
      }
      profiles: {
        Row: {
          avatar_path: string | null
          created_at: string
          full_name: string | null
          id: string
          phone: string | null
          preferred_language: string
          updated_at: string
        }
        Insert: {
          avatar_path?: string | null
          created_at?: string
          full_name?: string | null
          id: string
          phone?: string | null
          preferred_language?: string
          updated_at?: string
        }
        Update: {
          avatar_path?: string | null
          created_at?: string
          full_name?: string | null
          id?: string
          phone?: string | null
          preferred_language?: string
          updated_at?: string
        }
        Relationships: []
      }
      role_permissions: {
        Row: {
          permission_code: string
          role_code: string
        }
        Insert: {
          permission_code: string
          role_code: string
        }
        Update: {
          permission_code?: string
          role_code?: string
        }
        Relationships: [
          {
            foreignKeyName: "role_permissions_permission_code_fkey"
            columns: ["permission_code"]
            isOneToOne: false
            referencedRelation: "permissions"
            referencedColumns: ["code"]
          },
          {
            foreignKeyName: "role_permissions_role_code_fkey"
            columns: ["role_code"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["code"]
          },
        ]
      }
      roles: {
        Row: {
          code: string
          created_at: string
          description: string
          is_system: boolean
          name: string
        }
        Insert: {
          code: string
          created_at?: string
          description?: string
          is_system?: boolean
          name: string
        }
        Update: {
          code?: string
          created_at?: string
          description?: string
          is_system?: boolean
          name?: string
        }
        Relationships: []
      }
      school_assets: {
        Row: {
          asset_code: string
          asset_name: string
          assigned_to_staff_id: string | null
          category: string
          condition_status: string
          created_at: string
          id: string
          location: string | null
          school_id: string
          updated_at: string
        }
        Insert: {
          asset_code: string
          asset_name: string
          assigned_to_staff_id?: string | null
          category: string
          condition_status?: string
          created_at?: string
          id?: string
          location?: string | null
          school_id: string
          updated_at?: string
        }
        Update: {
          asset_code?: string
          asset_name?: string
          assigned_to_staff_id?: string | null
          category?: string
          condition_status?: string
          created_at?: string
          id?: string
          location?: string | null
          school_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "school_assets_school_id_assigned_to_staff_id_fkey"
            columns: ["school_id", "assigned_to_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "school_assets_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      school_audit_events: {
        Row: {
          actor_user_id: string | null
          entity_id: string | null
          entity_type: string
          event_payload: Json
          event_type: string
          id: number
          occurred_at: string
          school_id: string
        }
        Insert: {
          actor_user_id?: string | null
          entity_id?: string | null
          entity_type: string
          event_payload?: Json
          event_type: string
          id?: never
          occurred_at?: string
          school_id: string
        }
        Update: {
          actor_user_id?: string | null
          entity_id?: string | null
          entity_type?: string
          event_payload?: Json
          event_type?: string
          id?: never
          occurred_at?: string
          school_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "school_audit_events_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      school_invitations: {
        Row: {
          accepted_at: string | null
          created_at: string
          email: string
          expires_at: string
          id: string
          invited_by: string | null
          role_code: string
          school_id: string
          status: string
          token_hash: string | null
          updated_at: string
        }
        Insert: {
          accepted_at?: string | null
          created_at?: string
          email: string
          expires_at?: string
          id?: string
          invited_by?: string | null
          role_code: string
          school_id: string
          status?: string
          token_hash?: string | null
          updated_at?: string
        }
        Update: {
          accepted_at?: string | null
          created_at?: string
          email?: string
          expires_at?: string
          id?: string
          invited_by?: string | null
          role_code?: string
          school_id?: string
          status?: string
          token_hash?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "school_invitations_role_code_fkey"
            columns: ["role_code"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["code"]
          },
          {
            foreignKeyName: "school_invitations_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      school_memberships: {
        Row: {
          created_at: string
          id: string
          invited_by: string | null
          joined_at: string
          school_id: string
          status: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          invited_by?: string | null
          joined_at?: string
          school_id: string
          status?: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          invited_by?: string | null
          joined_at?: string
          school_id?: string
          status?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "school_memberships_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      school_message_logs: {
        Row: {
          channel: string
          created_at: string
          delivered_at: string | null
          error_code: string | null
          id: string
          message_status: string
          metadata: Json
          provider: string | null
          provider_reference: string | null
          recipient: string
          school_id: string
          sent_at: string | null
          template_code: string | null
        }
        Insert: {
          channel: string
          created_at?: string
          delivered_at?: string | null
          error_code?: string | null
          id?: string
          message_status?: string
          metadata?: Json
          provider?: string | null
          provider_reference?: string | null
          recipient: string
          school_id: string
          sent_at?: string | null
          template_code?: string | null
        }
        Update: {
          channel?: string
          created_at?: string
          delivered_at?: string | null
          error_code?: string | null
          id?: string
          message_status?: string
          metadata?: Json
          provider?: string | null
          provider_reference?: string | null
          recipient?: string
          school_id?: string
          sent_at?: string | null
          template_code?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "school_message_logs_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      school_settings: {
        Row: {
          school_id: string
          settings: Json
          updated_at: string
        }
        Insert: {
          school_id: string
          settings?: Json
          updated_at?: string
        }
        Update: {
          school_id?: string
          settings?: Json
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "school_settings_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: true
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      school_subscriptions: {
        Row: {
          amount: number
          billing_cycle: string
          created_at: string
          currency_code: string
          ends_at: string | null
          id: string
          next_billing_at: string | null
          plan_code: string
          school_id: string
          starts_at: string
          status: string
          updated_at: string
        }
        Insert: {
          amount?: number
          billing_cycle?: string
          created_at?: string
          currency_code?: string
          ends_at?: string | null
          id?: string
          next_billing_at?: string | null
          plan_code: string
          school_id: string
          starts_at?: string
          status?: string
          updated_at?: string
        }
        Update: {
          amount?: number
          billing_cycle?: string
          created_at?: string
          currency_code?: string
          ends_at?: string | null
          id?: string
          next_billing_at?: string | null
          plan_code?: string
          school_id?: string
          starts_at?: string
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "school_subscriptions_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      schools: {
        Row: {
          country_code: string
          created_at: string
          created_by: string | null
          currency_code: string
          deleted_at: string | null
          district_id: string | null
          id: string
          name: string
          registration_number: string | null
          school_type: string
          slug: string
          status: string
          timezone: string
          updated_at: string
        }
        Insert: {
          country_code?: string
          created_at?: string
          created_by?: string | null
          currency_code?: string
          deleted_at?: string | null
          district_id?: string | null
          id?: string
          name: string
          registration_number?: string | null
          school_type?: string
          slug: string
          status?: string
          timezone?: string
          updated_at?: string
        }
        Update: {
          country_code?: string
          created_at?: string
          created_by?: string | null
          currency_code?: string
          deleted_at?: string | null
          district_id?: string | null
          id?: string
          name?: string
          registration_number?: string | null
          school_type?: string
          slug?: string
          status?: string
          timezone?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "schools_district_id_fkey"
            columns: ["district_id"]
            isOneToOne: false
            referencedRelation: "districts"
            referencedColumns: ["id"]
          },
        ]
      }
      selcom_checkout_intents: {
        Row: {
          amount: number
          client_idempotency_key: string
          created_at: string
          currency_code: string
          error_code: string | null
          error_message: string | null
          expires_at: string
          id: string
          invoice_id: string
          merchant_trans_id: string
          order_id: string
          payer_msisdn_last4: string | null
          payer_user_id: string
          payment_id: string | null
          processed_at: string | null
          safe_metadata: Json
          school_id: string
          selcom_channel: string | null
          selcom_reference: string | null
          selcom_transid: string | null
          status: string
          student_id: string
          updated_at: string
        }
        Insert: {
          amount: number
          client_idempotency_key: string
          created_at?: string
          currency_code?: string
          error_code?: string | null
          error_message?: string | null
          expires_at?: string
          id?: string
          invoice_id: string
          merchant_trans_id: string
          order_id: string
          payer_msisdn_last4?: string | null
          payer_user_id: string
          payment_id?: string | null
          processed_at?: string | null
          safe_metadata?: Json
          school_id: string
          selcom_channel?: string | null
          selcom_reference?: string | null
          selcom_transid?: string | null
          status?: string
          student_id: string
          updated_at?: string
        }
        Update: {
          amount?: number
          client_idempotency_key?: string
          created_at?: string
          currency_code?: string
          error_code?: string | null
          error_message?: string | null
          expires_at?: string
          id?: string
          invoice_id?: string
          merchant_trans_id?: string
          order_id?: string
          payer_msisdn_last4?: string | null
          payer_user_id?: string
          payment_id?: string | null
          processed_at?: string | null
          safe_metadata?: Json
          school_id?: string
          selcom_channel?: string | null
          selcom_reference?: string | null
          selcom_transid?: string | null
          status?: string
          student_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "selcom_checkout_intents_school_invoice_fk"
            columns: ["school_id", "invoice_id"]
            isOneToOne: false
            referencedRelation: "invoices"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "selcom_checkout_intents_school_payment_fk"
            columns: ["school_id", "payment_id"]
            isOneToOne: false
            referencedRelation: "payments"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "selcom_checkout_intents_school_student_fk"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      snippe_checkout_intents: {
        Row: {
          amount: number
          client_idempotency_key: string
          created_at: string
          currency_code: string
          error_code: string | null
          error_message: string | null
          expires_at: string
          id: string
          invoice_id: string
          order_id: string
          payer_msisdn_last4: string | null
          payer_user_id: string
          payment_id: string | null
          processed_at: string | null
          safe_metadata: Json
          school_id: string
          snippe_channel: string | null
          snippe_external_reference: string | null
          snippe_reference: string | null
          status: string
          student_id: string
          updated_at: string
        }
        Insert: {
          amount: number
          client_idempotency_key: string
          created_at?: string
          currency_code?: string
          error_code?: string | null
          error_message?: string | null
          expires_at?: string
          id?: string
          invoice_id: string
          order_id: string
          payer_msisdn_last4?: string | null
          payer_user_id: string
          payment_id?: string | null
          processed_at?: string | null
          safe_metadata?: Json
          school_id: string
          snippe_channel?: string | null
          snippe_external_reference?: string | null
          snippe_reference?: string | null
          status?: string
          student_id: string
          updated_at?: string
        }
        Update: {
          amount?: number
          client_idempotency_key?: string
          created_at?: string
          currency_code?: string
          error_code?: string | null
          error_message?: string | null
          expires_at?: string
          id?: string
          invoice_id?: string
          order_id?: string
          payer_msisdn_last4?: string | null
          payer_user_id?: string
          payment_id?: string | null
          processed_at?: string | null
          safe_metadata?: Json
          school_id?: string
          snippe_channel?: string | null
          snippe_external_reference?: string | null
          snippe_reference?: string | null
          status?: string
          student_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "snippe_checkout_intents_school_invoice_fk"
            columns: ["school_id", "invoice_id"]
            isOneToOne: false
            referencedRelation: "invoices"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "snippe_checkout_intents_school_payment_fk"
            columns: ["school_id", "payment_id"]
            isOneToOne: false
            referencedRelation: "payments"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "snippe_checkout_intents_school_student_fk"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      sports_events: {
        Row: {
          created_at: string
          ends_at: string | null
          event_name: string
          id: string
          opponent: string | null
          result_summary: string | null
          school_id: string
          starts_at: string
          status: string
          team_id: string | null
          updated_at: string
          venue: string | null
        }
        Insert: {
          created_at?: string
          ends_at?: string | null
          event_name: string
          id?: string
          opponent?: string | null
          result_summary?: string | null
          school_id: string
          starts_at: string
          status?: string
          team_id?: string | null
          updated_at?: string
          venue?: string | null
        }
        Update: {
          created_at?: string
          ends_at?: string | null
          event_name?: string
          id?: string
          opponent?: string | null
          result_summary?: string | null
          school_id?: string
          starts_at?: string
          status?: string
          team_id?: string | null
          updated_at?: string
          venue?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "sports_events_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sports_events_school_id_team_id_fkey"
            columns: ["school_id", "team_id"]
            isOneToOne: false
            referencedRelation: "sports_teams"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      sports_team_members: {
        Row: {
          id: string
          joined_on: string
          school_id: string
          status: string
          student_id: string
          team_id: string
        }
        Insert: {
          id?: string
          joined_on?: string
          school_id: string
          status?: string
          student_id: string
          team_id: string
        }
        Update: {
          id?: string
          joined_on?: string
          school_id?: string
          status?: string
          student_id?: string
          team_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "sports_team_members_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sports_team_members_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "sports_team_members_school_id_team_id_fkey"
            columns: ["school_id", "team_id"]
            isOneToOne: false
            referencedRelation: "sports_teams"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      sports_teams: {
        Row: {
          coach_staff_id: string | null
          created_at: string
          id: string
          name: string
          school_id: string
          season_label: string | null
          sport: string
          status: string
          updated_at: string
        }
        Insert: {
          coach_staff_id?: string | null
          created_at?: string
          id?: string
          name: string
          school_id: string
          season_label?: string | null
          sport: string
          status?: string
          updated_at?: string
        }
        Update: {
          coach_staff_id?: string | null
          created_at?: string
          id?: string
          name?: string
          school_id?: string
          season_label?: string | null
          sport?: string
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "sports_teams_school_id_coach_staff_id_fkey"
            columns: ["school_id", "coach_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "sports_teams_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      staff_attendance: {
        Row: {
          attendance_date: string
          check_in: string | null
          check_out: string | null
          created_at: string
          id: string
          recorded_by: string | null
          school_id: string
          staff_member_id: string
          status: string
        }
        Insert: {
          attendance_date: string
          check_in?: string | null
          check_out?: string | null
          created_at?: string
          id?: string
          recorded_by?: string | null
          school_id: string
          staff_member_id: string
          status?: string
        }
        Update: {
          attendance_date?: string
          check_in?: string | null
          check_out?: string | null
          created_at?: string
          id?: string
          recorded_by?: string | null
          school_id?: string
          staff_member_id?: string
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "staff_attendance_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "staff_attendance_school_id_staff_member_id_fkey"
            columns: ["school_id", "staff_member_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      staff_leave_requests: {
        Row: {
          created_at: string
          ends_on: string
          id: string
          leave_type: string
          school_id: string
          staff_member_id: string
          starts_on: string
          status: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          ends_on: string
          id?: string
          leave_type: string
          school_id: string
          staff_member_id: string
          starts_on: string
          status?: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          ends_on?: string
          id?: string
          leave_type?: string
          school_id?: string
          staff_member_id?: string
          starts_on?: string
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "staff_leave_requests_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "staff_leave_requests_school_id_staff_member_id_fkey"
            columns: ["school_id", "staff_member_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      staff_members: {
        Row: {
          created_at: string
          department_id: string | null
          email: string | null
          employee_number: string
          employment_status: string
          first_name: string
          hired_on: string | null
          id: string
          job_title: string | null
          last_name: string
          middle_name: string | null
          phone: string | null
          school_id: string
          updated_at: string
          user_id: string | null
        }
        Insert: {
          created_at?: string
          department_id?: string | null
          email?: string | null
          employee_number: string
          employment_status?: string
          first_name: string
          hired_on?: string | null
          id?: string
          job_title?: string | null
          last_name: string
          middle_name?: string | null
          phone?: string | null
          school_id: string
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          created_at?: string
          department_id?: string | null
          email?: string | null
          employee_number?: string
          employment_status?: string
          first_name?: string
          hired_on?: string | null
          id?: string
          job_title?: string | null
          last_name?: string
          middle_name?: string | null
          phone?: string | null
          school_id?: string
          updated_at?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "staff_members_school_id_department_id_fkey"
            columns: ["school_id", "department_id"]
            isOneToOne: false
            referencedRelation: "departments"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "staff_members_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      student_enrollments: {
        Row: {
          academic_year_id: string
          class_id: string
          created_at: string
          enrolled_on: string
          exited_on: string | null
          id: string
          school_id: string
          status: string
          student_id: string
          updated_at: string
        }
        Insert: {
          academic_year_id: string
          class_id: string
          created_at?: string
          enrolled_on?: string
          exited_on?: string | null
          id?: string
          school_id: string
          status?: string
          student_id: string
          updated_at?: string
        }
        Update: {
          academic_year_id?: string
          class_id?: string
          created_at?: string
          enrolled_on?: string
          exited_on?: string | null
          id?: string
          school_id?: string
          status?: string
          student_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "student_enrollments_school_id_academic_year_id_fkey"
            columns: ["school_id", "academic_year_id"]
            isOneToOne: false
            referencedRelation: "academic_years"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "student_enrollments_school_id_class_id_fkey"
            columns: ["school_id", "class_id"]
            isOneToOne: false
            referencedRelation: "classes"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "student_enrollments_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      student_guardians: {
        Row: {
          created_at: string
          guardian_id: string
          id: string
          is_primary: boolean
          receives_academic_updates: boolean
          receives_finance_updates: boolean
          relationship: string
          school_id: string
          student_id: string
        }
        Insert: {
          created_at?: string
          guardian_id: string
          id?: string
          is_primary?: boolean
          receives_academic_updates?: boolean
          receives_finance_updates?: boolean
          relationship: string
          school_id: string
          student_id: string
        }
        Update: {
          created_at?: string
          guardian_id?: string
          id?: string
          is_primary?: boolean
          receives_academic_updates?: boolean
          receives_finance_updates?: boolean
          relationship?: string
          school_id?: string
          student_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "student_guardians_school_id_guardian_id_fkey"
            columns: ["school_id", "guardian_id"]
            isOneToOne: false
            referencedRelation: "guardians"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "student_guardians_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      student_health_records: {
        Row: {
          created_at: string
          id: string
          record_type: string
          recorded_at: string
          restricted_access: boolean
          school_id: string
          student_id: string
          summary: string
        }
        Insert: {
          created_at?: string
          id?: string
          record_type: string
          recorded_at?: string
          restricted_access?: boolean
          school_id: string
          student_id: string
          summary: string
        }
        Update: {
          created_at?: string
          id?: string
          record_type?: string
          recorded_at?: string
          restricted_access?: boolean
          school_id?: string
          student_id?: string
          summary?: string
        }
        Relationships: [
          {
            foreignKeyName: "student_health_records_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "student_health_records_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      student_transport_assignments: {
        Row: {
          created_at: string
          effective_from: string
          effective_to: string | null
          id: string
          route_id: string
          school_id: string
          status: string
          stop_id: string | null
          student_id: string
        }
        Insert: {
          created_at?: string
          effective_from?: string
          effective_to?: string | null
          id?: string
          route_id: string
          school_id: string
          status?: string
          stop_id?: string | null
          student_id: string
        }
        Update: {
          created_at?: string
          effective_from?: string
          effective_to?: string | null
          id?: string
          route_id?: string
          school_id?: string
          status?: string
          stop_id?: string | null
          student_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "student_transport_assignments_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "student_transport_assignments_school_id_route_id_fkey"
            columns: ["school_id", "route_id"]
            isOneToOne: false
            referencedRelation: "transport_routes"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "student_transport_assignments_school_id_stop_id_fkey"
            columns: ["school_id", "stop_id"]
            isOneToOne: false
            referencedRelation: "transport_stops"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "student_transport_assignments_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      student_workspace_projects: {
        Row: {
          created_at: string
          description: string | null
          id: string
          school_id: string
          status: string
          student_id: string
          title: string
          updated_at: string
          workspace_type: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          id?: string
          school_id: string
          status?: string
          student_id: string
          title: string
          updated_at?: string
          workspace_type?: string
        }
        Update: {
          created_at?: string
          description?: string | null
          id?: string
          school_id?: string
          status?: string
          student_id?: string
          title?: string
          updated_at?: string
          workspace_type?: string
        }
        Relationships: [
          {
            foreignKeyName: "student_workspace_projects_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "student_workspace_projects_school_id_student_id_fkey"
            columns: ["school_id", "student_id"]
            isOneToOne: false
            referencedRelation: "students"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      students: {
        Row: {
          admission_date: string
          admission_number: string
          created_at: string
          date_of_birth: string | null
          first_name: string
          id: string
          last_name: string
          middle_name: string | null
          notes: string | null
          preferred_name: string | null
          school_id: string
          student_status: string
          updated_at: string
          user_id: string | null
        }
        Insert: {
          admission_date?: string
          admission_number: string
          created_at?: string
          date_of_birth?: string | null
          first_name: string
          id?: string
          last_name: string
          middle_name?: string | null
          notes?: string | null
          preferred_name?: string | null
          school_id: string
          student_status?: string
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          admission_date?: string
          admission_number?: string
          created_at?: string
          date_of_birth?: string | null
          first_name?: string
          id?: string
          last_name?: string
          middle_name?: string | null
          notes?: string | null
          preferred_name?: string | null
          school_id?: string
          student_status?: string
          updated_at?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "students_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      subjects: {
        Row: {
          code: string | null
          created_at: string
          department_id: string | null
          description: string | null
          id: string
          name: string
          school_id: string
          status: string
          updated_at: string
        }
        Insert: {
          code?: string | null
          created_at?: string
          department_id?: string | null
          description?: string | null
          id?: string
          name: string
          school_id: string
          status?: string
          updated_at?: string
        }
        Update: {
          code?: string | null
          created_at?: string
          department_id?: string | null
          description?: string | null
          id?: string
          name?: string
          school_id?: string
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "subjects_school_id_department_id_fkey"
            columns: ["school_id", "department_id"]
            isOneToOne: false
            referencedRelation: "departments"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "subjects_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      subscription_invoices: {
        Row: {
          amount_due: number
          amount_paid: number
          created_at: string
          currency_code: string
          due_at: string
          id: string
          invoice_number: string
          issued_at: string
          paid_at: string | null
          school_id: string
          status: string
          subscription_id: string
        }
        Insert: {
          amount_due: number
          amount_paid?: number
          created_at?: string
          currency_code?: string
          due_at: string
          id?: string
          invoice_number: string
          issued_at?: string
          paid_at?: string | null
          school_id: string
          status?: string
          subscription_id: string
        }
        Update: {
          amount_due?: number
          amount_paid?: number
          created_at?: string
          currency_code?: string
          due_at?: string
          id?: string
          invoice_number?: string
          issued_at?: string
          paid_at?: string | null
          school_id?: string
          status?: string
          subscription_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "subscription_invoices_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "subscription_invoices_school_id_subscription_id_fkey"
            columns: ["school_id", "subscription_id"]
            isOneToOne: false
            referencedRelation: "school_subscriptions"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      terms: {
        Row: {
          academic_year_id: string
          created_at: string
          ends_on: string
          id: string
          name: string
          school_id: string
          starts_on: string
          status: string
          updated_at: string
        }
        Insert: {
          academic_year_id: string
          created_at?: string
          ends_on: string
          id?: string
          name: string
          school_id: string
          starts_on: string
          status?: string
          updated_at?: string
        }
        Update: {
          academic_year_id?: string
          created_at?: string
          ends_on?: string
          id?: string
          name?: string
          school_id?: string
          starts_on?: string
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "terms_school_id_academic_year_id_fkey"
            columns: ["school_id", "academic_year_id"]
            isOneToOne: false
            referencedRelation: "academic_years"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "terms_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      timetable_slots: {
        Row: {
          academic_year_id: string
          class_id: string
          class_subject_id: string
          created_at: string
          ends_at: string
          id: string
          room_label: string | null
          school_id: string
          starts_at: string
          teacher_staff_id: string | null
          updated_at: string
          weekday: number
        }
        Insert: {
          academic_year_id: string
          class_id: string
          class_subject_id: string
          created_at?: string
          ends_at: string
          id?: string
          room_label?: string | null
          school_id: string
          starts_at: string
          teacher_staff_id?: string | null
          updated_at?: string
          weekday: number
        }
        Update: {
          academic_year_id?: string
          class_id?: string
          class_subject_id?: string
          created_at?: string
          ends_at?: string
          id?: string
          room_label?: string | null
          school_id?: string
          starts_at?: string
          teacher_staff_id?: string | null
          updated_at?: string
          weekday?: number
        }
        Relationships: [
          {
            foreignKeyName: "timetable_slots_school_id_academic_year_id_fkey"
            columns: ["school_id", "academic_year_id"]
            isOneToOne: false
            referencedRelation: "academic_years"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "timetable_slots_school_id_class_id_fkey"
            columns: ["school_id", "class_id"]
            isOneToOne: false
            referencedRelation: "classes"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "timetable_slots_school_id_class_subject_id_fkey"
            columns: ["school_id", "class_subject_id"]
            isOneToOne: false
            referencedRelation: "class_subjects"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "timetable_slots_school_id_teacher_staff_id_fkey"
            columns: ["school_id", "teacher_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      transport_routes: {
        Row: {
          capacity: number | null
          created_at: string
          driver_staff_id: string | null
          id: string
          route_name: string
          school_id: string
          status: string
          updated_at: string
          vehicle_registration: string | null
        }
        Insert: {
          capacity?: number | null
          created_at?: string
          driver_staff_id?: string | null
          id?: string
          route_name: string
          school_id: string
          status?: string
          updated_at?: string
          vehicle_registration?: string | null
        }
        Update: {
          capacity?: number | null
          created_at?: string
          driver_staff_id?: string | null
          id?: string
          route_name?: string
          school_id?: string
          status?: string
          updated_at?: string
          vehicle_registration?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "transport_routes_school_id_driver_staff_id_fkey"
            columns: ["school_id", "driver_staff_id"]
            isOneToOne: false
            referencedRelation: "staff_members"
            referencedColumns: ["school_id", "id"]
          },
          {
            foreignKeyName: "transport_routes_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
        ]
      }
      transport_stops: {
        Row: {
          dropoff_time: string | null
          id: string
          latitude: number | null
          longitude: number | null
          pickup_time: string | null
          route_id: string
          school_id: string
          stop_name: string
          stop_order: number
        }
        Insert: {
          dropoff_time?: string | null
          id?: string
          latitude?: number | null
          longitude?: number | null
          pickup_time?: string | null
          route_id: string
          school_id: string
          stop_name: string
          stop_order: number
        }
        Update: {
          dropoff_time?: string | null
          id?: string
          latitude?: number | null
          longitude?: number | null
          pickup_time?: string | null
          route_id?: string
          school_id?: string
          stop_name?: string
          stop_order?: number
        }
        Relationships: [
          {
            foreignKeyName: "transport_stops_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "transport_stops_school_id_route_id_fkey"
            columns: ["school_id", "route_id"]
            isOneToOne: false
            referencedRelation: "transport_routes"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      workspace_collaborators: {
        Row: {
          access_level: string
          created_at: string
          invited_by: string | null
          project_id: string
          school_id: string
          user_id: string
        }
        Insert: {
          access_level?: string
          created_at?: string
          invited_by?: string | null
          project_id: string
          school_id: string
          user_id: string
        }
        Update: {
          access_level?: string
          created_at?: string
          invited_by?: string | null
          project_id?: string
          school_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "workspace_collaborators_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "workspace_collaborators_school_id_project_id_fkey"
            columns: ["school_id", "project_id"]
            isOneToOne: false
            referencedRelation: "student_workspace_projects"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
      workspace_files: {
        Row: {
          created_at: string
          file_name: string
          id: string
          object_path: string
          project_id: string
          school_id: string
          uploaded_by: string | null
        }
        Insert: {
          created_at?: string
          file_name: string
          id?: string
          object_path: string
          project_id: string
          school_id: string
          uploaded_by?: string | null
        }
        Update: {
          created_at?: string
          file_name?: string
          id?: string
          object_path?: string
          project_id?: string
          school_id?: string
          uploaded_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "workspace_files_school_id_fkey"
            columns: ["school_id"]
            isOneToOne: false
            referencedRelation: "schools"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "workspace_files_school_id_project_id_fkey"
            columns: ["school_id", "project_id"]
            isOneToOne: false
            referencedRelation: "student_workspace_projects"
            referencedColumns: ["school_id", "id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      accept_school_invitation: { Args: { p_token: string }; Returns: string }
      bootstrap_school: {
        Args: { p_name: string; p_slug?: string }
        Returns: string
      }
      get_active_school_payment_gateway: {
        Args: { p_school_id: string }
        Returns: string
      }
      get_school_payment_gateway_settings: {
        Args: { p_school_id: string }
        Returns: Json
      }
      platform_manage_payment_gateway_secrets: {
        Args: { p_secrets?: Json }
        Returns: Json
      }
      selcom_get_gateway_config: { Args: never; Returns: Json }
      selcom_get_invoice_balance: {
        Args: { p_invoice_id: string }
        Returns: Json
      }
      selcom_reconcile_token_valid: {
        Args: { p_candidate: string }
        Returns: boolean
      }
      selcom_reconcile_verified_payment: {
        Args: {
          p_amount: number
          p_channel: string
          p_currency_code: string
          p_msisdn_last4: string
          p_order_id: string
          p_payload_hash: string
          p_reference: string
          p_transid: string
        }
        Returns: Json
      }
      set_school_payment_gateway: {
        Args: { p_provider: string; p_school_id: string }
        Returns: Json
      }
      snippe_get_gateway_config: { Args: never; Returns: Json }
      snippe_reconcile_verified_payment: {
        Args: {
          p_amount: number
          p_channel: string
          p_currency_code: string
          p_external_reference: string
          p_order_id: string
          p_payload_hash: string
          p_provider_event_id: string
          p_reference: string
          p_signature_verified: boolean
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends (DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never) = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends (PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never) = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
