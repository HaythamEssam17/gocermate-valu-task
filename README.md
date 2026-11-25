# GrocerMate 🛒

GrocerMate is a modern, enterprise-grade, offline-first Flutter e-commerce and grocery delivery application built using Clean Architecture, BLoC state management, and modern Flutter best practices.

---

## 🌟 Key Features

- **Product Catalog & Search**: Browse groceries, deals of the day, search products with debouncing, filter by categories and brands.
- **Real-time Cart Management**: Add items, adjust quantities, move items between cart and "Saved for Later", with instant subtotal and tax calculation.
- **Offline-First & Outbox Sync**: Place orders even while offline! The app automatically queues offline orders in a local outbox (`Hive`) and seamlessly replays/syncs them with the backend once internet connection is restored (`SyncManager`).
- **Checkout & Review Flow**: Robust checkout with price and stock revalidation review sheets when discrepancies occur.
- **Multi-language Support (i18n)**: Full localization support for English (`en`) and Arabic (`ar`) with RTL/LTR layout adaptation.
- **Animated Splash Screen**: Engaging entrance animation with scale, fade, and slide transitions on app startup.
- **Dev Tools**: Built-in mock server configuration sheet to simulate network latency, request failure rates, offline state, and purchase test scenarios.

---

## 🏛️ Architecture & Tech Stack

GrocerMate follows **Clean Architecture** principles, dividing features into modular vertical slices:

- **State Management**: `flutter_bloc` (BLoC & Cubit)
- **Dependency Injection**: `get_it`
- **Navigation & Routing**: `go_router` (Declarative routing with type-safe arguments)
- **Local Storage & Caching**: `hive`, `hive_flutter`, custom caching fetcher (`CachingFetcher`)
- **Network / Transport**: `dio` (with mock API client simulation)
- **Localization**: Flutter synthetic localizations (`arb` files)

---

## 📂 Project Structure

```text
lib/
├── app/                  # App shell, multi-bloc provider setup, maintenance gate
├── core/
│   ├── cache/            # Caching fetcher & manager
│   ├── config/           # App flags & flags repository
│   ├── connectivity/     # Connectivity Cubit & service
│   ├── di/               # Composition root (GetIt setup in injection.dart)
│   ├── error/            # Failures, exceptions, and Result type (Either)
│   ├── router/           # GoRouter declarations (AppRoutes)
│   ├── storage/          # Hive & JSON storage abstractions
│   ├── utils/            # Extensions, enums, money formatters, and helpers
│   └── widgets/          # Reusable design system widgets (Scaffold, AppBar, buttons, etc.)
├── features/
│   ├── cart/             # Cart domain, data, and presentation
│   ├── catalog/          # Home catalog, deals, categories
│   ├── category/         # Categories feature module
│   ├── checkout/         # Checkout flow & review resolver
│   ├── offline_sync/     # Outbox queue & sync manager
│   ├── order/            # Order confirmation & receipt cubit
│   ├── product_details/  # Product details feature module
│   ├── products/         # Products listing & grid feature module
│   ├── search/           # Search feature & filters
│   └── splash/           # Animated splash screen
├── shared/
│   └── widgets/          # Shared components (e.g. cart widgets, stepper)
└── l10n/                 # Localization ARB files (app_en.arb, app_ar.arb)
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.13.7 or higher)
- Dart SDK

### Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/grocermate.git
   cd grocermate
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Localization files** (if ARB files were modified):
   ```bash
   flutter gen-l10n
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

---

## 🧪 Running Tests

To run the unit and bloc test suites:
```bash
flutter test
```

---

## 💡 How It Works

1. **Initialization (`configureDependencies`)**:
   - `Hive` is initialized, local boxes (`cache`, `user`) are opened.
   - Dependency injection (`GetIt` / `sl`) registers all module datasources, repositories, use cases, and blocs.
   - `SyncManager` starts listening to network connectivity changes to automatically replay queued outbox purchases upon reconnection.

2. **Routing & Navigation (`AppRoutes`)**:
   - App starts at `AppRoutes.splash` (`/splash`), showing the animated splash screen.
   - After animation, it navigates to `AppRoutes.shell` (`/`), displaying `AppShell` with the bottom navigation bar and `PageView` tab animations (`Home`, `Search`, `Cart`, `Orders`).

3. **Offline Sync**:
   - When offline, orders are stored in `OutboxRepository`.
   - The user can view queued orders in the `Orders` (`QueuePage`) tab and trigger manual sync (`SyncNow`) once back online.
