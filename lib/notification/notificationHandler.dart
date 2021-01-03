import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) {
    FlutterLocalNotificationsPlugin notificationPlugin = new FlutterLocalNotificationsPlugin();

    //initialise settings for android and IOS separately
    var androidSettings = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOSSettings = new IOSInitializationSettings();

    //initialise settings for both devices
    var settings = new InitializationSettings(androidSettings, IOSSettings);
    notificationPlugin.initialize(settings);
    showNotification(notificationPlugin);
    return Future.value(true);
  });
}

Future showNotification(notificationPlugin) async {

  //android channel
  var androidDetails = new AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High
  );

  //IOS channel
  var IOSDetails = new IOSNotificationDetails();

  //both devices channel
  var platformChannel = new NotificationDetails(androidDetails, IOSDetails);

  await notificationPlugin.show(
    0,
    'MaShRoom',
    'Testing local notifications, and its awesome',
    platformChannel, payload: 'Default_Sound'
  );
}