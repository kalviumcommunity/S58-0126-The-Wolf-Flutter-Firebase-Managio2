# Managio - Freelancer Task Management App

Managio is a **Flutter-based task management application** that leverages Firebase as a backend to manage user authentication, real-time task updates, and client workflow tracking. The app is designed to help freelancers organize tasks, deadlines, and payments in a **unified, real-time system**.

---

## Overview

Freelancers often juggle multiple clients, deadlines, and payments without a central system, leading to confusion and missed follow-ups. Managio addresses this by providing a mobile-first solution with **secure authentication, real-time task tracking, and persistent sessions**.  

With Firebase as the backend, the app removes the need for managing servers, APIs, or databases manually, allowing freelancers to focus on productivity and efficiency.

---

## Features

- Unified **Login and Signup** screen
- Secure **email and password authentication**
- **Real-time task synchronization** across devices
- Automatic navigation based on **authentication state**
- Persistent **user sessions** across app restarts
- User-friendly **task management dashboard**

---

## Tech Stack

- **Flutter**: Cross-platform mobile development
- **Firebase Authentication**: User login and session management
- **Cloud Firestore**: Real-time database for tasks
- **Firebase Core**: App initialization and configuration

---

## Firebase Integration

### Authentication

- Firebase Authentication handles user registration, login, logout, and session persistence
- The app listens to authentication state changes and updates the UI automatically

### Database

- Cloud Firestore stores tasks as documents in a collection
- Changes are instantly synchronized across all connected devices

---

## Application Flow

1. App launches and checks for authenticated user
2. If not authenticated, a unified **login/signup screen** is displayed
3. Upon successful authentication, the user is navigated to the **home/dashboard**
4. Tasks added appear instantly without manual refresh
5. Authentication state persists even after restarting the app

---

## Architecture

- Clean and modular architecture
- Clear separation of **UI and backend logic**
- Firebase services accessed through dedicated service layers
- Maintainable and scalable code structure

---

## Benefits of Using Firebase

- No server maintenance required
- Built-in security and authentication handling
- Real-time data synchronization out of the box
- Automatic scalability for growing user base
- Consistent behavior across Android and iOS

---

## Future Enhancements

- Task editing and deletion
- Client-specific task filtering
- Task completion and payment tracking
- Push notifications for deadlines
- Offline data support

---

## Conclusion

Managio simplifies task and workflow management for freelancers by combining **authentication, real-time updates, and a scalable backend** using Firebase. It ensures secure access, instant synchronization, and a productive mobile-first experience.

---

## Live Demo

- Hosted on Firebase Hosting (replace with your live URL after deployment):

  