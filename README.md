Managio – Firebase-Integrated Freelancer Task Management App

Managio is a Flutter-based task management application designed for freelancers to manage tasks efficiently using Firebase Authentication and Cloud Firestore.
This project demonstrates a complete Firebase integration including authentication, real-time database operations, and persistent user sessions.

📌 Sprint-2 Objective

Integrate Firebase Authentication and Cloud Firestore into a Flutter application to enable:

Secure user login and signup

Persistent authentication state

Real-time database CRUD operations

Scalable backend without a traditional server

🔐 Firebase Authentication Flow

App launches

Firebase checks the authentication state

New users sign up using Email & Password

Existing users log in securely

On success, users are redirected to the Dashboard

Session persists even after app restart

Firebase automatically manages:

Password hashing

Session tokens

Secure login state

🗄️ Firestore Database Functionality

Each authenticated user can:

➕ Add records (tasks)

✏️ Edit records

❌ Delete records

👀 View real-time updates

All records are stored inside Cloud Firestore, scoped to the logged-in user.

Firestore enables:

Real-time sync

Automatic UI updates

Secure, scalable data storage

🧩 Features Implemented

Unified Login / Signup Screen

Email & Password Authentication

Auth-based navigation flow

Firestore CRUD operations

Real-time database updates

Persistent user sessions

Clean service-based architecture

🛠️ Tech Stack

Flutter – UI framework

Firebase Core – Firebase initialization

Firebase Authentication – User management

Cloud Firestore – Real-time database

🔥 Firebase Setup Instructions

Create a project in Firebase Console

Add a Web App to the project

Enable Authentication → Email/Password

Enable Cloud Firestore (test mode)

Install Firebase CLI & FlutterFire CLI

Run:

flutterfire configure


Add dependencies in pubspec.yaml

Initialize Firebase in main.dart

Use service files:

auth_service.dart

firestore_service.dart

🧑‍💻 Code Snippets
🔐 Authentication – Signup
Future<User?> signUp(String email, String password) async {
  final credential = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
  return credential.user;
}

🔐 Authentication – Login
Future<User?> login(String email, String password) async {
  final credential = await FirebaseAuth.instance
      .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
  return credential.user;
}

🗄️ Firestore – Add Record
Future<void> addTask(String uid, Map<String, dynamic> data) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('tasks')
      .add(data);
}

✏️ Firestore – Update Record
Future<void> updateTask(String uid, String taskId, Map<String, dynamic> data) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('tasks')
      .doc(taskId)
      .update(data);
}

❌ Firestore – Delete Record
Future<void> deleteTask(String uid, String taskId) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('tasks')
      .doc(taskId)
      .delete();
}

📸 Screenshots (Required)

Include the following screenshots in your PR:

✅ Firebase Authentication → Users

✅ Cloud Firestore → Data

✅ Working Login & Signup Screen

✅ Add / Edit / Delete Firestore Records


![Firebase Auth Users](screenshots/auth_users.png)
![Firestore Data](screenshots/firestore_data.png)
![Firestore Console](screenshots/firebase_console.png)
![User task](screenshots/user_task.png)

🧠 Reflection
🔹 Challenges Faced

Firebase web configuration mismatches

Proper initialization order in Flutter

Handling auth-based navigation flow

Firestore security rules understanding

🔹 What I Learned

How Firebase replaces a traditional backend

Real-time data synchronization with Firestore

Secure authentication without manual session handling

Scalable architecture using Firebase services

🔹 How Firebase Improves Scalability & Collaboration

Automatically scales with user growth

Real-time updates across devices

No backend server maintenance

Ideal for collaborative and live apps