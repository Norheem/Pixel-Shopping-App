import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pixel_shopping_app/models/cart_model.dart';

class Categories extends StatefulWidget {
  final String category;
  final List products;

  Categories({Key? key, required this.category, required this.products})
      : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final String imageUrl = 'https://api.timbu.cloud/images/';

  late List filteredProducts;
  late List likedProducts;
  List<CartItem> cartItems = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.products;
    likedProducts = [];
    cartItems = [];
    _loadCartItems();
    _loadLikedProducts();
  }

  void filterProducts() {
    setState(() {
      filteredProducts = widget.products.map((product) {
        product['isFavorite'] = likedProducts.contains(product);
        product['isInCart'] =
            cartItems.any((item) => item.name == product['name']);
        return product;
      }).toList();
      isLoading = false;
    });
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cartItems');
    if (cartData != null) {
      final List decodedCartData = json.decode(cartData);
      final List<CartItem> loadedCartItems =
          decodedCartData.map((item) => CartItem.fromJson(item)).toList();
      setState(() {
        cartItems = loadedCartItems;
      });
    }
    filterProducts(); // Ensure products are filtered after loading cart items
  }

  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedCartData =
        json.encode(cartItems.map((item) => item.toJson()).toList());
    await prefs.setString('cartItems', encodedCartData);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void addToCart(CartItem cartItem) {
    bool alreadyInCart = cartItems.any((item) => item.name == cartItem.name);

    if (alreadyInCart) {
      _showSnackBar('${cartItem.name} is already in the cart');
    } else {
      setState(() {
        cartItems.add(cartItem);
      });
      _showSnackBar('${cartItem.name} added to cart');
    }
    _saveCartItems();
  }

  Future<void> _loadLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final likedData = prefs.getString('likedProducts');
    if (likedData != null) {
      final List decodedLikedData = json.decode(likedData);
      setState(() {
        likedProducts = decodedLikedData;
      });
    }
    filterProducts();
  }

  Future<void> _saveLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedLikedData = json.encode(likedProducts);
    await prefs.setString('likedProducts', encodedLikedData);
  }

  void toggleLikedProduct(Map product) {
    setState(() {
      final index = filteredProducts.indexOf(product);
      if (likedProducts.contains(product)) {
        likedProducts.remove(product);
        filteredProducts[index]['isFavorite'] = false;
        _showSnackBar('${product['name']} removed from favorites');
      } else {
        likedProducts.add(product);
        filteredProducts[index]['isFavorite'] = true;
        _showSnackBar('${product['name']} added to favorites');
      }
      _saveLikedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final priceList = product['current_price'];
                final price = priceList[0]['NGN'][0];

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        CartItem cartItem = CartItem(
                          name: product['name'],
                          price: product['current_price'][0]['NGN'][0],
                          quantity: 1,
                          imageUrl: imageUrl + product['photos'][0]['url'],
                        );
                        addToCart(cartItem);
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(41, 158, 158, 158),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              imageUrl + product['photos'][0]['url'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildIconButton(
                                    product['isFavorite']
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    () {
                                      toggleLikedProduct(product);
                                    },
                                    product['isFavorite']
                                        ? Colors.green
                                        : Colors.white,
                                    false,
                                  ),
                                  _buildIconButton(
                                    product['isInCart']
                                        ? Icons.shopping_cart
                                        : Icons.shopping_cart_outlined,
                                    () {
                                      CartItem cartItem = CartItem(
                                        name: product['name'],
                                        price: product['current_price'][0]
                                            ['NGN'][0],
                                        quantity: 1,
                                        imageUrl: imageUrl +
                                            product['photos'][0]['url'],
                                      );
                                      addToCart(cartItem);
                                    },
                                    product['isInCart']
                                        ? Colors.green
                                        : Colors.white,
                                    product['isInCart'],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '\₦${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          product['name'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildIconButton(
      IconData icon, VoidCallback onPressed, Color color, bool isInCart) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 20,
        color: Colors.black,
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
