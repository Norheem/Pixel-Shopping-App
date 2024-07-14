import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:pixel_shopping_app/models/cart_model.dart';
import 'package:pixel_shopping_app/screen/checkout_form.dart';
import 'package:pixel_shopping_app/screen/home.dart';

class Checkout extends StatefulWidget {
  final List<CartItem> cartItems;
  final ValueChanged<List<CartItem>> onCartUpdate;
  final Function(List<CartItem>) updateCart;

  const Checkout({
    Key? key,
    required this.cartItems,
    required this.onCartUpdate,
    required this.updateCart,
  }) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  double get totalMoney =>
      widget.cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  void handleCheckout() {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
    } else {
      const String imageUrl = 'assets/checkout.png';
      const String successMessage = 'Payment Successful';

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                successMessage,
                style: const TextStyle(
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
                  setState(() {
                    widget.cartItems.clear();
                  });
                  widget.onCartUpdate(widget.cartItems);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
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
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
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
          ...widget.cartItems
              .map((cartItem) => ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
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
                  ))
              .toList(),
          CheckoutForm(
            cartItems: widget.cartItems,
            onCartUpdate: widget.updateCart,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
                ],
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: handleCheckout,
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 1, 107, 3),
                  ),
                  child: const Center(
                    child: Text(
                      'Make Payment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
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
