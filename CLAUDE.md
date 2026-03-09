# Ruff Life Resort — Claude Instructions

## Project
Single-file HTML/CSS/JS mockup for a dog daycare/boarding admin PWA.
Main file: `mockup.html` (~480KB, inline everything).
Reference: `ruff-life-reference.md` | Schema: `schema.sql` | Flags: `feature-flags.md`

## UI Conventions
- Screens are `.screen` divs; navigation via `go(screenId)`
- `.screen` CSS: `display:flex; flex-direction:column; position:absolute; inset:0`
- `.scroll-content`: `flex:1; overflow-y:auto; overscroll-behavior:none`
- `.wizard-footer`: `flex-shrink:0; background:white; border-top:1px solid var(--border); padding:16px 16px 28px` — sticky action buttons for all wizards
- Full-screen editors: `position:absolute; inset:0; z-index:200; display:flex; flex-direction:column`
- Phone frame scales to viewport via `fitPhone()` at end of script

## CSS Variables
`--teal` `--teal-dark` `--teal-light` `--teal-deeper` `--border` `--medium` `--dark` `--lighter` `--bg` `--green` `--green-light`

## Rules
- No emojis in buttons (decorative watermarks/icons are fine)
- `overscroll-behavior: none` on all `.scroll-content` — no rubber-band when content fits
- Wizard action buttons always go in `.wizard-footer`, not inside `.scroll-content`
- Completed wizard step circles are tappable for back-navigation

## Branding (Ruff Life config)
- Primary: `#1D8A92` (teal) / Dark: `#176970`
- Tone: playful | Dog term: Friend | Owner term: Parent | Incident term: Tiff

## Check-In Wizard (4 steps)
1. `checkin-room` — NFC/Belongings: assign NFC tag, photo of belongings
2. `checkin-colorgroup` — Groups/Kennels: confirm pre-assigned kennel (inline edit), color group dropdown
3. `checkin-schedule` — feeding/meds toggles + multi-select add-on dropdowns (5 categories)
4. `checkin-done` — minimal confirmation, no detail badges

`completeCheckin()` removes dog from scheduling list, updates unassigned badge, navigates to done.

## Key Screens
See `ruff-life-reference.md` for full screen inventory and flows.
Notable: `admin-booked` (Kennel Planning), `admin-send-sms` (Text Parents, 4 tabs), `admin-message-yard` (Message — yard dropdown + dynamic staff list), `nfc-friend` (Friend action menu)
