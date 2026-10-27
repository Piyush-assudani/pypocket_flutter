import 'system_notification_stub.dart'
    if (dart.library.js_interop) 'system_notification_web.dart';

abstract class SystemNotificationBridge {
  static Future<bool> requestPermission() async {
    return SystemNotificationPlatform.requestPermission();
  }

  static Future<void> showSystemNotification({
    required String title,
    required String body,
    String? iconPath,
  }) async {
    return SystemNotificationPlatform.showSystemNotification(
      title: title,
      body: body,
      iconPath: iconPath,
    );
  }
}
