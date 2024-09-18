// lib/services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 알림 초기화 함수
  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // 알림 초기화
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 권한 요청
    await _requestPermissions();
  }

  // 알림 권한 요청 함수
  static Future<void> _requestPermissions() async {
    // Android 13+에서는 알림 권한이 필요함
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
  // 백그라운드 작업 콜백 함수
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      await showNotification(inputData!['title'], inputData['body']);
      return Future.value(true);
    });
  }

  // 알림 표시 함수
  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // 알림 예약 함수 (여러 기프티콘을 하나의 알림으로 묶어서 예약)
  static void scheduleNotification(
      DateTime selectedDate, List<String> couponList, int nDays) {
    final DateTime scheduledTime = selectedDate.subtract(Duration(days: nDays));
    final now = DateTime.now();
    final initialDelay =
        scheduledTime.isAfter(now) ? scheduledTime.difference(now) : Duration.zero;

    // 알림에 포함할 쿠폰 목록을 문자열로 변환
    String couponNames = couponList.join(', ');

    Workmanager().registerOneOffTask(
      'uniqueName', // 작업의 고유 이름
      'simpleTask',
      initialDelay: initialDelay, // 처음 시작할 때의 지연 시간
      inputData: {
        'title': '기프티콘 알림',
        'body': '다음 기프티콘들이 곧 만료됩니다: $couponNames'
      },
    );
  }
}
