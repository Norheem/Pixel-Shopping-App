import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixel_shopping_app/models/cart_provider.dart';

import 'package:pixel_shopping_app/screen/home.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: const MaterialApp(
      home: Home(),
    ),
  ));
}
