# Project: 북끄 (Bukku)
독서 기록 및 관리 어플리케이션

## 1. Tech Stack (The "Pro" Standard)
- **Framework:** Flutter (Latest)
- **Language:** Dart
- **State Management:** **Riverpod** (Flutter Riverpod 2.0+)
- **Data Class / Immutability:** **Freezed** + **JsonSerializable**
- **Navigation:** **GoRouter**
- **Backend:** Firebase (Firestore)

## 2. Design System & UI Concept
- **Theme:** "Instagram-like Simple & Clean"
- **Main Color:**
  - Background: Cream White (`#FDFBF7`) - **Strict Rule**
  - Text/Icon: Black (`#000000`)
  - Accent: Grey (`#9E9E9E`) for sub-texts
  - Point Colors (Pastel):
    - Reading: `#4CAF50` (Green)
    - Done: `#FFFF7043` (Orange)
    - Wish: `#9575CD` (Purple)
    - Add Button: `#1A237E` (Deep Navy)
- **Typography:** Pretendard (Default)
- **Component Style:**
  - Flat Design (No heavy shadows, no gradients).
  - `Elevation: 0` for AppBars and Cards.
  - Simple lines and whitespace.

## 3. Architecture: MVVM with Repository Pattern
Data Flow: `View (UI)` -> `ViewModel (Riverpod Provider)` -> `Repository` -> `DataSource (Firebase)`

### [Model] (`lib/models/`)
- Must be implemented using `@freezed`.
- Must include `fromJson` (for generic) or `fromDocument` (for Firestore).
- Strictly Immutable.

### [ViewModel] (`lib/providers/`)
- Use `StateNotifierProvider` or `AsyncNotifierProvider`.
- Manage UI state using Freezed Union Types (e.g., `AsyncValue`).
- **NO** Context usage inside Providers.

### [View] (`lib/views/`)
- Extends `ConsumerWidget` or `ConsumerStatefulWidget`.
- Observe state via `ref.watch()`.
- Trigger actions via `ref.read().method()`.

### [Repository] (`lib/repositories/`)
- Abstract the direct Firebase calls.
- ViewModels should talk to Repositories, not Firebase directly.

## 4. Data Model (Firestore Schema)
**Collection:** `books`
- `id` (String): Document ID
- `title` (String): 책 제목
- `author` (String): 작가
- `coverUrl` (String): 표지 이미지 URL
- `status` (String): `READING`, `DONE`, `WISH`, `STOP`
- `unitType` (String): `PAGE`, `PERCENT`, `CHAPTER`
- `totalUnit` (int)
- `currentUnit` (int)
- `startedAt` (Timestamp)
- `finishedAt` (Timestamp)
- `rating` (double)
- `memo` (String)

## 5. Folder Structure (Feature-First Recommended)
lib/
  ├── main.dart            # ProviderScope setup (앱의 시작점)
  ├── app_router.dart      # GoRouter configuration (화면 이동 관리)
  ├── models/              # Freezed Models (데이터 모델)
  │   └── book_model.dart
  ├── repositories/        # Firebase Logic (DB와 직접 통신)
  │   └── book_repository.dart
  ├── viewmodels/          # Riverpod Providers (앱의 두뇌/로직)
  │   └── book_view_model.dart
  └── views/               # UI Screens (사용자가 보는 화면)
      ├── home/            # 홈 화면 (책장)
      ├── add_book/        # 책 추가 화면
      └── detail/          # 책 상세/수정 화면

## 6. Key Features (Implementation Plan)

### [UI-01] Home View (Main)
- **Layout:** GridView (3 columns) showing book covers.
- **Header:** Simple Appbar ("bukku" text logo left-aligned).
- **Filter:** Status Filter (Chip/Tab) & Sort (Date Descending).
- **Interactions:** Tap to Detail, FAB (+) to Add Book.

### [UI-02] Book Detail & Receipt View
- **Concept:** Provide a digital "Receipt" feel when a book is finished.
- **Features:** Edit progress (Slider), Change status, Delete book.

### [UI-03] Add/Edit Book
- Simple form to input title, author, total pages.
- Image picker for cover.

## 7. Coding Conventions
- **Code Generation:** Run `flutter pub run build_runner build` after changing models.
- **Imports:** Use absolute paths (package:bukku/...) preferrably.
- **Linting:** Follow `very_good_analysis` or strict flutter lints.