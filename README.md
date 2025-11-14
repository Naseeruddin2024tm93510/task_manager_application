# Task_Manager_Application

A complete Flutter Task Manager application integrated with Parse Server (Back4App).  
This app allows users to register, log in, and manage tasks with full cloud synchronization.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

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
## 4. Screenshots

We are using Android Studio Emulator to run this Flutter application.

### 📌 Application Launch  
When we run the application, Flutter builds and installs the app on the emulator.

<img width="1365" height="721" alt="App Launch 1" src="https://github.com/user-attachments/assets/a05621f6-20aa-4777-923a-c466f1600393" />
<img width="1365" height="721" alt="App Launch 2" src="https://github.com/user-attachments/assets/51521775-4969-421d-8a6c-21fc7e18b5d0" />

---

### 🏠 Login Screen (Starting Page)
This is the first screen where the user can enter login credentials.

<img width="1080" height="2400" alt="Login Screen" src="https://github.com/user-attachments/assets/494fd6b5-7847-4599-8e24-6155b5bb5859" />

---

### 📝 Registration Screen
Users can create a new account by providing email and password.

<img width="1080" height="2400" alt="Register Screen" src="https://github.com/user-attachments/assets/2009a9e9-31a1-4d02-98fe-e47b24eb31d5" />

---

### ✔ User Registered Successfully
After registration, the app navigates back to login for authentication.

<img width="1080" height="2400" alt="Registration Success" src="https://github.com/user-attachments/assets/22dd07f2-c28a-48a3-9aaa-a83cf61fd82f" />

---

### 🔑 Logging Into the Application
The user logs in using the newly registered credentials.

<img width="1080" height="2400" alt="Login Successful" src="https://github.com/user-attachments/assets/84e4d1f1-8f0b-4a07-b995-48bbbbb3c741" />

---

### 📂 Navigation Drawer (Menu)
Users can access All Tasks, Open, Pending, and Completed tasks.

<img width="1080" height="2400" alt="Navigation Drawer" src="https://github.com/user-attachments/assets/4ee252f4-a433-4860-be83-724a3adfbdae" />

---

### ➕ Creating a New Task
Task form for adding title, description, and selecting status.

<img width="1080" height="2400" alt="Create Task 1" src="https://github.com/user-attachments/assets/58e70a85-49b2-4b46-bf33-1dfd0b0cba0b" />
<img width="1080" height="2400" alt="Create Task 2" src="https://github.com/user-attachments/assets/67a72ee3-71e4-488f-ab7a-527c028f95e6" />

---

### ✏ Editing Task Details
Users can modify task fields or update status.

<img width="1080" height="2400" alt="Edit Task" src="https://github.com/user-attachments/assets/6272c5d9-7e37-4f05-b479-2680c6ee0185" />
<img width="1080" height="2400" alt="Edit Status" src="https://github.com/user-attachments/assets/a544edac-12ed-42de-b7d4-4af69f0ab2c5" />

---

### ✔ Marking Tasks as Completed
When a task is completed, the timestamp is saved.

<img width="1080" height="2400" alt="Mark Task Completed" src="https://github.com/user-attachments/assets/e9fd8a6c-c531-44c4-b5f9-711f343e32eb" />
<img width="1080" height="2400" alt="Completion Timestamp" src="https://github.com/user-attachments/assets/e4ea3f1a-c056-4e39-8f8f-ea9a2b30fd87" />

---

### 📋 Viewing Open Tasks
Tasks filtered by **Open** status.

<img width="1080" height="2400" alt="Open Tasks" src="https://github.com/user-attachments/assets/a6797fc8-19aa-48dd-adff-1baaedb0655a" />

---

### 📋 Viewing Pending Tasks
Tasks filtered by **Pending** status.

<img width="1080" height="2400" alt="Pending Tasks" src="https://github.com/user-attachments/assets/805b299c-c6b4-4bcc-9500-aa922789bfe9" />

---

### 📋 Viewing Completed Tasks
Tasks filtered by **Completed** status.

<img width="1080" height="2400" alt="Completed Tasks" src="https://github.com/user-attachments/assets/7c531144-2252-4aaa-b4cb-25212e4d5236" />

---

### 🗑 Deleting a Task
Confirmation popup appears before deleting.

<img width="1080" height="2400" alt="Delete Task" src="https://github.com/user-attachments/assets/bb1608b8-8452-40c0-a12b-7a78afe87184" />

---

### 🔄 Refreshing Task List (Pull to Refresh)

<img width="1080" height="2400" alt="Refresh Tasks" src="https://github.com/user-attachments/assets/7d62edce-03c1-4b41-ae74-5070be9bb93a" />

<img width="1080" height="2400" alt="No Tasks Available" src="https://github.com/user-attachments/assets/955c27dd-08e5-4a48-bacd-3d399d11d101" />

---

### 👤 Logging In Again with Registered User

<img width="1080" height="2400" alt="Re-login" src="https://github.com/user-attachments/assets/390fe0a4-4cf8-418a-a187-09ac9c42b85a" />

<img width="1080" height="2400" alt="Parse User Details" src="https://github.com/user-attachments/assets/0aa9bbd0-0e27-4595-9acf-9b7de574d9db" />

---



















