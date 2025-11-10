# 📋 Checklist App

A Flutter-based checklist application for managing todo items with priority settings, filtering, sorting, and a comprehensive dashboard with visual analytics.

## ✨ Features

- **Create, Edit, and Delete** checklist items
- **Priority Management** - Set priorities (Low, Medium, High, Urgent) for each item
- **Sorting Options** - Sort by Priority, Date (Newest/Oldest), or Name
- **Completion Tracking** - Mark items as completed with timestamp tracking
- **Filtering** - Filter by completion status and priority
- **Dashboard Analytics** - Visual charts and statistics for:
  - Completion status (completed vs pending)
  - Priority distribution
  - Priority breakdown with percentages
- **Dark/Light Theme** support
- **Localization** support
- **Offline-first** - Data persisted locally using Hive

## 🏗️ Architecture

This app follows **Clean Architecture** principles with clear separation of concerns:

### Project Structure

```
lib/
├── app/
│   ├── config/          # App configuration (routing, DI, themes, l10n)
│   └── core/            # Core utilities, extensions, constants
├── data/
│   ├── models/          # Data models (ChecklistItemModel, Priority)
│   └── repo/            # Repository implementation (Hive-based)
└── screens/
    ├── home/            # Checklist screen with CRUD operations
    ├── dashboard/       # Analytics dashboard
    ├── setting/         # App settings (theme, language)
    └── splash/          # Splash screen
```

### Key Technologies

- **State Management**: Flutter Bloc (Cubit)
- **Dependency Injection**: GetIt
- **Navigation**: GoRouter
- **Local Storage**: Hive
- **Charts**: FL Chart
- **Code Generation**: Build Runner, Hive Generator

## 🧪 Testing

This project includes comprehensive testing at three levels:

### 1. Unit Tests

Located in `test/unit/`, these tests verify business logic:

- **`checklist_model_test.dart`** - Tests for ChecklistItemModel and Priority enum
- **`checklist_repository_test.dart`** - Tests for repository CRUD operations and statistics
- **`checklist_cubit_test.dart`** - Tests for state management and business logic

**Run unit tests:**
```bash
flutter test test/unit
```

### 2. Integration Tests

Located in `integration_test/`, these tests verify app flow and user interactions:

- **`app_flow_test.dart`** - Tests splash screen → home → add item → dashboard flow
- **`e2e_happy_path_test.dart`** - End-to-end test covering add, edit, toggle, filter, and delete operations

**Run integration tests:**
```bash
flutter test integration_test
```

### 3. Test Coverage

Test coverage is generated and can be viewed:

```bash
# Generate coverage report
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.35.7 or later
- Dart SDK 3.9.2 or later
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd checklist_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Running Tests

### Run All Tests
```bash
flutter test
```

### Run Unit Tests Only
```bash
flutter test test/unit
```

### Run Integration Tests Only
```bash
flutter test integration_test
```

### Run Specific Test File
```bash
flutter test test/unit/checklist_cubit_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

## 🔧 CI/CD

This project uses **GitHub Actions** for continuous integration and deployment. The CI/CD pipeline includes:

### Test Job
1. ✅ Checks code formatting
2. ✅ Analyzes code with `flutter analyze`
3. ✅ Runs all unit tests
4. ✅ Runs all integration tests
5. ✅ Generates test coverage report
6. ✅ Uploads coverage to Codecov (optional)

### Build Jobs
- **Android Build**: Builds release APK and uploads as artifact
- **iOS Build**: Builds iOS app (unsigned) and uploads as artifact

Both build jobs run only after tests pass successfully.

Workflow file: `.github/workflows/ci.yml`

## 📊 Test Coverage

Current test coverage includes:

- ✅ **Models** - 100% coverage for data models
- ✅ **Repository** - Full coverage of CRUD operations and statistics
- ✅ **Cubit** - State management and business logic coverage
- ✅ **Integration** - Complete user flows tested
- ✅ **E2E** - End-to-end scenarios validated

## 🎨 Features in Detail

### Checklist Management
- Create new checklist items with title, description, priority, and due date
- Edit existing items
- Delete items (with confirmation)
- Mark items as completed/incomplete
- View item details in a dedicated dialog

### Filtering & Sorting
- Filter by completion status (All, Completed, Pending)
- Filter by priority (All, Low, Medium, High, Urgent)
- Sort by Priority, Date (Newest/Oldest), or Name
- Clear all filters with one click

### Dashboard
- Overview cards showing total, completed, pending items, and completion rate
- Completion status chart (pie chart)
- Priority distribution chart (bar chart)
- Priority breakdown with progress indicators

### Settings
- Theme mode selection (Light, Dark, System)
- Language selection
- App version information

## 🛠️ Development

### Code Generation

When modifying models with Hive annotations, regenerate code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Code Formatting

```bash
dart format .
```

### Code Analysis

```bash
flutter analyze
```

## 📝 License

This project is created for an assignment.

## 👤 Author

**Om Sopheap**

- Email: [sopheapom.dev@gmail.com](mailto:sopheapom.dev@gmail.com)
- Telegram: [t.me/sopheap_dev](https://t.me/sopheap_dev)
- Phone: 089 202 302

Created as part of a Flutter development assignment demonstrating:
- Clean architecture
- State management with BLoC
- Local data persistence
- Comprehensive testing (Unit, Integration, E2E)
- CI/CD pipeline
- Modern Flutter best practices

---

This app is built with Flutter 3.35.7 and follows the latest Flutter and Dart best practices.
