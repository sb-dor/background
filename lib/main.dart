import 'package:background/notification_permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: !kReleaseMode, home: BackgroundApp());
  }
}

class BackgroundApp extends StatefulWidget {
  const BackgroundApp({super.key});

  @override
  State<BackgroundApp> createState() => _BackgroundAppState();
}

class _BackgroundAppState extends State<BackgroundApp> {
  late final NotificationPermissionHandler _notificationPermissionHandler;

  @override
  void initState() {
    super.initState();
    _notificationPermissionHandler = NotificationPermissionHandler();
    initializeService();
  }

  void initializeService() async {
    bool notificationPermission = await _notificationPermissionHandler.askNotificationPermission();

    // Comment out the following block if you don't need to request notification permissions.
    // This loop will keep prompting the user until permission is granted.
    while (!notificationPermission) {
      notificationPermission = await _notificationPermissionHandler.askNotificationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Background")));
  }
}
