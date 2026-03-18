# CVRAA App - API Setup Instructions

## Prerequisites
- XAMPP installed and running
- MySQL database with `cvraa_attendance_db` imported
- Flutter installed on your development machine

## Setup Steps

### 1. Copy API Files to XAMPP
Copy the `api` folder to your XAMPP htdocs directory:
```
C:\xampp\htdocs\cviraa_app\api\
```

### 2. Import Database
1. Open phpMyAdmin (http://localhost/phpmyadmin)
2. Create database `cvraa_attendance_db` if not exists
3. Import `cviraa_attendance_db.sql`

### 3. Test API Endpoints
Test in browser or Postman:
- Login: http://localhost/cviraa_app/api/login.php
- Scan QR: http://localhost/cviraa_app/api/scan_qr.php

### 4. Configure Flutter App

#### Find Your Computer's IP Address:
1. Open Command Prompt (cmd)
2. Type: `ipconfig`
3. Look for "IPv4 Address" (e.g., 192.168.1.100)

#### Update API URL:
Open `lib/services/api_service.dart` and change:
```dart
static const String baseUrl = 'http://YOUR_IP_ADDRESS/cviraa_app/api';
```
Replace `YOUR_IP_ADDRESS` with your actual IP (e.g., 192.168.1.100)

### 5. Update Android Permissions
The app already has internet permission, but verify in:
`android/app/src/main/AndroidManifest.xml`

Should have:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### 6. Test Login
Use the existing admin account from your database:
- Username: admin
- Password: (the password you set in the database)

## API Endpoints

### POST /api/login.php
Request:
```json
{
  "username": "admin",
  "password": "your_password"
}
```

Response:
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "id": 2,
    "username": "admin",
    "full_name": "Admin Name",
    "role": "admin",
    "profile_picture": "path/to/image.jpg"
  }
}
```

### POST /api/scan_qr.php
Request:
```json
{
  "participantID": "119158210067",
  "coach_username": "admin",
  "checkpoint": "gate"
}
```

Response:
```json
{
  "success": true,
  "message": "Time IN recorded",
  "data": {
    "action": "time_in",
    "student": {
      "id": 1,
      "participantID": "119158210067",
      "fullname": "CALEB GREY EJADA",
      "division": "CARCAR CITY",
      "event": "ARNIS"
    },
    "time": "2026-03-09 14:30:00",
    "checkpoint": "gate"
  }
}
```

## Troubleshooting

### Connection Error
- Make sure XAMPP Apache is running
- Check if your phone and computer are on the same WiFi network
- Verify the IP address in `api_service.dart` is correct
- Try accessing http://YOUR_IP/cviraa_app/api/login.php from your phone's browser

### Database Error
- Check database credentials in `api/config.php`
- Make sure MySQL is running in XAMPP
- Verify database name is correct

### Login Failed
- Check if admin user exists in database
- Password must be hashed with bcrypt (use PHP's `password_hash()`)
- To create a test user, run this in phpMyAdmin:
```sql
INSERT INTO admin (username, password, full_name, role) 
VALUES ('test', '$2y$10$djG9Fttls7.k8SKKKvXUrO8kShSkanDf8YQwXISfzxt4P5ej/1aym', 'Test User', 'coach');
-- Password is: admin123
```

## Running the App

1. Make sure XAMPP is running (Apache + MySQL)
2. Connect your Android device via USB or use same WiFi
3. Run: `flutter pub get`
4. Run: `flutter run`
5. Login with your admin credentials
6. Scan QR codes to record attendance
