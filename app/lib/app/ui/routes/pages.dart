import 'package:fcm/app/ui/pages/home/home_page.dart';
import 'package:fcm/app/ui/pages/splash/splash_page.dart';
import 'package:fcm/app/ui/routes/routes.dart';
import 'package:flutter/widgets.dart' show Widget, BuildContext;

Map<String, Widget Function(BuildContext)> appRoutes() => {
      Routes.SPLASH: (_) => SplashPage(),
      Routes.HOME: (_) => HomePage(),
    };
