import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:schedule_dva232/globalNotification.dart' as global;

void callbackDispatcher() {
  print('in callback');
  Workmanager.executeTask((taskName, inputData) {
    FlutterLocalNotificationsPlugin notificationPlugin = new FlutterLocalNotificationsPlugin();

    //initialise settings for android and IOS separately
    var androidSettings = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = new IOSInitializationSettings();

    //initialise settings for both devices
    var settings = new InitializationSettings(androidSettings, iOSSettings);
    notificationPlugin.initialize(settings);
    showNotification(notificationPlugin, inputData['string']);

    return Future.value(true);
  });
}

Future showNotification(notificationPlugin, String text) async {

  //android channel
  var androidDetails = new AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High
  );

  //IOS channel
  var iOSDetails = new IOSNotificationDetails();

  //both devices channel
  var platformChannel = new NotificationDetails(androidDetails, iOSDetails);

  //global.notificationList.forEach((element) async{
    await notificationPlugin.show(
        0,
        'New Notification',
        '$text',
        platformChannel, payload: 'Default_Sound'
    );
  print('show notifications');

  //});

}