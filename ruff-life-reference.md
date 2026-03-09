# Ruff Life Resort — Reference

---

## Definitions

**Entity** — a person, place, or thing on which an action can be taken. Entities persist over time and have state.

**Action** — something done to or on behalf of an entity. Actions that are point-in-time events (repeatable but each instance is a discrete timestamped record) are noted as such.

---

## Entities

### Friend (Dog)
- Tap NFC tag for action menu
  - Feed
  - Medicate
  - Perform Add On (shows only today's assigned add-ons; empty state if none)
  - Care Note → 1-step from Friend menu (dog identity known from NFC scan; no attachment step needed)
  - Photo → 1-step from Friend menu (same; no attachment step needed)
  - Special Care Note (pinned to action menu footer; set at check-in)
- Friend profile header shows: name, breed, age, color group pill, room pill, kennel pill
- Each action confirms in-sheet with a success panel (auto-closes after 2 seconds)
- Check-in and check-out are both handled via Admin, not the Friend action menu

---

### Parent (Owner)
- Create profile
- Link to friend(s)
- Update contact info
- Set notification preferences
- Accessible via Admin Home → Parent Directory
  - Search by parent name or dog name
  - View phone, email
  - Quick contact icons

---

### Admin
- View dashboard (stats: pending bookings, arriving today, checked in; conflict alerts)
- View today's check-ins / arriving today list
- Check in a friend (4-step flow: NFC/Belongings → Groups/Kennels → Schedule → Done)
- Check out a friend (2-step flow: select from list → confirm → done with SMS notification)
- View and manage scheduling (day-by-day calendar with room/kennel assignment)
- Assign color group to yard
- Resolve yard conflict (reassign group, move group, or reassign dog)
- View flagged issues (filter by status: open / in-progress / resolved)
- View and manage parent directory
- View and manage vaccination records
- View and manage events calendar (add events)
- Message Yard (send to all employees checked into selected yard(s))
- Send SMS (to parents/owners)
- Manage kennels and rooms (add, edit, assign status)
- Configure settings (facility, alerts, billing, integrations, security, legal)
- Ask AI (query live operational data via natural-language prompt)
- (Planned) View daily report
- (Planned) Email inbox
- (Planned) Staff assignments

---

### Employee
- Log in / Log out (🚪 icon in teal header, top-right)
- View today's schedule (color-coded calendar, 7 AM – 3 PM)
- Tap NFC Tags Active pill → Friend action menu
- Complete tasks via Friend NFC tag: feed, medicate, add-on, care note, photo, check out
- Check into a yard via Yard NFC tag (sets active yard context)
- Submit Tiff (point-in-time action scoped to active yard)
- View and reassign color groups (Groups tab)
- (Planned) View My Schedule (bottom nav item, screen not yet built)

---

### Room
- Tap NFC tag for action menu
  - Mark as being cleaned
  - Mark as clean
  - Flag maintenance issue
- Managed via Admin Home → Kennels & Rooms → Rooms tab
  - Edit room name/number
  - Assign kennel(s) to room
  - Set status: Ready | Cleaning | Offline
  - Add or remove rooms

---

### Kennel
- Tap NFC tag for action menu
  - Assign friend
  - Unassign friend
  - Mark as being cleaned
  - Mark as clean
  - Flag maintenance issue
- Kennel number displayed as a pill on the Friend action menu header
- Managed via Admin Home → Kennels & Rooms → Kennels tab
  - Edit kennel ID
  - Assign kennel to a room
  - Set status: Available | Cleaning | Offline
  - Add or remove kennels

---

### Yard
- Tap NFC tag for action menu
  - Check Into Yard (sets employee's active yard; scopes Tiff and admin messaging)
  - Check Out of Yard
  - Flag maintenance / safety issue

**6 Yards:**
| Yard | Typical Group | Notes |
|---|---|---|
| Yard 1 | Blue | |
| Yard 2 | Pink | |
| Yard 3 | Purple | |
| Yard 4 | Yellow | |
| Yard 5 | Orange | |
| Yard 6 | Royal | |

---

### Color Group
- Reassign dog (via Color Groups tab bottom sheet, with optional dictated note)
- Assign to yard (admin)
- Remove from yard
- Used as attachment target for care notes and photos (select one or more groups)
- Notify parent on add-on completion
- Groups can be combined or kept separate depending on numbers; multiple groups can share a yard — subject to enemy conflict check

**6 Color Groups:**
| Color | Profile | Typical Yard |
|---|---|---|
| 🔵 Blue | Intact males | Yard 1 |
| 🩷 Pink | Intact females | Yard 2 |
| 🟣 Purple | Mellow personality | Yard 3 |
| 🟡 Yellow | Easy going & energetic | Yard 4 |
| 🟠 Orange | High energy & opinionated | Yard 5 |
| 👑 Royal | Difficult dogs | Yard 6 |

---

### Events Calendar
- Schedule event (admin)
- View this week's events (admin and employee)
- View upcoming events (admin and employee)
- Send text invite
- Send email invite

---

## Point-in-Time Actions

These are repeatable actions that produce a discrete timestamped record each time they occur. They are not entities.

### Care Note
- Triggered from: Employee Home bottom nav (🎙️ Care Note) or Friend action menu
- **From Friend action menu:** 1-step — dictate or type note, then save. Dog is already identified from NFC scan; no attachment step needed.
- **From Employee bottom nav:** 2-step — dictate/type note → attach via NFC scan or color group selection
- Logged with timestamp + staff name

### Photo
- Triggered from: Employee Home bottom nav (📸 Photo) or Friend action menu
- **From Friend action menu:** 1-step — take photo, then save. Dog already identified; no attachment step needed.
- **From Employee bottom nav:** 2-step — take photo → attach via NFC scan or color group selection
- Logged with timestamp + staff name

### Tiff (Altercation Report)
- Triggered from: Employee bottom nav ⚠️ Tiff
- Scoped to employee's active yard (set via Yard NFC check-in)
- Inputs: dictated note, photo, description, severity (Low / Medium / High)
- Dog assignment happens after submit via bottom sheet (only dogs in active yard shown)
- Logged with timestamp + staff name; admin notified immediately

### Feed
- Triggered from: Friend action menu → Feed → confirm screen (2-tap)
- Logged with timestamp + staff name
- Shows last fed time before confirmation

### Medicate
- Triggered from: Friend action menu → Medicate → confirm screen (2-tap)
- Logged with timestamp + staff name
- Shows medication name + dose before confirmation

### Perform Add On
- Triggered from: Friend action menu → Add On
- Shows only today's assigned add-ons for that dog; empty state if none assigned
- Employee selects add-on → confirm sheet → Yes! → in-sheet success + auto-close
- Parent notified on completion (if SMS enabled)
- Logged with timestamp + staff name

### Check Out (Friend)
- Triggered from: Admin Home → Check Out Friend (not available from Friend action menu)
- Flow: select from checked-in dog list → confirm sheet → done screen with SMS confirmation
- Logged with timestamp + staff name
- Parent notified (if SMS enabled)

---

## Check-In Requirements

The following must be verified/collected during the check-in flow:
- **Vaccination records** — must be on file before check-in is permitted
- **Chip check** — microchip ID confirmed at drop-off
- **Deposit** — collected at or before check-in
- **Feeding notes** — instructions for food type, amount, frequency, restrictions (displayed on Feed confirm screen)
- **Medication notes** — drug name, dose, timing, administration tips (displayed on Medicate confirm screen)
- **Special care note** — general handling notes (pinned to Friend action menu footer)
- **Buddies list** — dogs this friend plays well with

---

## Buddies & Enemies Tracking

Each Friend maintains two relationship lists:

**Buddies** — dogs this friend plays well with
- Stored as mutual relationships (adding A→B also adds B→A)
- Visible on Friend profile
- Used as a positive signal when assigning yard groups

**Enemies** — dogs this friend cannot be in the same yard with
- Stored as mutual relationships
- Triggers hard-block conflict detection during yard assignment
- Admin alerted immediately if enemy flag is added after yard assignment

---

## Admin Settings Structure

Settings are accessible via the ⚙️ icon in the Admin Home teal header.

| Section | Items |
|---|---|
| Facility | Facility Info, Holiday Schedule, Add-On Management |
| Alerts & Notifications | Medication Alert Rules, Feeding Alert Rules, Parent Notification Preferences |
| Billing & Payments | Payment Processing, Fee Rules, Revenue Reports |
| Integrations | Website, T Willow, Social Media (Coming Soon) |
| Account & Security | MFA, Password Management, Account Inactivity Rules |
| Legal | EULA, Owner Agreement, Privacy Policy |

---

## Quick Actions — Admin Home

16 items in a 3-column grid. Items marked *(placeholder)* have no wired screen yet.

Divided by category (no section labels — separated by order). "Quick Actions" label replaced with a horizontal rule.

**Communications**
| # | Label | Icon | Destination |
|---|---|---|---|
| 1 | Notifications | 🔔 | `admin-notifications` |
| 2 | Text Hub | 📱 | `admin-send-sms` |
| 3 | Email Inbox | 📧 | `admin-email-inbox` |
| 4 | Message Yard | 📣 | `admin-message-yard` sheet |
| 5 | Parent Directory | 👤 | `admin-parents` |

**Planning**
| # | Label | Icon | Destination |
|---|---|---|---|
| 6 | Kennel Planning | 📆 | `admin-booked` |
| 7 | Groups | 🐕 | `color-groups` |
| 8 | Yard Assign | 🌿 | `admin-yard-assign` |
| 9 | Staff Assignments | 📋 | `admin-staff` |
| 10 | Kennels & Rooms | 🏠 | `admin-kennels` |
| 11 | Events Calendar | 📅 | `admin-calendar` |
| 12 | Vaccination Records | 💉 | `admin-vaccinations` |

**Reporting**
| # | Label | Icon | Destination |
|---|---|---|---|
| 13 | Daily Report | 📊 | `admin-daily-report` |
| 14 | Flagged Issues | 🚩 | `admin-flagged` |
| 15 | Ask AI | ? | `admin-ask-ai` |

---

## Navigation

### Entry Points

**A. NFC Tag Tap (most common employee action)**
```
Phone taps NFC tag
  → PWA opens (or foregrounds if already open)
  → Identifies tag type (Friend / Room / Kennel / Yard)
  → If not logged in → Login screen → redirect back to tag context
  → Action menu for that entity
```

**B. Direct PWA Launch**
```
Employee opens app from home screen
  → If not logged in → Login (email + password)
  → Role-based home screen
      "Log In as Employee" → Employee Home
      "Log In as Admin"    → Admin Home
```

---

### NFC Signal Indicator

A persistent NFC signal animation (three arcs, highlighting in sequence) appears on select screens:
- **Employee Home** — full teal pill with "NFC Tags Active" label; tapping the pill navigates to the Friend action menu
- **Yard Conflict screen** — pill turns coral/red to signal urgency
- **Events screen (employee)** — small NFC pill in the top-nav bar (display only)

---

### Role-Based Home Screens

**Employee Home**
```
├── 🚪 Logout icon (white circle, top-right of teal header)
├── NFC Tags Active pill (tappable → Friend action menu)
├── Today's Schedule (color-coded calendar, 7 AM – 3 PM)
│     🟠 Orange  = Feeding
│     🟣 Purple  = Medications
│     🩵 Teal    = Cleaning
│     🟡 Yellow  = Add-Ons / Grooming
│     🟢 Green   = Yard Duty
│     🔵 Blue    = Admin / Paperwork
└── Bottom Nav (card-style, 4 items): 🎙️ Care Note | 📸 Photo | 💬 Message | ⚠️ Tiff
└── "Full Month" link above calendar → navigates to employee schedule screen
```

**Admin Home**
```
├── 🚪 Logout icon (white circle, top-right of teal header)
├── ⚙️ Settings icon (white circle, second from right in teal header)
├── Stats: Pending Bookings | Arriving Today (tappable) | Checked In
├── Horizontal rule separating stats from action grid
├── Action grid (3-column, 15 items) grouped by: Communications → Planning → Reporting
└── (No bottom nav — all navigation via action grid or header icons)
```

---

### NFC Tag Action Menus

**Friend (Dog) Tag**
```
Tap tag → Friend profile header (name, breed, age, color group pill, room pill, kennel pill)
  ├── 🍽️ Feed              → confirm sheet → in-sheet success (auto-close 2s)
  ├── 💊 Medicate          → confirm sheet → in-sheet success (auto-close 2s)
  ├── ⭐ Complete Add On   → assigned add-ons list → confirm sheet → in-sheet success (auto-close 2s)
  ├── 🎙️ Care Note         → 1-step entry sheet (dog already known)
  ├── 📸 Photo             → 1-step entry sheet (dog already known)
  ├── 🐕 Change Group      → slide-up sheet; select from color groups → confirm → success (auto-close 2s)
  └── 🏠 Change Kennel     → slide-up sheet; available kennels list → confirm → success (auto-close 2s)
```
Each action card shows contextual info on the right (feeding notes, med name, scheduled add-ons, current group, current kennel).
Note: Check-in and check-out are handled through the Admin page, not the Friend action menu.

**Room Tag**
```
Tap tag → Room card (number, occupants, status)
  ├── Mark as Being Cleaned
  ├── Mark as Clean
  └── Flag Maintenance Issue
```

**Kennel Tag**
```
Tap tag → Kennel card (ID, assigned friend if any, status)
  ├── Assign Friend  [search/select]
  ├── Unassign Friend
  ├── Mark as Being Cleaned
  ├── Mark as Clean
  └── Flag Maintenance Issue
```

**Yard Tag**
```
Tap tag → Yard card (current color groups / dogs present)
  ├── Check Into Yard  (sets employee's current yard context)
  ├── Check Out of Yard
  └── Flag Maintenance / Safety Issue
```

---

### Key Flows

**Check-In Flow (4 steps) — Admin initiated**
```
Admin Home → Check In Friend → select friend from Arriving Today list
  Step 1 — NFC/Belongings: assign NFC tag (animated button), take photo of belongings
  Step 2 — Groups/Kennels: confirm pre-assigned kennel (Change edits inline), select color group via dropdown
  Step 3 — Schedule: toggle feeding/medication, select add-ons via multi-select dropdowns (Training, Wellness, Treats, Holiday, Luxury)
  Step 4 — Done ✓: "Parent Notified — SMS sent"
```
Note: Kennel is pre-assigned via the Scheduling screen. Step 2 confirms it; "Change" shows available kennels inline. Completing check-in removes the dog from the Scheduling screen and updates the unassigned badge count.

**Check-Out Flow — Admin initiated**
```
Admin Home → Check Out Friend
  → List of currently checked-in dogs (searchable)
  → Tap dog → Checkout Confirm → Checkout Done
  → "Parent Notified — SMS sent"
```

**Feed / Medicate Confirm**
```
Friend action menu → Feed (or Medicate)
  → confirm sheet slides up (shows feeding/med notes, dog identity in subheader)
  → "Yes!" → in-sheet success panel with timestamp + staff name → auto-closes (2s)
```

**Add On**
```
Friend action menu → Add On
  → sheet shows today's assigned add-ons only (empty state if none)
  → tap add-on → confirm sheet (add-on emoji + "Did you complete X for Buddy?")
  → "Yes!" → in-sheet success panel → auto-closes (2s)
  → parent notified via SMS (if enabled)
```

**Care Note — from Friend action menu (1-step)**
```
Friend action menu → Care Note
  → sheet slides up with dog identity in subheader
  → Dictate Note or type in textarea
  → Save Note → in-sheet success → auto-closes (2s)
```

**Care Note — from Employee bottom nav (2-step)**
```
Step 1 — Dictate or type note (Step 2 dimmed until content exists)
Step 2 — Attach: scan Friend NFC tag  OR  select color group chip(s)
```

**Photo — from Friend action menu (1-step)**
```
Friend action menu → Photo
  → sheet slides up with dog identity in subheader
  → Take Photo → preview appears
  → Save Photo → in-sheet success → auto-closes (2s)
```

**Photo — from Employee bottom nav (2-step)**
```
Step 1 — Take photo (Step 2 dimmed until photo taken)
Step 2 — Attach: scan Friend NFC tag  OR  select color group chip(s)
```

**Tiff (Altercation Report)**
```
⚠️ Tiff → yard context badge shown → dictate note + photo + description + severity
  → Submit → dog assignment bottom sheet (only dogs in active yard)
  → Admin notified immediately
```

**Yard Assignment**
```
Admin Home → Yard Assign
  → 6 yard cards, each with a multiselect dropdown of color groups
  → Conflict detection: if enemy groups assigned to same yard → inline warning
  → Conflict resolution options: reassign group / move group / reassign dog
```

**Enemy Conflict Detection**
```
Admin assigns color groups to yard
  → System checks enemy pairs among assigned groups
  → If conflict → inline warning on yard card (hard block)
      Resolution options: assign conflicting group elsewhere / move existing group / reassign dog
Edge case: enemy flag added after assignment → immediate admin alert
```

**Scheduling (Admin)**
```
Admin Home → Scheduling → day-by-day calendar of all booked friends
  → Each row: dog name, breed, group pill, dates, room pill, kennel pill
  → Tap room/kennel pill → picker bottom sheet (Available / Occupied / Cleaning)
  → Dogs that check in are removed from the scheduling list
```
Note: The Scheduling button on Admin Home shows an amber badge with the count of today's arriving dogs that have no kennel assigned. Once a dog completes check-in, it is removed from the scheduling list and the badge count decrements.

**Color Groups Screen**
```
Admin Home → Groups  (admin access only)
  → Lists all color groups with currently checked-in dogs
  → Tap dog → reassignment bottom sheet → select new group + optional note
Employee access: Change Group via NFC friend action menu (scoped to that dog only)
```

---

### Screen Inventory

| Screen ID | Label | Access From |
|---|---|---|
| `login` | Login | App launch |
| `employee-home` | Employee Home | Login |
| `admin-home` | Admin Dashboard | Login |
| `nfc-friend` | Friend Action Menu | NFC pill, NFC tag |
| `note-entry` | Care Note | Employee home, friend menu |
| `photo-entry` | Photo | Employee home, friend menu |
Note: Feed, Medicate, Add On, Care Note (friend menu), and Photo (friend menu) confirmations all happen via bottom sheets on the Friend action menu screen — no separate confirm/done screens.
| `checkin-room` | Check-In: NFC/Belongings (Step 1) | Admin arriving |
| `checkin-colorgroup` | Check-In: Groups/Kennels (Step 2) | Check-in step 1 |
| `checkin-schedule` | Check-In: Schedule (Step 3) | Check-in step 2 |
| `checkin-done` | Check-In Done ✓ | Check-in step 3 |
| `color-groups` | Color Groups | Employee bottom nav, admin quick action |
| `nfc-yard` | Yard Action Menu | Yard NFC tag |
| `incident-report` | Tiff Report | Employee bottom nav |
| `events` | Events (employee) | (accessible; no direct bottom-nav link yet) |
| `dog-profile` | Dog Profile | Parent directory |
| `admin-arriving` | Check In Friend | Admin home stat card |
| `admin-checkout` | Check Out Friend | Admin quick actions |
| `admin-checkout-confirm` | Checkout Confirm | Checkout list |
| `admin-checkout-done` | Checkout Done ✓ | Checkout confirm |
| `admin-booked` | Scheduling | Admin quick actions |
| `admin-yard-assign` | Yard Assign | Admin quick actions |
| `admin-conflict` | Yard Conflict | Yard assign, admin alert |
| `admin-message-yard` | Message Yard | Admin quick actions |
| `admin-calendar` | Events Calendar | Admin quick actions |
| `admin-flagged` | Flagged Issues | Admin quick actions |
| `admin-parents` | Parent Directory | Admin quick actions |
| `admin-vaccinations` | Vaccination Records | Admin quick actions |
| `admin-kennels` | Kennels & Rooms | Admin quick actions |
| `admin-settings` | Settings | Admin header ⚙️ icon |
| `admin-ask-ai` | Ask AI | Admin quick actions |

---

### Screen Header Styles

| Screen | Header Style |
|---|---|
| Employee Home, Admin Home | Teal gradient brand header with 🐾 watermark |
| Friend Action Menu | Teal gradient, back btn + avatar + name/pills |
| Color Groups, Note Entry, Photo Entry | Teal gradient with 🐾 watermark |
| All admin screens (except yard-assign, conflict, message-yard) | Teal gradient with back btn, title, subtitle |
| Yard Assign, Conflict, Message Yard, NFC Yard, Incident Report | White top-nav bar |
| Events (employee) | White top-nav bar with NFC pill |

Header icons (Employee Home and Admin Home):
- 🚪 Logout — white circle button, `position:absolute; top:52px; right:16px`
- ⚙️ Settings (Admin only) — white circle button, `position:absolute; top:52px; right:60px`

---

### PWA-Specific Considerations

- **NFC:** Requires Safari + iOS 14.5+; employee must have PWA open or foreground it via tag tap
- **Offline support:** Task completions queue locally and sync when reconnected
- **Add to Home Screen:** Prompted on first login for all staff
- **Camera access:** Native camera experience for photo actions (no file picker)
- **Dictation:** Device speech-to-text appends directly to note / tiff description field
- **Timestamps:** All actions logged with timestamp + staff name
- **Yard context:** Set via Yard NFC tag tap; scopes Tiff screen and admin messaging
