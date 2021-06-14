import 'package:fcm/app/ui/pages/splash/splash_controller.dart';
import 'package:fcm/app/ui/routes/routes.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _controller = SplashController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _init();
    });
  }

  void _init() async {
    _controller.init();
    _controller.addListener(() {
      if (_controller.routeName != null) {
        Navigator.pushReplacementNamed(
          context,
          _controller.routeName!,
          arguments: _controller.pageArguments,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
