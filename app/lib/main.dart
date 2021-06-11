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
  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    final pushNotifications = GetIt.I.get<PushNotificationsRepository>();
    await pushNotifications.requestPermission();
    pushNotifications.subscribeToTopic('promos');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.SPLASH,
      routes: appRoutes(),
    );
  }
}
