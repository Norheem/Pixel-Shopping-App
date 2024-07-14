import 'package:flutter/material.dart';

class Liked extends StatefulWidget {
  const Liked({Key? key}) : super(key: key);

  @override
  State<Liked> createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  List<Map<String, dynamic>> likedProducts = []; // List to hold liked products

  @override
  Widget build(BuildContext context) {
    likedProducts = ModalRoute.of(context)?.settings.arguments
        as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Items'),
      ),
      body: likedProducts.isEmpty
          ? Center(
              child: Text('No items liked yet.'),
            )
          : ListView.builder(
              itemCount: likedProducts.length,
              itemBuilder: (context, index) {
                final product = likedProducts[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('Price: ${product['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite),
                    color: Colors.red,
                    onPressed: () {},
                  ),
                );
              },
            ),
    );
  }
}
