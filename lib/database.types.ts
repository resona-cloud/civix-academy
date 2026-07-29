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
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      activity_attempts: {
        Row: {
          attempt_number: number
          content_block_id: string
          id: string
          max_score: number | null
          response: Json
          score: number | null
          started_at: string
          status: Database["public"]["Enums"]["attempt_status"]
          submitted_at: string | null
          user_id: string
        }
        Insert: {
          attempt_number: number
          content_block_id: string
          id?: string
          max_score?: number | null
          response?: Json
          score?: number | null
          started_at?: string
          status?: Database["public"]["Enums"]["attempt_status"]
          submitted_at?: string | null
          user_id: string
        }
        Update: {
          attempt_number?: number
          content_block_id?: string
          id?: string
          max_score?: number | null
          response?: Json
          score?: number | null
          started_at?: string
          status?: Database["public"]["Enums"]["attempt_status"]
          submitted_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "activity_attempts_content_block_id_fkey"
            columns: ["content_block_id"]
            isOneToOne: false
            referencedRelation: "content_blocks"
            referencedColumns: ["id"]
          },
        ]
      }
      audit_events: {
        Row: {
          actor_id: string | null
          created_at: string
          entity_id: string | null
          entity_type: string
          event_type: string
          id: string
          metadata: Json
        }
        Insert: {
          actor_id?: string | null
          created_at?: string
          entity_id?: string | null
          entity_type: string
          event_type: string
          id?: string
          metadata?: Json
        }
        Update: {
          actor_id?: string | null
          created_at?: string
          entity_id?: string | null
          entity_type?: string
          event_type?: string
          id?: string
          metadata?: Json
        }
        Relationships: [
          {
            foreignKeyName: "audit_events_actor_id_fkey"
            columns: ["actor_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      bookmarks: {
        Row: {
          created_at: string
          id: string
          label: string | null
          target_id: string
          target_type: Database["public"]["Enums"]["bookmark_target_type"]
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          label?: string | null
          target_id: string
          target_type: Database["public"]["Enums"]["bookmark_target_type"]
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          label?: string | null
          target_id?: string
          target_type?: Database["public"]["Enums"]["bookmark_target_type"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "bookmarks_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      certificates: {
        Row: {
          certificate_number: string
          certification_id: string
          created_at: string
          expires_at: string | null
          id: string
          issued_at: string
          metadata: Json
          org_id: string
          revoked_at: string | null
          source_lab_submission_id: string | null
          status: Database["public"]["Enums"]["certificate_status"]
          updated_at: string
          user_id: string
        }
        Insert: {
          certificate_number: string
          certification_id: string
          created_at?: string
          expires_at?: string | null
          id?: string
          issued_at?: string
          metadata?: Json
          org_id: string
          revoked_at?: string | null
          source_lab_submission_id?: string | null
          status?: Database["public"]["Enums"]["certificate_status"]
          updated_at?: string
          user_id: string
        }
        Update: {
          certificate_number?: string
          certification_id?: string
          created_at?: string
          expires_at?: string | null
          id?: string
          issued_at?: string
          metadata?: Json
          org_id?: string
          revoked_at?: string | null
          source_lab_submission_id?: string | null
          status?: Database["public"]["Enums"]["certificate_status"]
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "certificates_certification_id_fkey"
            columns: ["certification_id"]
            isOneToOne: false
            referencedRelation: "certifications"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "certificates_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "certificates_source_lab_submission_id_fkey"
            columns: ["source_lab_submission_id"]
            isOneToOne: false
            referencedRelation: "lab_submissions"
            referencedColumns: ["id"]
          },
        ]
      }
      certifications: {
        Row: {
          created_at: string
          description: string
          id: string
          org_id: string
          passing_score: number | null
          slug: string
          status: Database["public"]["Enums"]["content_status"]
          title: string
          updated_at: string
          valid_for_months: number | null
        }
        Insert: {
          created_at?: string
          description?: string
          id?: string
          org_id: string
          passing_score?: number | null
          slug: string
          status?: Database["public"]["Enums"]["content_status"]
          title: string
          updated_at?: string
          valid_for_months?: number | null
        }
        Update: {
          created_at?: string
          description?: string
          id?: string
          org_id?: string
          passing_score?: number | null
          slug?: string
          status?: Database["public"]["Enums"]["content_status"]
          title?: string
          updated_at?: string
          valid_for_months?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "certifications_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
      cohort_members: {
        Row: {
          cohort_id: string
          joined_at: string
          member_type: Database["public"]["Enums"]["cohort_member_type"]
          user_id: string
        }
        Insert: {
          cohort_id: string
          joined_at?: string
          member_type: Database["public"]["Enums"]["cohort_member_type"]
          user_id: string
        }
        Update: {
          cohort_id?: string
          joined_at?: string
          member_type?: Database["public"]["Enums"]["cohort_member_type"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "cohort_members_cohort_id_fkey"
            columns: ["cohort_id"]
            isOneToOne: false
            referencedRelation: "cohorts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "cohort_members_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      cohorts: {
        Row: {
          created_at: string
          end_date: string
          id: string
          name: string
          org_id: string
          program_title: string
          start_date: string
          status: Database["public"]["Enums"]["cohort_status"]
          updated_at: string
        }
        Insert: {
          created_at?: string
          end_date: string
          id?: string
          name: string
          org_id: string
          program_title: string
          start_date: string
          status?: Database["public"]["Enums"]["cohort_status"]
          updated_at?: string
        }
        Update: {
          created_at?: string
          end_date?: string
          id?: string
          name?: string
          org_id?: string
          program_title?: string
          start_date?: string
          status?: Database["public"]["Enums"]["cohort_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "cohorts_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
      content_blocks: {
        Row: {
          block_type: Database["public"]["Enums"]["content_block_type"]
          content: Json
          created_at: string
          fieldbook_article_id: string | null
          id: string
          lesson_page_id: string | null
          position: number
          updated_at: string
        }
        Insert: {
          block_type: Database["public"]["Enums"]["content_block_type"]
          content?: Json
          created_at?: string
          fieldbook_article_id?: string | null
          id?: string
          lesson_page_id?: string | null
          position: number
          updated_at?: string
        }
        Update: {
          block_type?: Database["public"]["Enums"]["content_block_type"]
          content?: Json
          created_at?: string
          fieldbook_article_id?: string | null
          id?: string
          lesson_page_id?: string | null
          position?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "content_blocks_fieldbook_article_id_fkey"
            columns: ["fieldbook_article_id"]
            isOneToOne: false
            referencedRelation: "fieldbook_articles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "content_blocks_lesson_page_id_fkey"
            columns: ["lesson_page_id"]
            isOneToOne: false
            referencedRelation: "lesson_pages"
            referencedColumns: ["id"]
          },
        ]
      }
      courses: {
        Row: {
          certification_id: string | null
          created_at: string
          description: string
          estimated_minutes: number | null
          id: string
          position: number
          slug: string
          status: Database["public"]["Enums"]["content_status"]
          title: string
          updated_at: string
        }
        Insert: {
          certification_id?: string | null
          created_at?: string
          description?: string
          estimated_minutes?: number | null
          id?: string
          position?: number
          slug: string
          status?: Database["public"]["Enums"]["content_status"]
          title: string
          updated_at?: string
        }
        Update: {
          certification_id?: string | null
          created_at?: string
          description?: string
          estimated_minutes?: number | null
          id?: string
          position?: number
          slug?: string
          status?: Database["public"]["Enums"]["content_status"]
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "courses_certification_id_fkey"
            columns: ["certification_id"]
            isOneToOne: false
            referencedRelation: "certifications"
            referencedColumns: ["id"]
          },
        ]
      }
      enrollments: {
        Row: {
          assigned_by: string | null
          cohort_id: string | null
          completed_at: string | null
          course_id: string
          enrolled_at: string
          id: string
          org_id: string
          status: Database["public"]["Enums"]["course_enrollment_status"]
          updated_at: string
          user_id: string
        }
        Insert: {
          assigned_by?: string | null
          cohort_id?: string | null
          completed_at?: string | null
          course_id: string
          enrolled_at?: string
          id?: string
          org_id: string
          status?: Database["public"]["Enums"]["course_enrollment_status"]
          updated_at?: string
          user_id: string
        }
        Update: {
          assigned_by?: string | null
          cohort_id?: string | null
          completed_at?: string | null
          course_id?: string
          enrolled_at?: string
          id?: string
          org_id?: string
          status?: Database["public"]["Enums"]["course_enrollment_status"]
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "enrollments_cohort_id_fkey"
            columns: ["cohort_id"]
            isOneToOne: false
            referencedRelation: "cohorts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "enrollments_course_id_fkey"
            columns: ["course_id"]
            isOneToOne: false
            referencedRelation: "courses"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "enrollments_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "enrollments_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      fieldbook_articles: {
        Row: {
          category: string | null
          created_at: string
          id: string
          slug: string
          status: Database["public"]["Enums"]["content_status"]
          summary: string
          tags: string[]
          title: string
          updated_at: string
        }
        Insert: {
          category?: string | null
          created_at?: string
          id?: string
          slug: string
          status?: Database["public"]["Enums"]["content_status"]
          summary?: string
          tags?: string[]
          title: string
          updated_at?: string
        }
        Update: {
          category?: string | null
          created_at?: string
          id?: string
          slug?: string
          status?: Database["public"]["Enums"]["content_status"]
          summary?: string
          tags?: string[]
          title?: string
          updated_at?: string
        }
        Relationships: []
      }
      glossary_terms: {
        Row: {
          created_at: string
          definition: string
          id: string
          normalized_term: string | null
          source_url: string | null
          status: Database["public"]["Enums"]["content_status"]
          term: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          definition: string
          id?: string
          normalized_term?: string | null
          source_url?: string | null
          status?: Database["public"]["Enums"]["content_status"]
          term: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          definition?: string
          id?: string
          normalized_term?: string | null
          source_url?: string | null
          status?: Database["public"]["Enums"]["content_status"]
          term?: string
          updated_at?: string
        }
        Relationships: []
      }
      lab_scenarios: {
        Row: {
          certification_id: string | null
          course_id: string | null
          created_at: string
          description: string
          id: string
          instructions: Json
          passing_score: number | null
          rubric: Json
          slug: string
          status: Database["public"]["Enums"]["content_status"]
          title: string
          updated_at: string
        }
        Insert: {
          certification_id?: string | null
          course_id?: string | null
          created_at?: string
          description?: string
          id?: string
          instructions?: Json
          passing_score?: number | null
          rubric?: Json
          slug: string
          status?: Database["public"]["Enums"]["content_status"]
          title: string
          updated_at?: string
        }
        Update: {
          certification_id?: string | null
          course_id?: string | null
          created_at?: string
          description?: string
          id?: string
          instructions?: Json
          passing_score?: number | null
          rubric?: Json
          slug?: string
          status?: Database["public"]["Enums"]["content_status"]
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "lab_scenarios_certification_id_fkey"
            columns: ["certification_id"]
            isOneToOne: false
            referencedRelation: "certifications"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "lab_scenarios_course_id_fkey"
            columns: ["course_id"]
            isOneToOne: false
            referencedRelation: "courses"
            referencedColumns: ["id"]
          },
        ]
      }
      lab_submissions: {
        Row: {
          attempt_number: number
          created_at: string
          evaluated_at: string | null
          evaluated_by: string | null
          evaluator_feedback: Json | null
          id: string
          lab_scenario_id: string
          score: number | null
          status: Database["public"]["Enums"]["submission_status"]
          submission: Json
          submitted_at: string | null
          updated_at: string
          user_id: string
        }
        Insert: {
          attempt_number: number
          created_at?: string
          evaluated_at?: string | null
          evaluated_by?: string | null
          evaluator_feedback?: Json | null
          id?: string
          lab_scenario_id: string
          score?: number | null
          status?: Database["public"]["Enums"]["submission_status"]
          submission?: Json
          submitted_at?: string | null
          updated_at?: string
          user_id: string
        }
        Update: {
          attempt_number?: number
          created_at?: string
          evaluated_at?: string | null
          evaluated_by?: string | null
          evaluator_feedback?: Json | null
          id?: string
          lab_scenario_id?: string
          score?: number | null
          status?: Database["public"]["Enums"]["submission_status"]
          submission?: Json
          submitted_at?: string | null
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "lab_submissions_lab_scenario_id_fkey"
            columns: ["lab_scenario_id"]
            isOneToOne: false
            referencedRelation: "lab_scenarios"
            referencedColumns: ["id"]
          },
        ]
      }
      lesson_pages: {
        Row: {
          created_at: string
          id: string
          lesson_id: string
          position: number
          title: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          id?: string
          lesson_id: string
          position: number
          title: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          id?: string
          lesson_id?: string
          position?: number
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "lesson_pages_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
        ]
      }
      lessons: {
        Row: {
          created_at: string
          description: string
          estimated_minutes: number | null
          id: string
          module_id: string
          position: number
          title: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          description?: string
          estimated_minutes?: number | null
          id?: string
          module_id: string
          position: number
          title: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          description?: string
          estimated_minutes?: number | null
          id?: string
          module_id?: string
          position?: number
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "lessons_module_id_fkey"
            columns: ["module_id"]
            isOneToOne: false
            referencedRelation: "modules"
            referencedColumns: ["id"]
          },
        ]
      }
      modules: {
        Row: {
          course_id: string
          created_at: string
          description: string
          id: string
          position: number
          title: string
          updated_at: string
        }
        Insert: {
          course_id: string
          created_at?: string
          description?: string
          id?: string
          position: number
          title: string
          updated_at?: string
        }
        Update: {
          course_id?: string
          created_at?: string
          description?: string
          id?: string
          position?: number
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "modules_course_id_fkey"
            columns: ["course_id"]
            isOneToOne: false
            referencedRelation: "courses"
            referencedColumns: ["id"]
          },
        ]
      }
      notes: {
        Row: {
          author_id: string
          body: string
          created_at: string
          fieldbook_article_id: string | null
          id: string
          lesson_page_id: string | null
          subject_user_id: string | null
          updated_at: string
          visibility: Database["public"]["Enums"]["note_visibility"]
        }
        Insert: {
          author_id: string
          body: string
          created_at?: string
          fieldbook_article_id?: string | null
          id?: string
          lesson_page_id?: string | null
          subject_user_id?: string | null
          updated_at?: string
          visibility?: Database["public"]["Enums"]["note_visibility"]
        }
        Update: {
          author_id?: string
          body?: string
          created_at?: string
          fieldbook_article_id?: string | null
          id?: string
          lesson_page_id?: string | null
          subject_user_id?: string | null
          updated_at?: string
          visibility?: Database["public"]["Enums"]["note_visibility"]
        }
        Relationships: [
          {
            foreignKeyName: "notes_author_id_fkey"
            columns: ["author_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "notes_fieldbook_article_id_fkey"
            columns: ["fieldbook_article_id"]
            isOneToOne: false
            referencedRelation: "fieldbook_articles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "notes_lesson_page_id_fkey"
            columns: ["lesson_page_id"]
            isOneToOne: false
            referencedRelation: "lesson_pages"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "notes_subject_user_id_fkey"
            columns: ["subject_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      organizations: {
        Row: {
          created_at: string
          id: string
          name: string
          slug: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          id?: string
          name: string
          slug: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          id?: string
          name?: string
          slug?: string
          updated_at?: string
        }
        Relationships: []
      }
      profile_roles: {
        Row: {
          granted_at: string
          granted_by: string | null
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Insert: {
          granted_at?: string
          granted_by?: string | null
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Update: {
          granted_at?: string
          granted_by?: string | null
          role?: Database["public"]["Enums"]["app_role"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "profile_roles_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          classification: string | null
          created_at: string
          display_name: string
          id: string
          org_id: string
          status: Database["public"]["Enums"]["profile_status"]
          updated_at: string
        }
        Insert: {
          classification?: string | null
          created_at?: string
          display_name: string
          id: string
          org_id: string
          status?: Database["public"]["Enums"]["profile_status"]
          updated_at?: string
        }
        Update: {
          classification?: string | null
          created_at?: string
          display_name?: string
          id?: string
          org_id?: string
          status?: Database["public"]["Enums"]["profile_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "profiles_org_id_fkey"
            columns: ["org_id"]
            isOneToOne: false
            referencedRelation: "organizations"
            referencedColumns: ["id"]
          },
        ]
      }
      risk_flags: {
        Row: {
          category: string
          created_at: string
          created_by: string
          description: string
          id: string
          learner_id: string
          resolved_at: string | null
          severity: Database["public"]["Enums"]["risk_severity"]
          status: Database["public"]["Enums"]["risk_status"]
          title: string
          updated_at: string
        }
        Insert: {
          category: string
          created_at?: string
          created_by: string
          description?: string
          id?: string
          learner_id: string
          resolved_at?: string | null
          severity: Database["public"]["Enums"]["risk_severity"]
          status?: Database["public"]["Enums"]["risk_status"]
          title: string
          updated_at?: string
        }
        Update: {
          category?: string
          created_at?: string
          created_by?: string
          description?: string
          id?: string
          learner_id?: string
          resolved_at?: string | null
          severity?: Database["public"]["Enums"]["risk_severity"]
          status?: Database["public"]["Enums"]["risk_status"]
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "risk_flags_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "risk_flags_learner_id_fkey"
            columns: ["learner_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      user_progress: {
        Row: {
          completed_at: string | null
          completed_page_ids: string[]
          id: string
          last_page_id: string | null
          lesson_id: string
          progress_percent: number
          started_at: string | null
          status: Database["public"]["Enums"]["progress_status"]
          updated_at: string
          user_id: string
          visited_page_ids: string[]
        }
        Insert: {
          completed_at?: string | null
          completed_page_ids?: string[]
          id?: string
          last_page_id?: string | null
          lesson_id: string
          progress_percent?: number
          started_at?: string | null
          status?: Database["public"]["Enums"]["progress_status"]
          updated_at?: string
          user_id: string
          visited_page_ids?: string[]
        }
        Update: {
          completed_at?: string | null
          completed_page_ids?: string[]
          id?: string
          last_page_id?: string | null
          lesson_id?: string
          progress_percent?: number
          started_at?: string | null
          status?: Database["public"]["Enums"]["progress_status"]
          updated_at?: string
          user_id?: string
          visited_page_ids?: string[]
        }
        Relationships: [
          {
            foreignKeyName: "user_progress_last_page_id_lesson_id_fkey"
            columns: ["last_page_id", "lesson_id"]
            isOneToOne: false
            referencedRelation: "lesson_pages"
            referencedColumns: ["id", "lesson_id"]
          },
          {
            foreignKeyName: "user_progress_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      can_access_course: {
        Args: { target_course_id: string }
        Returns: boolean
      }
      has_role: {
        Args: { required_role: Database["public"]["Enums"]["app_role"] }
        Returns: boolean
      }
      instructor_can_access_learner: {
        Args: { target_learner_id: string }
        Returns: boolean
      }
      is_cohort_member: { Args: { target_cohort_id: string }; Returns: boolean }
    }
    Enums: {
      app_role:
        | "admin"
        | "instructor"
        | "reviewer"
        | "trainee"
        | "certified_agent"
        | "zone_manager"
        | "sales_rep"
        | "sourcing_operator"
        | "developer"
        | "founder"
      attempt_status: "started" | "submitted" | "passed" | "failed"
      bookmark_target_type: "lesson_page" | "fieldbook_article" | "lab_scenario"
      certificate_status: "active" | "expired" | "revoked"
      cohort_member_type: "instructor" | "trainee"
      cohort_status: "planned" | "active" | "completed" | "archived"
      content_block_type:
        | "rich_text"
        | "image"
        | "video"
        | "callout"
        | "download"
        | "activity"
      content_status: "draft" | "published" | "archived"
      course_enrollment_status:
        | "assigned"
        | "in_progress"
        | "completed"
        | "withdrawn"
      note_visibility: "private" | "instructors" | "reviewers"
      profile_status: "active" | "inactive" | "suspended"
      progress_status: "not_started" | "in_progress" | "completed"
      risk_severity: "low" | "medium" | "high"
      risk_status: "open" | "monitoring" | "resolved"
      submission_status:
        | "draft"
        | "submitted"
        | "reviewed"
        | "passed"
        | "failed"
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
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
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
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
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
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
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
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
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
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      app_role: [
        "admin",
        "instructor",
        "reviewer",
        "trainee",
        "certified_agent",
        "zone_manager",
        "sales_rep",
        "sourcing_operator",
        "developer",
        "founder",
      ],
      attempt_status: ["started", "submitted", "passed", "failed"],
      bookmark_target_type: [
        "lesson_page",
        "fieldbook_article",
        "lab_scenario",
      ],
      certificate_status: ["active", "expired", "revoked"],
      cohort_member_type: ["instructor", "trainee"],
      cohort_status: ["planned", "active", "completed", "archived"],
      content_block_type: [
        "rich_text",
        "image",
        "video",
        "callout",
        "download",
        "activity",
      ],
      content_status: ["draft", "published", "archived"],
      course_enrollment_status: [
        "assigned",
        "in_progress",
        "completed",
        "withdrawn",
      ],
      note_visibility: ["private", "instructors", "reviewers"],
      profile_status: ["active", "inactive", "suspended"],
      progress_status: ["not_started", "in_progress", "completed"],
      risk_severity: ["low", "medium", "high"],
      risk_status: ["open", "monitoring", "resolved"],
      submission_status: ["draft", "submitted", "reviewed", "passed", "failed"],
    },
  },
} as const
