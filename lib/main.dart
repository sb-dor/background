import 'package:background/background_service.dart';
import 'package:background/notification_permission_handler.dart';
import 'package:background/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final backgroundService = BackgroundService();
  await backgroundService.initializeBackgroundService();
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
  late final NotificationService _notificationService;
  late final BackgroundService _backgroundService;
  bool backgroundServiceEnabled = false;
  int notificatioId = 0;

  @override
  void initState() {
    super.initState();
    _notificationPermissionHandler = NotificationPermissionHandler();
    _notificationService = NotificationService(FlutterLocalNotificationsPlugin());
    _backgroundService = BackgroundService();
    initialize();
  }

  void initialize() async {
    bool notificationPermission = await _notificationPermissionHandler.askNotificationPermission();

    // Comment out the following block if you don't need to request notification permissions.
    // This loop will keep prompting the user until permission is granted.
    while (!notificationPermission) {
      notificationPermission = await _notificationPermissionHandler.askNotificationPermission();
    }

    await _notificationService.initializeNotificationService();

    await _backgroundService.startBackgroundServiceWithChecking();

    backgroundServiceEnabled = await _backgroundService.isRunning();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Background")),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _notificationService.showNotificaion(++notificatioId);
                  },
                  child: Text("Show notification"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (backgroundServiceEnabled) {
                      await _backgroundService.stopServiceWithChecking();
                      backgroundServiceEnabled = false;
                      setState(() {});
                    } else {
                      backgroundServiceEnabled =
                          await _backgroundService.startBackgroundServiceWithChecking();
                      setState(() {});
                    }
                  },
                  child: Text(
                    backgroundServiceEnabled
                        ? "Stop background service"
                        : "Start background service",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
