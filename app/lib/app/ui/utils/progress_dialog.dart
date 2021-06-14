import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressDialog {
  static void show(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => WillPopScope(
        child: Container(
          color: Colors.white54,
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: CupertinoActivityIndicator(),
        ),
        onWillPop: () async => false,
      ),
    );
  }
}
