# 🏦 Cubic Banking App – Flutter Technical Assessment

A secure, scalable, and production-ready **Flutter banking application** built as part of a technical interview assessment.


## 🎨 Design Credits

- **Design Name:** [Free Banking Mobile App UI Kit](https://www.figma.com/design/cf8mBQnTZsTGEG4Zm1YmrA/Free-Banking-Mobile-App-Ui-Kit-With-light---Dark-Mode-High-Quality-Ui-43--Screen-template--Community-?node-id=1-8591&t=IUSd5oibWI9qsDBI-0)
- **Credits:** Figma Community
- - **Usage:** The design was used **as a visual reference only**.
  - Color palette inspiration
  - Reference for main screens
- **Implementation:** Full transformation from high-fidelity design to functional Flutter widgets with support for **Dark Mode** and **Responsive Layouts**.

---

## 📌 Project Overview

**Cubic Banking App** simulates a real-world mobile banking experience with a strong focus on:

- 🔐 Security & Data Protection
- ⚡ Performance & Offline Support
- 🧱 Clean, scalable architecture
- 🌍 Localization (English & Arabic)
- 🗺️ Location-based branch discovery

This project is designed to reflect **Mid-Level Flutter Developer** standards and best practices.

---

## 🔗 Submission Links (As Requested)

### ✅ Source Code (GitHub Repository)
> **GitHub Repository:**  
👉 https://github.com/ahmedfyala/cubic_flutter_assessment

---

### ✅ APK File (Installable Build)
> **Google Drive APK Link:**  
👉 https://drive.google.com/file/d/1g1HgL8-dlGEblqfrrcDAkN7PmWzJ9Rci/view?usp=sharing


This file explains **why specific libraries were chosen**, especially for **storage and encryption**, with clear security justification.

---

## ✨ Key Features

### 🔑 Authentication
- Firebase Email/Password Authentication
- Login & Registration flows
- Secure token storage
- Auto-login using Biometrics (if enabled)

### 🧬 Biometric Authentication
- Fingerprint / Face ID support
- Biometric enrollment workflow post-authentication
- Automatic authentication on app launch
- Graceful fallback for unsupported devices

### 🏠 Dashboard
- Account summary (mock banking data)
- Credit card UI
- Recent transactions list
- Skeleton loading for better UX

### 🗺️ Branch Locator
- Google Maps integration
- User current location detection
- Optimized Haversine algorithm for proximity-based branch discovery
- Interactive markers with details sheet
- Offline cached locations support

### ⭐ Favorites
- Add / Remove branches from favorites
- User-based storage using Firestore
- Persistent state across sessions

### 🌐 Connectivity Handling
- Real-time network status monitoring
- Cached data usage when offline
- Toast & Snackbar notifications

### 🌍 Localization
- English 🇺🇸
- Arabic 🇪🇬
- Runtime language switching

### 🛡️ Security Features
- Screenshot & screen recording prevention
- Encrypted secure storage
- App content hidden when backgrounded

---

## 🧱 Architecture Overview

```text
lib/
├── config/             # Dependency Injection & Service Locator
├── core/               # App-wide constants, themes, and shared services
│   ├── constants/      # API Endpoints & Asset paths
│   ├── errors/         # Error handling & Failures
│   ├── localizations/  # Translation logic
│   ├── routes/         # App routing logic
│   ├── services/       # Security, Biometric, Firestore, and Location services
│   ├── theme/          # App colors and themes (Light/Dark)
│   ├── utils/          # Validators, Notifiers, and Loggers
│   └── widgets/        # Shared UI components (Buttons, TextFields)
├── features/           # Feature-based modules
│   ├── auth/           # Login, Register, and Biometric Setup
│   ├── connectivity/   # Real-time network monitoring
│   ├── dashboard/      # Account summary & Transactions
│   ├── favorites/      # Favorite branches management
│   ├── map/            # Branch discovery & Google Maps
│   └── onboarding/     # App intro screens
└── main.dart           # App entry point & initialization

```

### 🧠 Architectural Decisions
- Feature-based modular structure
- Repository pattern for data abstraction
- Cubit (BLoC) for state management
- Dependency injection using GetIt & Injectable
- Clear separation of concerns

---

## 🛠️ Technology Stack

| Layer | Technology |
|------|-----------|
| Framework | Flutter |
| State Management | flutter_bloc (Cubit) |
| Backend | Firebase Auth & Firestore |
| Networking | Dio |
| Dependency Injection | GetIt + Injectable |
| Maps | Google Maps Flutter |
| Local Storage | Hive |
| Secure Storage | flutter_secure_storage |
| Localization | easy_localization |
| Security | local_auth, screen_protector |
| UI | Material 3, ScreenUtil |

---

## 📦 Key Dependencies

```yaml
flutter_bloc
firebase_auth
firebase_core
cloud_firestore
google_maps_flutter
location
permission_handler
flutter_secure_storage
hive
easy_localization
local_auth
screen_protector
skeletonizer
```
## 👨‍💻 Author

Ahmed Mahmoud Fyala  
Flutter Developer – Cairo, Egypt  

GitHub: https://github.com/ahmedfyala  
LinkedIn: https://www.linkedin.com/in/ahmedfyala
