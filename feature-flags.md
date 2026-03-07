# Multi-Tenant Feature Flags

This app is a shared platform. Each client (tenant) has a configuration that controls which features are active and how the UI is branded. The mockup is built for Ruff Life — flags reflect their full configuration.

---

## Platform Model

- **Shared platform** — all tenants log into the same app; each sees only their own data and feature set
- **Per-tenant config** — stored in the database, loaded at login, controls feature visibility and branding
- **Ruff Life** is the reference implementation (all features on)

---

## Feature Flags

### Core — always on for all tenants

| Feature | Notes |
|---|---|
| Dog profiles | Name, breed, age, sex, intact status, weight, photo |
| Parent / owner profiles | Contact info, linked dogs |
| Check-in / Check-out | Basic boarding workflow |
| Kennel & room management | Assignment, status tracking |
| Feed logging | Per-dog, timestamped |
| Medication logging | Per-dog, timestamped |
| Care notes | Text notes attached to a dog |
| Employee login / logout | Role-based access (admin vs. employee) |

---

### Optional Modules

| Flag | Feature | Notes |
|---|---|---|
| `yards` | Yards & color groups | Facilities without outdoor yards or group play don't need this |
| `yard_assignment` | Yard assignment screen | Depends on `yards` |
| `color_groups` | Color group management | Depends on `yards`; could be enabled independently |
| `tiff` | Tiff / altercation reports | Depends on `yards`; scoped to active yard |
| `nfc` | NFC tag scanning | Facilities using manual lookup don't need this |
| `addons` | Add-on services | Not all facilities offer add-ons |
| `photos` | Photo capture & attachment | Optional; requires camera access |
| `sms` | SMS parent notifications | Requires Twilio setup + business phone number |
| `email_inbox` | Email inbox | Requires custom domain email; not needed for Gmail-only operators |
| `events_calendar` | Events calendar | Not relevant to all facility types |
| `vaccination_records` | Vaccination record tracking | Some facilities manage this externally |
| `scheduling` | Scheduling / booking calendar | May not be needed if bookings handled elsewhere |
| `staff_assignments` | Staff assignment management | Not needed for solo operators |
| `daily_report` | Daily report | Optional reporting module |
| `billing` | Billing & payments | Facilities using external billing don't need this |
| `ask_ai` | Ask AI (natural language queries) | Premium feature |
| `buddies_enemies` | Buddies & enemies tracking | Depends on `yards` / group play |

---

## Branding & Theming

Each tenant can configure:

| Setting | Ruff Life Value | Notes |
|---|---|---|
| `business_name` | Ruff Life Resort | Displayed in header and notifications |
| `primary_color` | `#1D8A92` (teal) | Main brand color throughout the UI |
| `primary_color_dark` | `#176970` | Used for gradients and active states |
| `logo_url` | *(TBD)* | Displayed on login screen and header |
| `tone` | `playful` | Controls emoji usage and copy style; options: `playful` / `professional` |
| `dog_term` | `Friend` | What dogs are called in the UI (e.g. "Friend", "Dog", "Pet", "Guest") |
| `incident_term` | `Tiff` | What altercation reports are called (e.g. "Tiff", "Incident", "Report") |
| `owner_term` | `Parent` | What owners are called (e.g. "Parent", "Owner", "Client") |

---

## Notes

- Feature flags control **visibility only** in the UI — screens and nav items for disabled features simply don't render
- The database schema should support all features; unused tables are just empty per tenant
- Terminology overrides (`dog_term`, `owner_term`, etc.) should be applied globally via a config lookup — hardcoded strings like "Friend" or "Parent" in the UI need to reference the config, not be literal
- `tone: playful` enables emoji in headers, button labels, and notifications; `tone: professional` strips them out and uses neutral copy
