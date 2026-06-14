import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../app.dart';

/// Android notification channel used for all heads-up notifications.
/// Importance.high makes Android slide the banner down from the top.
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'sinemax_high_importance',
  'New content & episodes',
  description: 'Alerts for newly added movies, series and episodes.',
  importance: Importance.high,
);

/// Set when the app is launched (from terminated state) by tapping a
/// notification. The splash screen consumes this so its auto-redirect to
/// `/home` does not wipe the deep link. See `splash_screen.dart`.
String? pendingNotificationMediaId;

class FcmService {
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _initLocalNotifications();

    await Future.wait([
      FirebaseMessaging.instance.subscribeToTopic('new_content'),
      FirebaseMessaging.instance.subscribeToTopic('new_episodes'),
    ]);

    // Foreground: FCM does NOT show a system notification, so we render one
    // ourselves via flutter_local_notifications.
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // Background (app alive) tap on an FCM system notification → deep link.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _navigateToMedia(message.data['media_id'] as String?);
    });

    // Terminated → tapped a notification to launch the app.
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      // Defer navigation: the splash screen will consume this once it's ready.
      pendingNotificationMediaId = initial.data['media_id'] as String?;
    }
  }

  static Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _local.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        _navigateToMedia(response.payload);
      },
    );

    // Create the channel so Android (8+) and background FCM messages use it.
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _local.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      // Tapping the notification reports this payload back to us.
      payload: message.data['media_id'] as String?,
    );
  }

  static void _navigateToMedia(String? mediaId) {
    if (mediaId == null || mediaId.isEmpty) return;
    appRouter.push('/detail/$mediaId?autoplay=1');
  }
}
