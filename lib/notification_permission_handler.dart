import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

const List<PermissionStatus> notGrantedStatuses = [
  PermissionStatus.denied,
  PermissionStatus.permanentlyDenied,
];

@immutable
class NotificationPermissionHandler {
  //
  const NotificationPermissionHandler();

  Future<bool> askNotificationPermission({int counter = 0}) async {
    if (counter >= 2) {
      await openAppSettings();
      return false;
    }

    PermissionStatus notificationPermission = await Permission.notification.status;

    if (notGrantedStatuses.contains(notificationPermission)) {
      notificationPermission = await Permission.notification.request();
    }

    if (notGrantedStatuses.contains(notificationPermission)) {
      counter = counter + 1;
      return askNotificationPermission(counter: counter);
    }

    return notificationPermission.isGranted;
  }
}
