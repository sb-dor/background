import Flutter
import UIKit
import flutter_local_notifications
import flutter_background_service_ios

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "ios.custom.task.identifier"

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
