import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:pixel_shopping_app/models/cart_model.dart';
import 'package:pixel_shopping_app/screen/checkout_form.dart';
import 'package:pixel_shopping_app/screen/home.dart';

class Checkout extends StatefulWidget {
  final List<CartItem> cartItems;
  final ValueChanged<List<CartItem>> onCartUpdate;
  final Function(List<CartItem>) updateCart;
  final Function(List<Map<String, dynamic>>) addOrder;

  const Checkout({
    Key? key,
    required this.cartItems,
    required this.onCartUpdate,
    required this.updateCart,
    required this.addOrder,
  }) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final GlobalKey<CheckoutFormState> _formKey = GlobalKey<CheckoutFormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  List<Map<String, dynamic>> updatedOrdersList = [];

  double get totalMoney =>
      widget.cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  String _generateOrderId() {
    final random = Random();
    return 'ORD${random.nextInt(100000)}';
  }

  void handleCheckout() {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }

    if (_formKey.currentState?.validateForm() ?? false) {
      final orderId = _generateOrderId();
      final buyerName =
          '${_firstNameController.text} ${_lastNameController.text}';
      final orderDetails = {
        'id': orderId,
        'buyerName': buyerName,
        'items': widget.cartItems.map((item) {
          return {
            'name': item.name,
            'price': item.price,
            'quantity': item.quantity,
            'imageUrl': item.imageUrl,
          };
        }).toList(),
      };

      widget.addOrder([orderDetails]);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/checkout.png',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              const Text(
                'Payment Successful',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Your order is being processed and you will receive an email with details.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: GestureDetector(
                onTap: () {
                  widget.updateCart([]);
                  widget.onCartUpdate([]);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                    (route) => false,
                  );
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 1, 107, 3),
                  ),
                  child: const Center(
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      print('Form is not valid.');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...widget.cartItems.map((cartItem) => ListTile(
                leading: Container(
                  width: 60,
                  height: 60,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(cartItem.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(cartItem.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\₦${cartItem.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 1, 107, 3),
                          ),
                        ),
                        Text('X ${cartItem.quantity}'),
                      ],
                    ),
                  ],
                ),
              )),
          CheckoutForm(
            key: _formKey,
            cartItems: widget.cartItems,
            onCartUpdate: widget.updateCart,
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    'Sub Total ',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '\₦${totalMoney.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 1, 107, 3),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: handleCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 107, 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Make Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
