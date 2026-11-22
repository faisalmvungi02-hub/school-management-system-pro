# PLUS OS role and permission model

This document records the live school-role model inspected on 2026-11-22. It is an implementation reference, not a replacement for database authorization or RLS.

## Live role inventory

The production database currently defines 15 school roles and 252 role-permission mappings.

| Role code | Display name | Assigned permissions |
|---|---|---:|
| `school_owner` | School Owner | 55 |
| `school_admin` | School Administrator | 54 |
| `head_teacher` | Head Teacher | 30 |
| `academic_master` | Academic Master | 16 |
| `teacher` | Teacher | 14 |
| `department_head` | Department Head | 13 |
| `admissions_officer` | Admissions Officer | 11 |
| `student` | Student | 11 |
| `district_deo` | District Education Officer | 9 |
| `parent` | Parent or Guardian | 8 |
| `sports_coach` | Sports Coach | 7 |
| `bursar` | Bursar | 6 |
| `discipline_officer` | Discipline Officer | 6 |
| `district_hro` | District Human Resources Officer | 6 |
| `guidance_counselor` | Guidance and Counseling | 6 |

## Permission domains

The current permission catalogue covers:

- School profile, workspace membership and invitations
- Academic years, classes, subjects, enrollments and timetables
- Assessments, results, assignments and submissions
- Attendance, staff and student records
- Admissions and guardian relationships
- Finance, fee plans, invoices, payment records and school gateway selection
- Communications, documents and audit history
- Guidance/counselling and discipline
- Library, meals, sports, assets and transport
- AI usage and student workspace

## Important role boundaries

- **School Owner** has the broadest school permissions, including subscription management.
- **School Administrator** has broad day-to-day operational permissions but does not have the owner's subscription-management permission.
- **Head Teacher** has wide academic and school-operational visibility; finance is read-only in the current mapping.
- **Bursar** has finance permissions and student read access; this role should not inherit unrelated academic editing privileges.
- **Academic Master** and **Department Head** have academic planning, assessment and assignment responsibilities.
- **Teacher** access is class/assignment scoped and must not become school-wide student access.
- **Student** and **Parent/Guardian** roles are designed for self/linked-child data rather than unrestricted school-wide records.
- **District DEO/HRO** roles are district oversight roles; district scope must be enforced by database policies, not merely by hiding UI links.
- **Platform Administrator** is a separate platform-level identity, controlled by the server-managed `app_metadata.platform_admin` claim; it is not a school membership role.

## Product gaps to resolve before expanding dashboards

The live role catalogue does not yet include separate roles for every operational function in the PLUS OS vision. In particular, food-service and transport operations currently rely on permissions assigned to broader roles; there is no dedicated food manager or transport manager role in this 15-role inventory.

Do not invent these roles in the frontend. First define the responsibilities, least-privilege permission set, database seed/migration and approval workflow, then add the corresponding dashboard.

## Phase 3 — role-based school workspaces

The next implementation phase should build a shared authenticated school workspace shell and render role-specific navigation from the user's active school membership and permission set.

Required acceptance criteria:

1. A user with multiple school memberships selects an active school workspace explicitly.
2. The active membership and assigned roles are loaded from Supabase under RLS.
3. Navigation items are derived from permission codes; role names alone are not sufficient.
4. Every server action/RPC and every table access is independently protected by database authorization and RLS.
5. A user cannot access another school's workspace by editing a URL, query parameter or client-side state.
6. Student and parent views remain scoped to the student's own or linked-child records.
7. District roles see only schools and records within their authorized district scope.
8. Missing roles are not silently mapped to School Administrator or School Owner.
9. Permission changes take effect after token/session refresh and are rechecked on protected operations.

## Security rule

The UI is a navigation and usability layer only. It must never be the security boundary. Supabase RLS, trusted RPC authorization and server-side checks remain authoritative.
