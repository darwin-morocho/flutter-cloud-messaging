import 'dart:async';

import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pushNotificationsRepository = GetIt.I.get<PushNotificationsRepository>();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _init();
    });
  }

  void _init() async {
    _subscription = _pushNotificationsRepository.onNotification
        .where(
      (e) => e.type == AppNotificationTypes.PROMO,
    )
        .listen(
      (notification) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(notification.title),
            content: Text(notification.body),
          ),
        );
      },
    );

    final initialNotification = await _pushNotificationsRepository.initialNotification;
    if (initialNotification != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Initial Notificcation ${initialNotification.title}"),
          content: Text(initialNotification.content.toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("HOME"),
      ),
    );
  }
}
