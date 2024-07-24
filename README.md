![image](https://github.com/user-attachments/assets/b8a97d8b-6835-48fe-a09c-06bb2c04832d)

# 📲 SMS Broadcaster/Transceiver
### Seamless Communication Without Internet

Welcome to the **SMS Broadcaster/Transceiver** application! This Flutter app, a part of the ***FORUS*** initiative, ensures reliable people-to-people communication without the need for an internet connection. By utilizing SMS, it provides a robust API-like service for data transmission over 2G networks, making it viable in situations where internet connectivity is unavailable.

## 🌟 Features
- **📨 SMS Broadcasting**: Automatically forwards received messages to a list of predefined numbers.
- **📱 Phone Number Management**: Add, delete, and manage phone numbers for broadcasting.
- **📂 Message Logging**: Keep track of all sent and received messages.
- **🚀 Background Processing**: Continuously listens and processes SMS messages even when the app is not running.

## 📋 Table of Contents
1. [Installation](#installation)
2. [Usage](#usage)
3. [Screens](#screens)
4. [Database](#database)
5. [Contributing](#contributing)
6. [License](#license)

## 🚀 Installation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/yourusername/sms-broadcaster-transceiver.git
    ```

2. **Navigate to the project directory:**
    ```sh
    cd sms-broadcaster-transceiver
    ```

3. **Install dependencies:**
    ```sh
    flutter pub get
    ```

4. **Run the app:**
    ```sh
    flutter run
    ```

## 📖 Usage

1. **Grant SMS permissions:**
   Ensure the app has the necessary SMS permissions to send and receive messages.

2. **Add Phone Numbers:**
   Add phone numbers to the broadcasting list using the `Users` screen.

3. **Receive and Broadcast Messages:**
   Incoming messages from listed numbers will be automatically forwarded to other numbers in the list.

4. **View Logs:**
   Check message logs for detailed information on sent and received messages.

## 🖥️ Screens

### Users Screen
Manage the list of phone numbers.
```dart
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'phone_number_log_screen.dart';

class UsersScreen extends StatefulWidget { ... }

class _UsersScreenState extends State<UsersScreen> { ... }
```

### Read SMS Screen
Listen for and process incoming SMS messages.
```dart
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'database_helper.dart';

class ReadSmsScreen extends StatefulWidget { ... }

class _ReadSmsScreenState extends State<ReadSmsScreen> { ... }
```

### Phone Number Log Screen
View logs for a specific phone number.
```dart
import 'package:flutter/material.dart';
import 'database_helper.dart';

class PhoneNumberLogScreen extends StatelessWidget { ... }
```

## 🗃️ Database

The app uses **SQLite** for local data storage.
- **phone_numbers** table: Stores the list of phone numbers.
- **broadcast_requests** table: Logs of all broadcasted messages.

### Database Helper
```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper { ... }
```

## 📹 Demo

Here are some of the snaps of the Application.

| Screen       | Image                                                                                  |
|--------------|----------------------------------------------------------------------------------------|
| Home Screen  | ![Home Screen](https://github.com/user-attachments/assets/a21c5546-7dc4-4db7-9d4a-296940cd3b82)  |
| Users Screen | ![Users Screen](https://github.com/user-attachments/assets/9e37cf09-a4a9-43ef-a67e-012cb10ee94f)  |

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

1. **Fork the repository**
2. **Create a new branch**
3. **Make your changes**
4. **Submit a pull request**

---

Made with ❤️ by Team FORUS.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)

---

Feel free to explore, use, and contribute to make communication easier and more accessible for everyone! 🌐📡
