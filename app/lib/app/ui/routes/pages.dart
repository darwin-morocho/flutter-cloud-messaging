import 'package:fcm/app/ui/pages/chat/chat_page.dart';
import 'package:fcm/app/ui/pages/home/home_page.dart';
import 'package:fcm/app/ui/pages/login/login_page.dart';
import 'package:fcm/app/ui/pages/promo/promo_page.dart';
import 'package:fcm/app/ui/pages/splash/splash_page.dart';
import 'package:fcm/app/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show Widget, BuildContext;

Map<String, Widget Function(BuildContext)> appRoutes() => {
      Routes.SPLASH: (_) => SplashPage(),
      Routes.HOME: (_) => HomePage(),
      Routes.LOGIN: (_) => LoginPage(),
      Routes.CHAT: (_) => ChatPage(
            chatId: ModalRoute.of(_)!.settings.arguments as int,
          ),
      Routes.PROMO: (_) => PromoPage(
            productId: ModalRoute.of(_)!.settings.arguments as int,
          ),
    };
