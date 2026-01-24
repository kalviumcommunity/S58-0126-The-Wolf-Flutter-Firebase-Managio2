# Managio – Freelancer Task Management App

Managio is a **Flutter-based task management application** that uses **Firebase Authentication and Cloud Firestore** to help freelancers manage tasks, deadlines, and workflows in a **secure and real-time system**.

The app implements a complete **authentication flow (Signup → Login → Persistent Session)** and demonstrates how Firebase can replace a traditional backend with minimal setup.

---

## 🔐 Authentication Flow (Summary)

1. User opens the app
2. Firebase checks authentication state
3. New users sign up using **Email & Password**
4. Existing users log in securely
5. On success, user is redirected to the dashboard
6. Session persists even after app restart

Firebase Authentication handles validation, session management, and security automatically.

---

## 🚀 Problem Statement

Freelancers often juggle multiple tasks, deadlines, and follow-ups without a centralized platform, leading to confusion and missed work.

**Managio** solves this by providing a **secure, scalable, and real-time task management solution** powered by Firebase.

---

## 🧩 Features

* Unified **Login & Signup** screen
* Secure **Email/Password Authentication**
* Real-time updates using **Cloud Firestore**
* Automatic navigation based on auth state
* Persistent user sessions
* Clean and modular architecture

---

## 🛠️ Tech Stack

* **Flutter** – Cross-platform UI development
* **Firebase Authentication** – User management
* **Cloud Firestore** – Real-time database
* **Firebase Core** – App initialization

---

## 🔥 Firebase Setup Steps

1. Go to **Firebase Console** and create a new project
2. Add a **Web App** to the project
3. Enable **Authentication → Email/Password**
4. Enable **Cloud Firestore** (test mode)
5. Install Firebase CLI and FlutterFire CLI
6. Run `flutterfire configure`
7. Add Firebase dependencies in `pubspec.yaml`
8. Initialize Firebase in `main.dart`
9. Use Firebase via service classes (`auth_service.dart`, `firestore_service.dart`)

---

## 🧑‍💻 Authentication Code Snippets

### Signup Logic

```dart
Future<User?> signUp(String email, String password) async {
  final credential = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  return credential.user;
}
```

### Login Logic

```dart
Future<User?> login(String email, String password) async {
  final credential = await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  return credential.user;
}
```

Firebase securely handles password hashing, validation, and session creation.

---

## 🔄 How Firestore Real-Time Sync Works

* Data is stored as **documents inside collections**
* Firestore provides **real-time listeners**
* Any add/update/delete triggers instant UI updates
* No manual refresh or polling required

This ensures smooth synchronization across devices.

---

## 📸 Firebase Proof (Screenshots Section)

* **Firebase Console → Authentication → Users** (shows registered users)
* **Firebase Console → Firestore → Data** (shows live task updates)

*Add screenshots here to demonstrate real-time updates without refresh.*

---

## 🏗️ Application Flow

1. App launches and checks auth state
2. Unauthenticated users see login/signup screen
3. Successful login redirects to dashboard
4. Firestore syncs data in real time
5. User session persists across restarts

---

## 🧠 Reflection

### How does Firebase simplify authentication management?

Firebase removes the need to build custom auth systems by providing ready-made, secure authentication with session handling, validation, and persistence.

### What security features make it better than custom auth systems?

* Secure password hashing
* Built-in protection against common attacks
* Token-based authentication
* Managed sessions and auto logout handling

### Challenges faced during implementation

* Firebase web configuration errors
* Correct Firebase initialization order
* Handling auth state navigation

These were resolved through proper Firebase setup and service abstraction.

---

## 🔮 Future Enhancements

* Task editing and deletion
* Client-based task grouping
* Payment and deadline tracking
* Push notifications
* Offline support

---

## ✅ Conclusion

Managio demonstrates how Firebase can fully replace a traditional backend for Flutter apps, enabling **secure authentication, real-time updates, and scalability** with minimal effort.

### 🔐 Registered Users (Firebase Auth)
![Firebase Auth Users](screenshots/auth_users.png)