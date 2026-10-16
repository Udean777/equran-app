import Flutter
import UIKit
import UserNotifications
import alarm
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    // Register the alarm plugin's background refresh task so scheduled
    // alarms can be restored while the app is not running.
    SwiftAlarmPlugin.registerBackgroundTasks()
    
    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "sync_task_1", frequency: NSNumber(value: 24 * 60 * 60))


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
