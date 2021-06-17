import 'dart:async';
import 'dart:convert';

import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:fcm/app/domain/repositories/local_notifications_repository.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:fcm/app/isolates_utils/on_background_message.dart';
import 'package:fcm/app/ui/routes/pages.dart';
import 'package:fcm/app/ui/routes/routes.dart';
import 'package:fcm/dependency_injection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await injectDependencies();
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late StreamSubscription _chatSubscription, _localChatSubscription;
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _foreground = true;

  @override
  void initState() {
    super.initState();
    _init();
    WidgetsBinding.instance!.addObserver(this);
  }

  Future<void> _init() async {
    final localNotifications = GetIt.I.get<LocalNotificationsRepository>();
    final pushNotifications = GetIt.I.get<PushNotificationsRepository>();
    await localNotifications.initialize();
    // await pushNotifications.requestPermission();
    pushNotifications.subscribeToTopic('promos');
    final chatStream = pushNotifications.onNotification.where(
      (e) => e.type == AppNotificationTypes.CHAT,
    );
    _chatSubscription = chatStream.listen((notification) {
      if (_foreground) {
        localNotifications.show(
          notification.title,
          notification.body,
          payload: jsonEncode(
            {
              "type": AppNotificationTypes.CHAT,
              "content": notification.content,
            },
          ),
        );
      } else {
        final context = _navigatorKey.currentState!.context;
        Navigator.pushNamed(
          context,
          Routes.CHAT,
          arguments: notification.content['chatId'],
        );
      }
    });

    _localChatSubscription = localNotifications.onChatNotification.listen((chatId) {
      final context = _navigatorKey.currentState!.context;
      Navigator.pushNamed(context, Routes.CHAT, arguments: chatId);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _foreground = false;
    } else if (state == AppLifecycleState.resumed) {
      _foreground = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _chatSubscription.cancel();
    _localChatSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: _navigatorKey,
      initialRoute: Routes.SPLASH,
      routes: appRoutes(),
    );
  }
}
