# Task_Manager_Application

A complete Flutter Task Manager application integrated with Parse Server (Back4App).  
This app allows users to register, log in, and manage tasks with full cloud synchronization.

## Getting Started

This project is a functional Flutter application that uses the Parse Server SDK for backend services such as authentication, task storage, and real-time updates.

### Features included in this project:

- 🔐 **User Authentication**
  - Register new users  
  - Login with session handling  
  - Auto-login using saved session token  

- 📝 **Task Management**
  - Create new tasks  
  - Edit existing tasks  
  - Delete tasks  
  - Mark tasks as completed  
  - Status support: **open**, **pending**, **completed**

- 📂 **Task Organization**
  - View all tasks  
  - Filter tasks by status  
  - Dedicated *Completed Tasks* screen  
  - Completion timestamp tracking  

- ☁ **Parse Backend Integration**
  - Back4App Parse Server  
  - User → Task ownership using pointers  
  - Secure cloud data storage  

---

## Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── tasks_screen.dart
│   ├── task_form_screen.dart
│   ├── completed_tasks_screen.dart
├── services/
│   └── parse_service.dart
└── widgets/
    └── task_tile.dart
```

---

## Setup Instructions

### 1. Install dependencies

```
flutter pub get
```

### 2. Configure Back4App

Update the following values inside `main.dart`:

```dart
const String APP_ID = 'YOUR_APP_ID';
const String CLIENT_KEY = 'YOUR_CLIENT_KEY';
const String PARSE_SERVER_URL = 'https://parseapi.back4app.com';
```

### 3. Run the application

```
flutter run
```

---
