import 'package:fcm/app/ui/pages/login/login_controller.dart';
import 'package:fcm/app/ui/routes/routes.dart';
import 'package:fcm/app/ui/utils/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = LoginController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoTextField(
                placeholder: "email",
                onChanged: _controller.onEmailChanged,
              ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton(
                onPressed: _submit,
                color: Colors.blue,
                child: Text("SEND"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    ProgressDialog.show(context);
    final isOk = await _controller.submit();
    Navigator.pop(context);
    if (isOk) {
      Navigator.pushReplacementNamed(context, Routes.HOME);
    }
  }
}
