# MANAGIO - Firebase Authentication Flow

A Flutter-based task management application demonstrating complete Firebase Authentication implementation with sign up, login, and logout flows for freelancers to manage tasks efficiently.

## 📌 Assignment 2.29 Overview

This project implements a seamless authentication flow using Firebase Authentication in Flutter, including:
- **Sign Up** – Create new user accounts
- **Login** – Authenticate existing users
- **Logout** – End session and return to login screen
- **Real-time Auth State Management** – Automatic navigation based on user session

## 🔐 Authentication Flow Explanation

### Sign Up Logic
New users can create an account using email and password authentication:
```dart
Future signUp(String email, String password) async {
  final UserCredential credential =
      await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  return credential.user;
}
```

**What happens during signup:**
1. User enters email and password in the login screen
2. `createUserWithEmailAndPassword()` creates a new Firebase account
3. Firestore profile is automatically created with user email and timestamp
4. User is redirected to the Dashboard screen
5. Session persists even after app restart

### Login Logic
Existing users authenticate with their credentials:
```dart
Future signIn(String email, String password) async {
  final UserCredential credential =
      await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  return credential.user;
}
```

**What happens during login:**
1. User enters registered email and password
2. `signInWithEmailAndPassword()` validates credentials
3. Firebase returns authenticated user session
4. App automatically navigates to Dashboard
5. User can now perform CRUD operations on tasks

### Logout Logic
Users can securely end their session:
```dart
Future signOut() async {
  await _auth.signOut();
}
```

**What happens during logout:**
1. User clicks logout icon in Dashboard AppBar
2. `FirebaseAuth.instance.signOut()` clears the session
3. Auth state changes to `null`
4. App automatically redirects to Login screen
5. All session tokens are invalidated

### authStateChanges() - Real-time Session Management

Although not explicitly in `main.dart` with StreamBuilder in this implementation, the app uses navigation-based auth handling:
```dart
// In login_screen.dart after successful auth:
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const DashboardScreen(),
  ),
);

// In dashboard_screen.dart for logout:
await _authService.signOut();
if (mounted) {
  Navigator.pushReplacementNamed(context, '/');
}
```

**How it works:**
- Firebase maintains the authentication state in the background
- `FirebaseAuth.instance.currentUser` returns current user or null
- Navigation logic ensures users see appropriate screens based on auth state
- No manual session management required

## 📱 Screen Code Snippets

### Login Screen (Sign Up + Login Toggle)
```dart
class LoginScreen extends StatefulWidget {
  // ... state management
  
  bool isLogin = true; // Toggle between login and signup modes
  
  Future handleAuth() async {
    if (isLogin) {
      await _authService.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } else {
      final user = await _authService.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      await _firestoreService.createUserProfile(
        emailController.text.trim(),
      );
    }
    // Navigate to dashboard on success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }
  
  // Toggle button
  TextButton(
    onPressed: () {
      setState(() {
        isLogin = !isLogin;
      });
    },
    child: Text(
      isLogin
          ? "Don't have an account? Sign up"
          : "Already have an account? Login",
    ),
  )
}
```

**Key Features:**
- Single screen handles both signup and login
- Toggle button switches between modes
- Email validation (must contain @)
- Password validation (minimum 8 characters)
- Loading indicator during authentication
- Error handling with SnackBar messages

### Dashboard Screen (Logged-in State)
```dart
class DashboardScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MANAGIO Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Task input field
          // StreamBuilder for real-time task list
          // Edit and Delete functionality
        ],
      ),
    );
  }
}
```

**Key Features:**
- Displays user's tasks from Firestore
- Real-time updates using StreamBuilder
- Add, edit, delete task operations
- Logout button in AppBar
- Automatic redirect to login on logout

## 🗄️ Firestore Integration

### Create User Profile
```dart
Future createUserProfile(String email) async {
  final uid = _auth.currentUser!.uid;
  await _db.collection('users').doc(uid).set({
    'email': email,
    'createdAt': Timestamp.now(),
  });
}
```

### Add Task
```dart
Future addTask(String title) async {
  final uid = _auth.currentUser!.uid;
  await _db.collection('tasks').add({
    'uid': uid,
    'title': title,
    'createdAt': Timestamp.now(),
  });
}
```

### Real-time Task Stream
```dart
Stream getTasks() {
  final uid = _auth.currentUser!.uid;
  return _db
      .collection('tasks')
      .where('uid', isEqualTo: uid)
      .snapshots();
}
```

## 📸 Screenshots

### 1. Login/Signup Screen
![Login Screen](screenshots/auth_users.png)

### 2. Dashboard with Tasks
![Dashboard](screenshots/user_task.png)

### 3. Firebase Console - Authentication
![Firebase Auth](screenshots/firebase_console.png)

### 4. Firebase Console - Firestore Data
![Firestore Data](screenshots/firestore_data.png)

## 🧠 Reflection

### What was the hardest part of building the flow?

The most challenging aspect was managing the authentication state seamlessly across screens without using a global StreamBuilder in `main.dart`. Initially, I struggled with:

1. **Navigation timing** - Ensuring the Firestore profile was created before navigating to the dashboard
2. **Error handling** - Catching and displaying meaningful Firebase Auth exceptions (invalid email, weak password, user already exists)
3. **Session persistence** - Understanding how Firebase maintains sessions across app restarts without explicit token management
4. **Async operations** - Coordinating signup → profile creation → navigation in the correct order

I solved these by adding proper try-catch blocks, using `await Future.delayed()` between operations, and implementing comprehensive form validation.

### How does StreamBuilder simplify navigation?

Although this implementation uses manual navigation, StreamBuilder would simplify it significantly:
```dart
// Ideal implementation with StreamBuilder
StreamBuilder(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (ctx, snapshot) {
    if (snapshot.hasData) {
      return DashboardScreen(); // User logged in
    }
    return LoginScreen(); // User logged out
  },
)
```

**Benefits of StreamBuilder approach:**
- **Automatic navigation** - No manual `Navigator.push()` calls needed
- **Real-time updates** - UI rebuilds instantly when auth state changes
- **Zero flicker** - Seamless transitions without visible routing
- **Single source of truth** - Auth state determines which screen to show
- **Cleaner code** - Eliminates navigation logic from individual screens

### Why is logout essential for session security?

Logout is critical for multiple reasons:

1. **Security on Shared Devices**
   - Prevents unauthorized access if device is shared
   - Protects sensitive task data from other users
   - Essential in public or family devices

2. **Session Management**
   - Properly terminates Firebase session and clears tokens
   - Invalidates authentication credentials
   - Prevents session hijacking or token reuse

3. **Privacy Protection**
   - Ensures user data isn't accessible after they leave
   - Prevents accidental data exposure
   - Complies with data protection best practices

4. **User Control**
   - Gives users explicit control over their authenticated state
   - Allows switching between multiple accounts
   - Builds trust by respecting user autonomy

In our implementation, `FirebaseAuth.instance.signOut()` handles all of this automatically, clearing the session and triggering a redirect to the login screen.