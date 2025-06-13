import 'dart:async';
import 'dart:ui';

import 'package:background/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// FROM DOCUMENTATION:

// Call FlutterBackgroundService.configure() to configure handler that will be executed by the Service.

//      It's highly recommended to call this method in main() method to ensure the callback handler updated.

//      Call FlutterBackgroundService.start to start the Service if autoStart is not enabled.

// Since the Service using Isolates, You won't be able to share reference between UI and Service.

// You can communicate between UI and Service using invoke() and on(String method).

// -----------

// Keep in your mind, iOS doesn't have a long running service feature like Android. So, it's not possible

// to keep your application running when it's in background because the OS will suspend your application

// soon. Currently, this plugin provide onBackground method, that will be executed periodically by

// "Background Fetch" capability provided by iOS. It cannot be faster than 15 minutes and only alive about 15-30 seconds.

class BackgroundService {
  Future<void> initializeBackgroundService() async {
    final service = FlutterBackgroundService();

    final androidConfiguration = AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true, // if it's true -> always shows notification
      autoStart: false, // if it's true - you dont have to start it manually with another function
    );

    final iosConfiguration = IosConfiguration(
      autoStart: false, // if it's true - you dont have to start it manually with another function
      onForeground: onStart,
      onBackground: onIosBackground,
    );

    await service.configure(
      iosConfiguration: iosConfiguration,
      androidConfiguration: androidConfiguration,
    );
  }

  // if you didnt set autoStart in configuration
  // then you have to enable it manually
  Future<bool> _startBackgroundService() {
    final service = FlutterBackgroundService();
    return service.startService();
  }

  Future<void> _stopService() async {
    final service = FlutterBackgroundService();
    service.invoke('stop');
  }

  Future<bool> isRunning() {
    final service = FlutterBackgroundService();
    return service.isRunning();
  }

  Future<bool> startBackgroundServiceWithChecking() async {
    final isServiceRunning = await isRunning();
    if (isServiceRunning) return true;
    return _startBackgroundService();
  }

  Future<bool> stopServiceWithChecking() async {
    final isServiceRunning = await isRunning();
    if (!isServiceRunning) return true; // service is not running
    await _stopService();
    return true;
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // if user sends stop event then stop the background service
  service.on("stop").listen((event) {
    service.stopSelf();
  });

  //
  DartPluginRegistrant.ensureInitialized();
  final notificationService = NotificationService(FlutterLocalNotificationsPlugin());
  Timer.periodic(const Duration(seconds: 10), (timer) {
    notificationService.showNotificaion(1);
  });
}
