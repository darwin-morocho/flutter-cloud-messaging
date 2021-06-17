import 'dart:async';

import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:fcm/app/ui/pages/home/home_cotroller.dart';
import 'package:fcm/app/ui/routes/routes.dart';
import 'package:fcm/app/ui/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription? _subscription;
  final _controller = HomeController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _init();
    });
  }

  void _init() async {
    _controller.addListener(_rebuild);
    _subscription = _controller.onPromos.listen(
      (notification) {
        final productId = notification.content['productId'] as int;
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
                    Routes.PROMO,
                    arguments: productId,
                  );
                },
                child: Text("Go now"),
              )
            ],
          ),
        );
      },
    );
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _logOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _controller.init,
        child: ListView.builder(
          itemBuilder: (_, index) {
            final notification = _controller.notifications[index];
            return ListTile(
              leading: SizedBox(
                width: 20,
                child: Center(
                  child: Icon(
                    Icons.circle,
                    size: 10,
                    color: notification.viewed ? Colors.grey : Colors.blue,
                  ),
                ),
              ),
              title: Row(
                children: [
                  Expanded(child: Text(notification.title)),
                  Text(
                    timeago.format(notification.createdAt, locale: 'es'),
                    style: TextStyle(fontSize: 13),
                  )
                ],
              ),
              subtitle: Text(notification.body),
              onTap: () => _onNotificationClick(notification),
            );
          },
          itemCount: _controller.notifications.length,
        ),
      ),
    );
  }

  void _onNotificationClick(AppNotification notification) {
    _controller.markAsViewed(notification.id!);
    switch (notification.type) {
      case AppNotificationTypes.CHAT:
        Navigator.pushNamed(
          context,
          Routes.CHAT,
          arguments: notification.content['chatId'],
        );
        break;
      // case AppNotificationTypes.PROMO:
      //   Navigator.pushNamed(
      //     context,
      //     Routes.PROMO,
      //     arguments: notification.content['productId'],
      //   );
      //   break;
    }
  }

  Future<void> _logOut() async {
    ProgressDialog.show(context);
    final isOk = await _controller.logOut();
    Navigator.pop(context);
    if (isOk) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.LOGIN, (_) => false);
    }
  }
}
