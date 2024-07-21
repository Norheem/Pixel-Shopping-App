import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  List<Map<String, dynamic>> likedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadLikedProducts();
  }

  Future<void> _loadLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? likedProductsList =
        prefs.getStringList('likedProducts');
    if (likedProductsList != null) {
      likedProducts = likedProductsList
          .map((product) => json.decode(product) as Map<String, dynamic>)
          .toList();
      setState(() {});
    }
  }

  Future<void> _saveLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> likedProductsList =
        likedProducts.map((product) => json.encode(product)).toList();
    await prefs.setStringList('likedProducts', likedProductsList);
  }

  void _removeProduct(int index) {
    setState(() {
      likedProducts.removeAt(index);
      _saveLikedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
      ),
      body: likedProducts.isEmpty
          ? const Center(child: Text('No favorite products'))
          : ListView.builder(
              itemCount: likedProducts.length,
              itemBuilder: (context, index) {
                final product = likedProducts[index];
                return Dismissible(
                  key: Key(product['id'].toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    _removeProduct(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content:
                            Text('${product['name']} removed from wishlist'),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: 'https://api.timbu.cloud/images/' +
                            product['photos'][0]['url'],
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      title: Center(
                        child: Text(
                          product['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('₦${product['current_price'][0]['NGN'][0]}0'),
                          const SizedBox(
                              height:
                                  4.0), // Spacing between price and description
                          Text(
                            product['description'],
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
