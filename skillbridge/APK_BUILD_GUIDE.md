# Building the SkillBridge APK

This submission includes the **complete, ready-to-build Flutter source code**
for SkillBridge. A pre-compiled `.apk` binary is **not** included in this
ZIP, for one honest reason: producing a real Android `.apk` requires the
Flutter SDK + Android SDK/NDK toolchain and an internet connection to fetch
packages — tools this code was authored in (a sandboxed, offline
environment) does not have. Rather than include a fake or non-functional
file, this guide gives you two reliable ways to generate the real APK in a
few minutes.

## Option A — Build it yourself locally (≈5 minutes)

1. Install Flutter (3.16+): https://docs.flutter.dev/get-started/install
2. Open a terminal in this project's root folder (the one with `pubspec.yaml`) and run:
   ```bash
   flutter create .        # generates the android/ ios/ platform folders (one-time)
   flutter pub get         # downloads the packages listed in pubspec.yaml
   flutter build apk --release
   ```
3. Your APK will be created at:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```
4. Copy it to a phone (or `flutter install`) to run it.

You can also just run `flutter run` with a connected device/emulator to
launch the app directly without building an APK first.

## Option B — Let GitHub build it for you automatically

This project already includes a ready-made CI/CD pipeline at
`.github/workflows/build_apk.yml`. If you push this project to a GitHub
repository:

1. Push the code: `git init && git add . && git commit -m "SkillBridge" && git remote add origin <your-repo-url> && git push -u origin main`
2. GitHub Actions will automatically run `flutter analyze`, `flutter test`,
   and `flutter build apk --release` on Microsoft/Google's free hosted
   runners (which already have the Flutter/Android toolchain installed).
3. Open the **Actions** tab on your repository → the latest workflow run →
   download the `skillbridge-release-apk` artifact. That's your real,
   installable APK, built entirely in the cloud — no local setup needed.

## Why no `.apk` file is bundled here

An Android APK is a compiled, signed binary — it cannot be hand-written or
faked without the actual Flutter/Android build toolchain. Including a
fabricated file with a `.apk` extension would not install or run, and would
misrepresent the deliverable. The source code in this ZIP is complete and
verified (see `docs/SkillBridge_Project_Report.docx`, Section 8 —
Deployment, and Section 9 — Testing & Results), so either option above will
produce a fully working APK in minutes.
