import 'dart:async';
import 'dart:ui';

import 'package:background/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

// FROM DOCUMENTATION:

// Call FlutterBackgroundService.configure() to configure handler that will be executed by the Service.

//      It's highly recommended to call this method in main() method to ensure the callback handler updated.

//      Call FlutterBackgroundService.start to start the Service if autoStart is not enabled.

// Since the Service using Isolates, You won't be able to share reference between UI and Service. You can communicate between UI and Service using invoke() and on(String method).

class BackgroundService {
  Future<void> initializeForgroundService() async {
    final service = FlutterBackgroundService();

    final androidConfiguration = AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true, // if it's true -> always shows notification
      autoStart: true,
    );

    final iosConfiguration = IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    );

    await service.configure(
      iosConfiguration: iosConfiguration,
      androidConfiguration: androidConfiguration,
    );
  }

  Future<bool> startForgroundService() {
    final service = FlutterBackgroundService();
    return service.startService();
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
  DartPluginRegistrant.ensureInitialized();
  final notificationService = NotificationService();
  Timer.periodic(const Duration(seconds: 10), (timer) {
    notificationService.showNotificaion(1);
  });
}
