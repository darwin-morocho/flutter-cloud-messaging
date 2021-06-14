import 'package:flutter/material.dart';

class PromoPage extends StatelessWidget {
  final int productId;
  const PromoPage({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Promo $productId"),
      ),
    );
  }
}
