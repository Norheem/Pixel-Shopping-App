import 'package:flutter/material.dart';
import 'package:pixel_shopping_app/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  set cartItems(List<CartItem> items) {
    _cartItems = items;
    notifyListeners();
  }

  void addItem(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _cartItems.removeWhere((cartItem) => cartItem.name == item.name);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
