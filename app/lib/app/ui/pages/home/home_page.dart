import 'dart:async';

import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:fcm/app/ui/pages/home/home_cotroller.dart';
import 'package:fcm/app/ui/routes/routes.dart';
import 'package:fcm/app/ui/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

  @override
  void dispose() {
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
      body: Center(
        child: Text("HOME"),
      ),
    );
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
