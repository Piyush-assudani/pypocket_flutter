class SystemNotificationPlatform {
  static Future<bool> requestPermission() async {
    return true;
  }

  static Future<void> showSystemNotification({
    required String title,
    required String body,
    String? iconPath,
  }) async {
    // Mobile fallback log
  }
}
