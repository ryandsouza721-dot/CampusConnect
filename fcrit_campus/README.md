# FCRIT Campus — Desktop & Mobile Flutter Application

A responsive desktop and mobile application for **FCRIT Campus**, designed and engineered with **Flutter & Dart**. Built based on the requirements in `guipc.md` and the 10 mobile reference screenshots in `reference_images/`.

---

## 🌟 Highlights & Key Deliverables

1. **Intelligent Desktop/PC Layout:**
   - Adapts to wider screens (≥ 850px) with a **persistent left navigation sidebar** and **top header bar** instead of stretched mobile layouts.
   - Multi-column responsive card grids for notices and events on laptop/desktop viewports.
   - Two-pane desktop inbox layout (message list on the left, selected message reader on the right).

2. **Crucial Navigation Update (Notices Tab):**
   - **Removed the redundant "Notices" tab** from the bottom navigation bar and sidebar primary menu.
   - Fully preserved the **Important Notice banner**, **Quick Access → Notices** shortcut, and **Latest Notices** feed on the Home screen.
   - Clicking "View all" or the Quick Access Notices shortcut opens the notice list filter view without altering primary navigation destinations.
   - Clean 4-destination navigation: **Home (0)**, **Events (1)**, **Messages / You (2)**, and **Profile (3)**.

3. **Visual Aesthetics Matching Reference Images:**
   - **Primary Background:** Deep navy (`#090D1A` / `#0F172A`).
   - **Accent Gradient:** Vibrant violet/purple gradient (`#6366F1` to `#9333EA`).
   - **Content Surfaces:** Crisp light lavender-gray (`#F8FAFC` / `#FFFFFF`).
   - **Category Palette:**
     - Academics / Notices: `#7C3AED` (Purple)
     - Placements: `#10B981` (Emerald Green)
     - Clubs: `#F59E0B` (Amber Orange)
     - Events: `#0284C7` (Sky Blue / Cyan)
     - Cultural: `#EC4899` (Rose Pink)

4. **Full Feature Implementation:**
   - **Home Screen:** Greeting with student chips (`CSE • 2nd Year`, `Div B • Roll 42`), Important Notice gradient banner, Quick Access filters, Latest Notices cards with NEW badges, view counts, and bookmark toggles.
   - **Events Screen:** Segmented tabs (`Upcoming`, `Ongoing` with live green indicator dot, `Past`), event cards with date badges, registration count, bookmarking, and "Register Now" CTAs.
   - **Inbox Screen:** Unread count badges, high-priority alert cards, audience filters (`@CSE`, `@2nd Year`), and desktop two-pane reader.
   - **Profile Setup Modal:** Full form with Department, Year of Study, and multi-select Clubs & Groups matching reference images 01 and 02.
   - **Spring Boot API Integration:** Prepared in `lib/services/api_service.dart` to connect with `http://localhost:8080/api`.

---

## 📁 Directory Structure

```
fcrit_campus/
├── pubspec.yaml                 # Dependencies (provider, http, intl)
├── analysis_options.yaml        # Dart linting configuration
├── test/
│   └── widget_test.dart         # Navigation & Home notice tests
├── lib/
│   ├── main.dart                # App entry point & provider bootstrap
│   ├── theme/
│   │   ├── app_colors.dart      # Color tokens & gradients
│   │   └── app_theme.dart       # Material 3 typography & card themes
│   ├── models/
│   │   ├── user_profile_model.dart # Student profile & department/clubs
│   │   ├── notice_model.dart       # Notice categories, read/bookmark states
│   │   ├── event_model.dart        # Events (Upcoming, Ongoing, Past)
│   │   └── message_model.dart      # Inbox messages & priority alerts
│   ├── services/
│   │   ├── api_service.dart        # Spring Boot REST API client
│   │   └── mock_data.dart          # Seed data matching reference images
│   ├── state/
│   │   └── app_state.dart          # Reactive ChangeNotifier state
│   ├── widgets/
│   │   ├── sidebar.dart            # Persistent desktop sidebar
│   │   ├── top_header.dart         # Greeting, student chips, search, & notifications
│   │   ├── important_notice_banner.dart # Gradient announcement card
│   │   ├── quick_access_bar.dart   # Interactive category filters
│   │   ├── notice_card.dart        # Feed card with bookmark & view counts
│   │   ├── event_card.dart         # Event card with status banner & CTA
│   │   ├── message_card.dart       # Inbox card with priority tags
│   │   └── category_chip.dart      # Category & NEW badges
│   └── screens/
│       ├── desktop_shell.dart      # Responsive shell (Desktop & Mobile)
│       ├── home_screen.dart        # Dashboard feed & notices
│       ├── events_screen.dart      # Events directory with tab filters
│       ├── inbox_screen.dart       # Two-pane messaging interface
│       ├── profile_screen.dart     # User settings, clubs, & bookmarks
│       └── profile_setup_screen.dart # Interactive profile setup modal
```

---

## 🚀 How to Run

When running in an environment with the Flutter SDK installed:

```bash
# Navigate to the Flutter project
cd fcrit_campus

# Install packages
flutter pub get

# Run on Windows Desktop
flutter run -d windows

# Run on Chrome Web / Desktop browser
flutter run -d chrome
```
