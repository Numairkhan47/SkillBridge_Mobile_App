# SkillBridge Demo Backend (optional)

The Flutter app works fully offline out of the box using
`LocalSkillRepository` (on-device storage via `shared_preferences`), so
**this server is not required** to run or demo the app.

It is included to demonstrate real backend/REST integration, matching
the `ApiSkillRepository` class already written in
`lib/services/skill_repository.dart`.

## Run it

```bash
cd backend
npm install
npm start
# Server starts on http://localhost:3000
```

## Endpoints

| Method | Path              | Description           |
|--------|-------------------|------------------------|
| GET    | /api/skills       | List all listings      |
| GET    | /api/skills/:id   | Get a single listing   |
| POST   | /api/skills       | Create a new listing   |
| PUT    | /api/skills/:id   | Update a listing       |
| DELETE | /api/skills/:id   | Delete a listing       |

## Connecting the Flutter app to this server

In `lib/main.dart`, change:

```dart
final SkillRepository skillRepository = LocalSkillRepository();
```

to:

```dart
final SkillRepository skillRepository =
    ApiSkillRepository(baseUrl: 'http://10.0.2.2:3000/api'); // Android emulator
    // or ApiSkillRepository(baseUrl: 'http://localhost:3000/api'); // iOS simulator / web
```

No other code changes are needed — every screen already reads through
`SkillProvider`, which depends only on the `SkillRepository` interface.
