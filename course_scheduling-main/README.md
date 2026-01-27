# Course Scheduling  

A Flutter app for managing university course schedules with role-based flows:

- **Student**: browse/view enrolled courses and schedules
- **Lecturer**: manage weekly schedule entries
- **Admin**: manage users, courses, and assignments/enrollments
- **Extras**: in-app chat and shared course resources (files)

## Tech stack

- **Flutter** UI
- **flutter_bloc** for state management (BLoC)
- **Clean Architecture (feature-first)**: `presentation/` → `domain/` → `data/`
- **Supabase**: Auth + Postgres DB + Storage
- **fpdart**: functional error handling patterns (e.g., `Either`)

## Project structure (high level)

- `lib/core/`: shared cross-feature code (errors, usecase base, theme, secrets)
- `lib/features/<feature>/presentation/`: UI pages/widgets + BLoCs
- `lib/features/<feature>/domain/`: entities + repository contracts + usecases
- `lib/features/<feature>/data/`: remote data sources, DTO models, repository implementations
- `lib/widgets/`: shared UI widgets used across features

## Supabase integration

Supabase is initialized at app startup in `lib/main.dart` using `Supabase.initialize(...)`.
The shared `SupabaseClient` is passed into feature remote data sources (e.g. auth, courses,
chat, resources, lecturer, admin). Data sources call:

- **Auth**: `supabaseClient.auth.signInWithPassword`, `signUp`, `signOut`
- **Database**: `supabaseClient.from('<table>').select/insert/update/delete(...)`
- **Storage (resources/files)**: `supabaseClient.storage.from('<bucket>').upload(...)`

## Run locally

1. Install Flutter SDK and run:

```bash
flutter pub get
flutter run
```

2. Configure Supabase credentials:
   - Update `lib/core/secrets/app_secrets.dart` (URL + anon key), or refactor to env-based config.
