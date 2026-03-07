-- Ruff Life Resort — Sample Database Schema
-- PostgreSQL / Supabase

---

-- Parents (Owners)
CREATE TABLE parents (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name    TEXT NOT NULL,
  last_name     TEXT NOT NULL,
  phone         TEXT,
  email         TEXT,
  notify_sms    BOOLEAN DEFAULT true,
  notify_email  BOOLEAN DEFAULT false,
  created_at    TIMESTAMPTZ DEFAULT now()
);

-- Friends (Dogs)
CREATE TABLE friends (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id            UUID REFERENCES parents(id),
  name                 TEXT NOT NULL,
  breed                TEXT,
  weight_lbs           DECIMAL,
  dob                  DATE,
  color_group          TEXT CHECK (color_group IN ('blue','pink','purple','yellow','orange','royal')),
  color_group_status   TEXT CHECK (color_group_status IN ('assigned','evaluated')) DEFAULT 'assigned',
  feeding_instructions TEXT,
  special_care_notes   TEXT,
  photo_url            TEXT,
  qr_code_id           UUID,
  is_active            BOOLEAN DEFAULT true,
  created_at           TIMESTAMPTZ DEFAULT now()
);

-- Users (shared table for Admin + Employee login)
CREATE TABLE users (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name  TEXT NOT NULL,
  last_name   TEXT NOT NULL,
  email       TEXT UNIQUE NOT NULL,
  phone       TEXT,
  role        TEXT CHECK (role IN ('admin','employee')) NOT NULL,
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- Rooms
CREATE TABLE rooms (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          TEXT NOT NULL,
  size_category TEXT CHECK (size_category IN ('standard','suite','large_suite')),
  status        TEXT CHECK (status IN ('vacant','occupied','cleaning')) DEFAULT 'vacant',
  qr_code_id    UUID,
  created_at    TIMESTAMPTZ DEFAULT now()
);

-- Kennels (Containers)
CREATE TABLE kennels (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id     UUID REFERENCES rooms(id),
  label       TEXT,
  size        TEXT,
  status      TEXT CHECK (status IN ('vacant','occupied','cleaning')) DEFAULT 'vacant',
  qr_code_id  UUID,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- Yards
CREATE TABLE yards (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          TEXT NOT NULL,
  max_capacity  INT,
  qr_code_id    UUID,
  created_at    TIMESTAMPTZ DEFAULT now()
);

-- Color Groups (reference table)
CREATE TABLE color_groups (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT CHECK (name IN ('blue','pink','purple','yellow','orange','royal')) UNIQUE,
  description TEXT  -- e.g. "Intact male", "Difficult dogs"
);

---
-- Assignments & History
---

-- Room assignments (friend → room)
CREATE TABLE room_assignments (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  friend_id   UUID REFERENCES friends(id),
  room_id     UUID REFERENCES rooms(id),
  kennel_id   UUID REFERENCES kennels(id),
  assigned_at TIMESTAMPTZ DEFAULT now(),
  removed_at  TIMESTAMPTZ
);

-- Color group change history
CREATE TABLE color_group_history (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  friend_id   UUID REFERENCES friends(id),
  from_group  TEXT,
  to_group    TEXT,
  changed_by  UUID REFERENCES users(id),
  reason      TEXT,
  changed_at  TIMESTAMPTZ DEFAULT now()
);

-- Yard → Color Group assignments
CREATE TABLE yard_color_groups (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  yard_id      UUID REFERENCES yards(id),
  color_group  TEXT,
  assigned_at  TIMESTAMPTZ DEFAULT now(),
  removed_at   TIMESTAMPTZ
);

-- Yard sessions (individual dog in/out)
CREATE TABLE yard_sessions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  yard_id     UUID REFERENCES yards(id),
  friend_id   UUID REFERENCES friends(id),
  monitor_id  UUID REFERENCES users(id),
  entered_at  TIMESTAMPTZ DEFAULT now(),
  exited_at   TIMESTAMPTZ
);

-- Enemy pairs (dogs that must not share a yard)
CREATE TABLE enemy_pairs (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  friend_a_id  UUID REFERENCES friends(id),
  friend_b_id  UUID REFERENCES friends(id),
  reason       TEXT,
  severity     TEXT CHECK (severity IN ('caution','do_not_pair')) DEFAULT 'do_not_pair',
  created_by   UUID REFERENCES users(id),
  created_at   TIMESTAMPTZ DEFAULT now()
);

---
-- Daily Operations
---

-- Bookings / Reservations
CREATE TABLE bookings (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  friend_id      UUID REFERENCES friends(id),
  parent_id      UUID REFERENCES parents(id),
  service        TEXT CHECK (service IN ('daycare','boarding')),
  check_in_date  DATE,
  check_out_date DATE,
  room_id        UUID REFERENCES rooms(id),
  status         TEXT CHECK (status IN ('reserved','active','checked_out','cancelled')),
  created_at     TIMESTAMPTZ DEFAULT now()
);

-- Feeding records
CREATE TABLE feedings (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  friend_id     UUID REFERENCES friends(id),
  booking_id    UUID REFERENCES bookings(id),
  meal          TEXT CHECK (meal IN ('morning','midday','evening')),
  food          TEXT,
  amount        TEXT,
  notes         TEXT,
  completed_by  UUID REFERENCES users(id),
  completed_at  TIMESTAMPTZ DEFAULT now()
);

-- Medication instructions (set at check-in)
CREATE TABLE medication_instructions (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  friend_id         UUID REFERENCES friends(id),
  booking_id        UUID REFERENCES bookings(id),
  medication_name   TEXT NOT NULL,
  dose              TEXT,
  instructions      TEXT,
  max_doses_per_day INT DEFAULT 1,
  created_at        TIMESTAMPTZ DEFAULT now()
);

-- Medication administration records
CREATE TABLE medication_records (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  instruction_id   UUID REFERENCES medication_instructions(id),
  friend_id        UUID REFERENCES friends(id),
  administered_by  UUID REFERENCES users(id),
  administered_at  TIMESTAMPTZ DEFAULT now(),
  notes            TEXT
);

-- Add-ons / Enrichment catalog
CREATE TABLE addons (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name             TEXT NOT NULL,
  price            DECIMAL,
  duration_minutes INT
);

-- Scheduled add-ons per dog per stay
CREATE TABLE scheduled_addons (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  friend_id     UUID REFERENCES friends(id),
  booking_id    UUID REFERENCES bookings(id),
  addon_id      UUID REFERENCES addons(id),
  scheduled_at  TIMESTAMPTZ,
  completed_at  TIMESTAMPTZ,
  completed_by  UUID REFERENCES users(id)
);

---
-- Documentation
---

-- Photos
CREATE TABLE photos (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  friend_id      UUID REFERENCES friends(id),  -- null if color group photo
  color_group    TEXT,                          -- null if individual photo
  taken_by       UUID REFERENCES users(id),
  url            TEXT NOT NULL,
  type           TEXT CHECK (type IN ('daily_update','marketing','incident')),
  sent_to_parent BOOLEAN DEFAULT false,
  sent_at        TIMESTAMPTZ,
  created_at     TIMESTAMPTZ DEFAULT now()
);

-- Voice notes
CREATE TABLE voice_notes (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type  TEXT CHECK (entity_type IN ('friend','room','kennel','yard','incident')),
  entity_id    UUID,
  recorded_by  UUID REFERENCES users(id),
  url          TEXT NOT NULL,
  created_at   TIMESTAMPTZ DEFAULT now()
);

-- Incidents
CREATE TABLE incidents (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type               TEXT CHECK (type IN ('dog_fight','injury','illness','escape_attempt','other')),
  severity           TEXT CHECK (severity IN ('minor','moderate','serious')),
  description        TEXT,
  location_type      TEXT CHECK (location_type IN ('room','yard')),
  location_id        UUID,
  reported_by        UUID REFERENCES users(id),
  follow_up_required BOOLEAN DEFAULT false,
  follow_up_complete BOOLEAN DEFAULT false,
  occurred_at        TIMESTAMPTZ DEFAULT now()
);

-- Dogs involved in an incident (many-to-many)
CREATE TABLE incident_friends (
  incident_id  UUID REFERENCES incidents(id),
  friend_id    UUID REFERENCES friends(id),
  PRIMARY KEY (incident_id, friend_id)
);

---
-- Admin & Reporting
---

-- Performance notes (daily)
CREATE TABLE performance_notes (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id  UUID REFERENCES users(id),
  written_by   UUID REFERENCES users(id),
  note         TEXT NOT NULL,
  created_at   TIMESTAMPTZ DEFAULT now()
);

-- Tasks
CREATE TABLE tasks (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type          TEXT CHECK (type IN ('feeding','medication','addon','photo','cleaning','other')),
  assigned_to   UUID REFERENCES users(id),
  friend_id     UUID REFERENCES friends(id),
  room_id       UUID REFERENCES rooms(id),
  yard_id       UUID REFERENCES yards(id),
  due_at        TIMESTAMPTZ,
  completed_at  TIMESTAMPTZ,
  completed_by  UUID REFERENCES users(id),
  status        TEXT CHECK (status IN ('pending','in_progress','completed','skipped')) DEFAULT 'pending',
  created_at    TIMESTAMPTZ DEFAULT now()
);

-- Daily reports (per dog per day)
CREATE TABLE daily_reports (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  friend_id       UUID REFERENCES friends(id),
  report_date     DATE NOT NULL,
  mood_notes      TEXT,
  sent_to_parent  BOOLEAN DEFAULT false,
  sent_at         TIMESTAMPTZ,
  generated_at    TIMESTAMPTZ DEFAULT now()
);

-- SMS notifications log
CREATE TABLE notifications (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id   UUID REFERENCES parents(id),
  friend_id   UUID REFERENCES friends(id),
  trigger     TEXT,  -- checkin, checkout, feeding, medication, incident, addon, daily_report
  message     TEXT,
  status      TEXT CHECK (status IN ('pending','sent','failed')) DEFAULT 'pending',
  sent_at     TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- Calendar events
CREATE TABLE calendar_events (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title        TEXT NOT NULL,
  description  TEXT,
  event_date   TIMESTAMPTZ,
  created_by   UUID REFERENCES users(id),
  created_at   TIMESTAMPTZ DEFAULT now()
);

-- Calendar invites
CREATE TABLE calendar_invites (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id    UUID REFERENCES calendar_events(id),
  channel     TEXT CHECK (channel IN ('sms','email')),
  recipient   TEXT,  -- phone or email
  sent_at     TIMESTAMPTZ,
  status      TEXT CHECK (status IN ('pending','sent','failed')) DEFAULT 'pending'
);

-- QR codes
CREATE TABLE qr_codes (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type  TEXT CHECK (entity_type IN ('friend','room','kennel','yard')),
  entity_id    UUID,
  is_active    BOOLEAN DEFAULT true,
  created_at   TIMESTAMPTZ DEFAULT now()
);
