import 'dart:async';

import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:fcm/app/domain/repositories/local_notifications_repository.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:fcm/app/ui/routes/pages.dart';
import 'package:fcm/app/ui/routes/routes.dart';
import 'package:fcm/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  injectDependencies();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _chatSubscription;
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final localNotifications = GetIt.I.get<LocalNotificationsRepository>();
    final pushNotifications = GetIt.I.get<PushNotificationsRepository>();
    localNotifications.initialize();
    await pushNotifications.requestPermission();
    pushNotifications.subscribeToTopic('promos');
    final chatStream = pushNotifications.onNotification.where(
      (e) => e.type == AppNotificationTypes.CHAT,
    );
    _chatSubscription = chatStream.listen((notification) {
      final context = _navigatorKey.currentState!.context;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(notification.title),
          content: Text(notification.body),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.CHAT,
                  arguments: notification.content['chatId'],
                );
              },
              child: Text("Go to chat"),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _chatSubscription.cancel();
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
