import 'dart:js_interop';
import 'package:web/web.dart' as web;

class SystemNotificationPlatform {
  static Future<bool> requestPermission() async {
    try {
      final permission = await web.Notification.requestPermission().toDart;
      return permission.toDart == 'granted';
    } catch (_) {
      return false;
    }
  }

  static Future<void> showSystemNotification({
    required String title,
    required String body,
    String? iconPath,
  }) async {
    try {
      if (web.Notification.permission == 'granted') {
        web.Notification(
          title,
          web.NotificationOptions(
            body: body,
            icon: iconPath ?? 'icons/Icon-192.png',
          ),
        );
      } else {
        final granted = await requestPermission();
        if (granted) {
          web.Notification(
            title,
            web.NotificationOptions(
              body: body,
              icon: iconPath ?? 'icons/Icon-192.png',
            ),
          );
        }
      }
    } catch (_) {}
  }
}
