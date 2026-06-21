# SkillBridge — A Local Skill Exchange & Freelance Mobile Application

SkillBridge is a Flutter mobile app that lets people in the same
neighbourhood **discover, exchange and request skills** — from home
repairs and tutoring to music lessons and design work — either as a
**paid gig**, a **skill swap** (barter), or **free community help**.

Built as a semester project to demonstrate Flutter & Dart concepts:
widgets, state management, navigation, forms, theming, local
persistence and backend-integration patterns.

---

## ✨ Features

- Onboarding + email/password authentication (sign up, log in, session persistence)
- Home feed with category filters and search
- Post a new skill/freelance listing (skill-swap, paid, or free)
- Skill detail screen with a "Request This Skill" action
- In-app messaging (conversation list + chat thread)
- Profile screen with stats, "My Listings" and "Favorites" tabs
- Light/Dark theme toggle, persisted across launches
- Fully working **offline** (on-device storage) with a clean repository
  layer ready to swap in a real REST/Firebase backend

## 🧱 Tech Stack

| Concern             | Choice                                  |
|---------------------|------------------------------------------|
| Language / Framework| Dart 3 / Flutter 3 (Material 3)          |
| State management    | `provider` (ChangeNotifier)              |
| Local persistence   | `shared_preferences` (JSON-encoded)      |
| Networking (ready)  | `http` (REST) — see `ApiSkillRepository` |
| Demo backend        | Node.js + Express (`/backend`)           |

## 📂 Project Structure

```
skillbridge/
├── lib/
│   ├── main.dart                 # App entry point, Provider setup
│   ├── models/                   # UserModel, SkillModel, MessageModel...
│   ├── services/                 # AuthService, SkillRepository, ChatService, StorageService
│   ├── providers/                # AuthProvider, SkillProvider, ChatProvider, ThemeProvider
│   ├── screens/                  # All app screens (auth, main tabs, detail, chat, settings)
│   ├── widgets/                  # Reusable UI components
│   └── utils/                    # Theme, colors, constants, validators, dummy seed data
├── test/                         # Widget + unit tests
├── backend/                      # Optional Node/Express demo REST API
├── docs/                         # Project report, diagrams, screenshots
├── .github/workflows/            # CI pipeline that auto-builds a release APK
└── pubspec.yaml
```

## 🚀 Getting Started

1. **Install Flutter** (3.16+) — see https://docs.flutter.dev/get-started/install
2. From the project root, generate the native platform folders (only needed once):
   ```bash
   flutter create .
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run on a connected device / emulator:
   ```bash
   flutter run
   ```
5. Run the test suite:
   ```bash
   flutter test
   ```

The app works immediately with **zero configuration** — it seeds itself
with demo users and listings on first launch (see
`lib/utils/dummy_data.dart`). A demo login is pre-filled on the Login
screen: `ayesha@example.com` / `password123`.

## 📦 Building the APK

```bash
flutter build apk --release
```

The signed/unsigned release APK is produced at:
```
build/app/outputs/flutter-apk/app-release.apk
```

A ready-made GitHub Actions workflow (`.github/workflows/build_apk.yml`)
also builds this APK automatically on every push and uploads it as a
downloadable artifact — see the **Deployment** section of the project
report in `/docs` for details.

## 🔌 Connecting a Real Backend

Every screen reads data through `SkillProvider`, which depends only on
the abstract `SkillRepository` interface
(`lib/services/skill_repository.dart`). Two implementations are
included:

- `LocalSkillRepository` *(active by default)* — on-device storage, zero setup
- `ApiSkillRepository` — talks to a REST API via the `http` package

To go live, start the included demo backend (`/backend`) or your own
API, then change one line in `lib/main.dart`:

```dart
final SkillRepository skillRepository =
    ApiSkillRepository(baseUrl: 'https://your-api.com/api');
```

No UI or provider code needs to change.

## 📑 Documentation

See `/docs` for the full project report (PDF/DOCX), architecture
diagrams, data model, use case diagram and UI screenshots.

## 📄 License

This project was created for educational purposes as part of a
semester coursework submission.
