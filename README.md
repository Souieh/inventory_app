Inventory App

A simple and efficient Flutter-based inventory management application.  
Supports both **Arabic and English**, and works seamlessly across **all major platforms** including Android, iOS, Linux, Windows, and macOS.

## 🌍 Languages

- 🇸🇦 Arabic (العربية)
- 🇬🇧 English

## 🖥️ Platform Compatibility

| Platform | Supported |
| -------- | --------- |
| Android  | ✅        |
| iOS      | ✅        |
| Linux    | ✅        |
| Windows  | ✅        |
| macOS    | ✅        |

## 📱 Features

- Agent authentication and management
- Scan and track locations and articles using QR codes
- Offline support with local SQLite database
- Export inventory data to Excel files
- Developer mode (activated by tapping app version multiple times)
- Dual-language support (AR/EN)
- Beautiful and responsive UI

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.8.0
- Dart SDK compatible with Flutter 3.8

### Installation

```bash
flutter pub get
flutter run

```

### 🧰 Dependencies Overview

| Package                     | Purpose                           |
| --------------------------- | --------------------------------- |
| provider                    | State management                  |
| sqflite                     | Local database                    |
| path_provider               | File system paths                 |
| qr_code_scanner_plus        | QR code scanning                  |
| shared_preferences          | Local key-value storage           |
| file_picker                 | Picking files                     |
| file_saver                  | Saving files                      |
| excel                       | Exporting data                    |
| intl & flutter_localization | Multilingual support              |
| mobile_scanner              | High-performance barcode scanning |
| pie_chart                   | Visual statistics                 |
| url_launcher                | Open URLs                         |

### 🧪 Testing

```bash
flutter test
```

### 🔧 Developer Mode

- Tap 7 times on the app version in settings/about within 10 seconds.
- Prompts for developer key.
- Unlocks debug/developer tools.

### 🖼️ Assets

assets/images/logo.png – App icon

assets/images/ – App images

### 📦 Build App Icons

```bash
flutter pub run flutter_launcher_icons
```

## 🔒 License

This project is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).
