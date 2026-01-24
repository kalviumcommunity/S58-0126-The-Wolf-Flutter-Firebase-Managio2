Managio – Freelancer Task Management App

Managio is a Flutter-based task management application that uses Firebase as a backend to help freelancers manage tasks, deadlines, and workflows in a unified and real-time system.

🚀 Problem Statement

Freelancers often juggle multiple tasks, client deadlines, and follow-ups without a centralized platform, leading to confusion and missed work.
Managio solves this by providing a secure, scalable, and real-time task management solution.

🧩 Features

Unified Login & Signup screen

Secure Email/Password Authentication

Real-time task updates using Cloud Firestore

Automatic navigation based on authentication state

Persistent user sessions

Clean and modular architecture

🛠️ Tech Stack

Flutter – Cross-platform UI development

Firebase Authentication – User management

Cloud Firestore – Real-time database

Firebase Core – App initialization

🔥 Firebase Setup Steps

Create a Firebase project from Firebase Console

Enable Authentication → Email/Password

Enable Cloud Firestore

Add Firebase dependencies in pubspec.yaml

Configure Firebase using firebase_options.dart

Initialize Firebase in main.dart

Use Firebase Auth and Firestore through service classes

🔄 How Firestore Real-Time Sync Works

Tasks are stored as documents in Firestore collections

Firestore provides real-time listeners

Any data change is instantly pushed to connected clients

No manual refresh or polling is required

This ensures smooth and instant updates across devices.

📸 Proof of Real-Time Updates

Firebase Console → Firestore → Data shows task updates instantly

Firebase Console → Authentication → Users shows live user registrations

No app reload required to reflect changes

(Screenshots or console logs can be added here)

🏗️ Application Flow

App checks authentication state on launch

Unauthenticated users see login/signup screen

Successful login redirects to dashboard

Tasks sync instantly using Firestore

User session persists across restarts

🧠 Reflection: Why Firebase?

Firebase simplified backend development by:

Eliminating server and API management

Providing built-in authentication and security

Offering real-time data synchronization

Automatically scaling with user growth

This allowed faster development and a better user experience.

🔮 Future Enhancements

Task editing and deletion

Client-based task grouping

Payment and deadline tracking

Push notifications

Offline support

✅ Conclusion

Managio demonstrates how Firebase can fully replace a traditional backend for Flutter apps, enabling secure authentication, real-time updates, and scalability with minimal effort.