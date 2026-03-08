# Ruff Life — RALPH Plan

---

## R — Requirements

### Product
A multi-tenant SaaS PWA for dog boarding and daycare facilities. Ruff Life Resort is the reference client (all features on). Future clients get a subset of features based on their configuration.

### MVP Scope (Ruff Life)
Full admin + employee feature set — everything in the mockup except placeholder screens:

**Employee:**
- Login / logout
- NFC tag tap → Friend action menu (feed, medicate, add-on, care note, photo, check out)
- Yard NFC tag → check into/out of yard
- Care note entry (dictate or type → attach via NFC or color group)
- Photo capture → attach via NFC or color group
- Tiff / altercation report (scoped to active yard)
- Color groups view + reassignment
- Today's schedule view

**Admin:**
- Dashboard (stats, conflict alerts)
- Check in friend (4-step flow)
- Check out friend
- Scheduling / booking calendar
- Parent directory (with dog profile pills)
- Vaccination records
- Yard assignment (multiselect dropdowns per yard, conflict detection)
- Color groups management
- Flagged issues
- Events calendar
- Message Yard
- Kennels & Rooms management
- Settings
- Ask AI

**Deferred (placeholder screens):**
- Send SMS
- Email inbox
- Staff assignments
- Daily report

---

## A — Architecture

### Tech Stack
| Layer | Technology |
|---|---|
| Frontend | Next.js (React) |
| Database | Supabase (PostgreSQL) |
| Auth | Supabase Auth |
| File storage | Supabase Storage |
| Real-time | Supabase Realtime |
| Hosting | Vercel |
| SMS | Twilio |
| NFC | URL-based tags |

### Multi-Tenancy
- **Model:** Shared database with `tenant_id` on every table
- **Isolation:** Supabase Row Level Security (RLS) policies enforce tenant data separation
- Each tenant has a row in the `tenants` table
- Each tenant has a config row in `tenant_config` (feature flags + branding)

### Authentication
- Supabase Auth handles all login/logout
- Two roles: `admin` and `employee`
- **Employee onboarding:** Admin invites by email → employee receives setup link → sets password
- No self-signup — all accounts are created by admins within their tenant

### NFC
- Each entity (dog, room, kennel, yard) gets a UUID at creation
- NFC tag is programmed with a URL: `https://[domain]/scan/[type]/[id]`
  - e.g. `https://app.ruffliferesort.com/scan/dog/abc-123`
- App reads entity type + ID from URL, loads action menu
- Works on all devices including iPhone (no Web NFC API dependency)

### Real-Time
- Supabase Realtime subscriptions on key tables (feedings, medications, incidents)
- Admin dashboard updates live as employees log actions
- Conflict alerts push immediately when enemy flag added post-assignment

### Feature Flags
- Stored per tenant in `tenant_config` table
- UI reads config at login and renders only enabled features
- Disabled features: nav items hidden, screens don't render, API routes return 403

### Branding / Theming
- Per-tenant: primary color, logo URL, business name, tone, terminology overrides
- Tone options: `playful` (emoji-heavy, Ruff Life style) vs `professional` (clean, neutral)
- Terminology: dog_term, owner_term, incident_term configurable per tenant

---

## Schema Changes Required

The existing `schema.sql` needs the following updates before build begins:

1. **Add `tenants` table** — one row per client
2. **Add `tenant_config` table** — feature flags + branding per tenant
3. **Add `tenant_id UUID` column** to every table
4. **Rename `qr_codes` → `nfc_tags`** and `qr_code_id` → `nfc_tag_id` throughout
5. **Add `user_invites` table** — for employee invite/onboarding flow
6. **Make color groups flexible** — remove hardcoded enum, allow per-tenant group definitions
7. **Add `care_notes` table** — currently missing (voice_notes exists but care notes are text-based)
8. **Add `sex` and `intact` columns** to `friends` table (currently missing)

---

## L — Loop (Build Order)

Features will be built in this sequence. Each phase is a loop iteration: generate → run → test → refine.

### Phase 1 — Environment & Scaffold
- [ ] Install Node.js, npm, git tools on Mac
- [ ] Create Next.js project (`create-next-app`)
- [ ] Install and configure Supabase client
- [ ] Connect to Supabase project
- [ ] Set up Vercel deployment (auto-deploy from GitHub)

### Phase 2 — Database
- [ ] Update schema.sql with all required changes
- [ ] Run migrations in Supabase
- [ ] Seed Ruff Life tenant + config
- [ ] Seed sample data (dogs, parents, rooms, kennels, yards)
- [ ] Configure Row Level Security policies

### Phase 3 — Auth
- [ ] Login screen (email + password)
- [ ] Role detection → redirect to employee home or admin home
- [ ] Employee invite flow (admin sends invite → employee sets password)
- [ ] Session persistence + logout

### Phase 4 — NFC Routing
- [ ] `/scan/[type]/[id]` dynamic route
- [ ] Entity lookup + action menu render
- [ ] Auth gate (redirect to login if not logged in, return after)

### Phase 5 — Employee Core
- [ ] Employee home screen
- [ ] Friend action menu (feed, medicate, add-on, care note, photo)
- [ ] Feed confirm sheet + in-sheet success + logging
- [ ] Medicate confirm sheet + in-sheet success + logging
- [ ] Add On sheet (assigned add-ons only) + confirm + in-sheet success + logging + SMS trigger
- [ ] Care note entry (1-step from Friend menu; 2-step from Employee bottom nav)
- [ ] Photo capture (1-step from Friend menu; 2-step from Employee bottom nav)

### Phase 6 — Employee Yard
- [ ] Yard NFC check-in / check-out
- [ ] Tiff / altercation report
- [ ] Color groups view + reassignment

### Phase 7 — Admin Core
- [ ] Admin dashboard (stats, conflict alerts, real-time)
- [ ] Check-in flow (4 steps)
- [ ] Check-out flow
- [ ] Parent directory + dog profiles
- [ ] Vaccination records

### Phase 8 — Admin Operations
- [ ] Scheduling / booking calendar
- [ ] Yard assignment (multiselect, conflict detection)
- [ ] Kennels & Rooms management
- [ ] Flagged issues
- [ ] Events calendar
- [ ] Message Yard

### Phase 9 — Notifications
- [ ] Twilio SMS integration
- [ ] Parent notification triggers (check-in, check-out, add-on, photo)
- [ ] Admin conflict alerts (real-time)

### Phase 10 — Settings & Config
- [ ] Admin settings screen
- [ ] Feature flag toggle UI (for future tenant management)
- [ ] Branding config

### Phase 11 — Ask AI
- [ ] Natural language query interface
- [ ] Connect to live operational data

---

## P — Polish
- Performance audit (load times, real-time lag)
- Offline queue for NFC actions (service worker)
- Add to Home Screen prompt on first login
- Cross-device testing (iPhone Safari, Android Chrome, desktop)
- Error handling + empty states throughout

---

## H — Handoff
- Domain setup with Ruff Life (subdomain or dedicated domain — TBD with client)
- Staff onboarding (walk-through for "Add to Home Screen")
- NFC tag programming + physical label production
- Admin training session
- Data migration (TBD — check if Ruff Life has existing records to import)

---

## Open Items
- Domain: client has one but it's live — need to discuss subdomain or migration plan
- Data migration: unknown if Ruff Life has existing records to import
- Employee account setup: confirm invite-by-email flow with client
