import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripapp/components/helper.dart';
import 'package:tripapp/views/main_app.dart';
import 'package:tripapp/views/login.dart';
import 'package:tripapp/views/completa_profilo.dart';
import 'package:tripapp/views/visualizza_viaggio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tripapp/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  Logger().d("Handling a background message: ${message.messageId}");
}

var screen;
void main() async {
  //Check Widget Binding
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().catchError((e) {
    print('Errore ${e.toString()}');
  });

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /*
  var androiInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosInit = DarwinInitializationSettings(requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
    );
  var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
  */
  NotificationSettings notificationSettings =
      await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (notificationSettings.authorizationStatus ==
      AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (notificationSettings.authorizationStatus ==
      AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'default_channel_notification_id',
    'channel',
    enableLights: true,
    enableVibration: true,
    priority: Priority.high,
    importance: Importance.max,
  );

  const generalNotificationDetails =
      NotificationDetails(android: androidDetails);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //flutterLocalNotificationsPlugin.initialize(initSetting);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  final bool? result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    print('Remote ${notification}');

    AndroidNotification? android = message.notification?.android;

    if (message.notification != null && android != null) {
      print('Message also contained a notification: ${message.notification}');
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title,
        notification?.body,
        generalNotificationDetails,
      );
    }
  });

  //Start spalsh screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //Get shared preferences instance
  String? firebaseToken = await firebaseMessaging.getToken();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //check if user is yet logged in
  var userid = prefs.getString("userId");
  var completaProfilo = prefs.getString('_completa_profilo');
  var deviceToken = prefs.setString('deviceToken', firebaseToken ?? "");

  if (userid == null) {
    screen = Login();
  } else if (userid != null && completaProfilo == "1") {
    if (firebaseToken != null || firebaseToken != "")
      screen = MainApplication();
  } else {
    if (firebaseToken != null || firebaseToken != "")
      screen = CompletaProfilo(
        userId: userid,
        firstName: "",
        lastName: "",
      );
  }

  runApp(const TripApp());
}

class TripApp extends StatelessWidget {
  const TripApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TripToShare',
      theme: _buildTheme(Brightness.light),
      home: screen,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("it", ''),
      ],
    );
  }
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
    textTheme: GoogleFonts.redHatTextTextTheme(baseTheme.textTheme),
  );
}
