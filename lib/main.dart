import 'package:background/notification_permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final flutterLocalNotificaionPlugin = FlutterLocalNotificationsPlugin();

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
  int notificatioId = 1;

  @override
  void initState() {
    super.initState();
    _notificationPermissionHandler = NotificationPermissionHandler();
    initialize();
  }

  void initialize() async {
    bool notificationPermission = await _notificationPermissionHandler.askNotificationPermission();

    // Comment out the following block if you don't need to request notification permissions.
    // This loop will keep prompting the user until permission is granted.
    while (!notificationPermission) {
      notificationPermission = await _notificationPermissionHandler.askNotificationPermission();
    }

    await initializeNotificationService();
    await initializeForgroundService();
  }

  Future<void> initializeNotificationService() async {
    final androidSettings = AndroidInitializationSettings('app_icon');
    // no actions for now
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // android and ios for now
    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificaionPlugin.initialize(initializationSettings);
  }

  Future<bool> initializeForgroundService() {
    final service = FlutterBackgroundService();
    return service.startService();
  }

  Future<void> showNotificaion() async {
    final androidNotificationDetails = AndroidNotificationDetails(
      "android_channel_id",
      "android_channel_name",
      channelDescription: "android channel description",
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker",
    );

    final iosNotificationDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificaionPlugin.show(
      notificatioId++,
      "Test notification title",
      "Test notification body",
      notificationDetails,
      payload: "item x"
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Background")),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  showNotificaion();
                },
                child: Text("Show notification"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
