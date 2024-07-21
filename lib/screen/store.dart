import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_shopping_app/models/cart_model.dart';
import 'package:pixel_shopping_app/screen/order_history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pixel_shopping_app/screen/cart.dart';
import 'dart:convert';
import 'dart:async';
import 'package:pixel_shopping_app/screen/categories.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final TextEditingController searchController = TextEditingController();
  List products = [];
  List<CartItem> cartItems = [];
  List likedProducts = [];

  final String apiUrl =
      'https://api.timbu.cloud/products?organization_id=b755473cb3a44caaae6ecdbf728525a0&reverse_sort=false&page=1&size=25&Appid=APG6NEW601TH1S1&Apikey=82eaf351ef7d4179a7bc8883ad3532b920240705073315617101';
  final String imageUrl = 'https://api.timbu.cloud/images/';

  bool isLoading = true;
  List filteredProducts = [];
  String showRandomImageUrl = '';

  Timer? _timer;

  Color favoriteColor = Colors.white;
  Color shoppingCartColor = Colors.white;

  List<Map<String, dynamic>> updatedOrdersList = [];

  void handleAddOrder(List<Map<String, dynamic>> orders) async {
    print('Handling orders: $orders');
    setState(() {
      updatedOrdersList.addAll(orders);
      print('Updated orders list: $updatedOrdersList');
    });

    final prefs = await SharedPreferences.getInstance();
    final ordersJson = jsonEncode(updatedOrdersList);
    await prefs.setString('orders', ordersJson);
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _loadCartItems();
    _loadLikedProducts();
    searchController.addListener(_onSearchChanged);
    _ImageTimer();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          products = data['items'] ?? [];
          products.forEach((product) {
            product['isFavorite'] = false;
            product['isInCart'] = false;
          });
          filteredProducts = products;
          isLoading = false;
        });
      } else {
        print('Failed to load products: ${response.statusCode}');
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException catch (e) {
      print('Network error: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  List filterProductsByCategory(String categoryName) {
    return filteredProducts.where((product) {
      return product['categories']
          .any((category) => category['name'] == categoryName);
    }).toList();
  }

  void _ImageTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        if (products.isNotEmpty) {
          final randomProduct = (products..shuffle()).first;
          showRandomImageUrl = imageUrl + randomProduct['photos'][0]['url'];
        }
      });
    });
  }

  void _onSearchChanged() {
    setState(() {
      filteredProducts = products
          .where((product) => product['name']
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
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
  }

  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedCartData = json.encode(cartItems);
    await prefs.setString('cartItems', encodedCartData);
  }

  void updateCart(List<CartItem> updatedCartItems) {
    setState(() {
      cartItems = updatedCartItems;
    });
    _saveCartItems();
  }

  void addToCart(CartItem cartItem) {
    bool alreadyInCart = cartItems.any((item) => item.name == cartItem.name);

    if (alreadyInCart) {
      _showSnackbar('${cartItem.name} is already in the cart',
          color: Colors.red);
    } else {
      setState(() {
        cartItems.add(cartItem);

        final productIndex =
            products.indexWhere((product) => product['name'] == cartItem.name);
        if (productIndex != -1) {
          products[productIndex]['isInCart'] = true;
        }
      });
      _showSnackbar('${cartItem.name} added to cart', color: Colors.green);
    }
    _saveCartItems();
  }

  void toggleLikedProduct(Map product) async {
    if (likedProducts.contains(product)) {
      _showSnackbar('${product['name']} is already in the wishlist',
          color: Colors.red);
    } else {
      setState(() {
        likedProducts.add(product);
        product['isFavorite'] = true;
        _showSnackbar('${product['name']} added to wishlist',
            color: Colors.green);
        _saveLikedProducts();
      });
    }
  }

  Future<void> _saveLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> likedProductsList =
        likedProducts.map((product) => json.encode(product)).toList();
    await prefs.setStringList('likedProducts', likedProductsList);
  }

  Future<void> _loadLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? likedProductsList =
        prefs.getStringList('likedProducts');
    if (likedProductsList != null) {
      likedProducts =
          likedProductsList.map((product) => json.decode(product)).toList();
      setState(() {});
    }
  }

  void _showSnackbar(String message, {Color color = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List newArrivals = filterProductsByCategory('new arrivals');
    List topSellers = filterProductsByCategory('top sellers');
    List moreLikes = filterProductsByCategory('more');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(148, 228, 228, 228),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: searchController,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search for anything  ',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 15,
                            ),
                            suffixIcon: const Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 30,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.notifications_none,
                    ),
                    GestureDetector(
                      onTap: () {
                        print(
                            'Navigating to OrderHistory with orders: $updatedOrdersList');
                        Future.delayed(Duration(milliseconds: 100), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderHistory(
                                orders: List.from(updatedOrdersList),
                              ),
                            ),
                          );
                        });
                      },
                      child: const Icon(
                        Icons.history_sharp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Cart(
                              cartItems: cartItems,
                              updateCart: updateCart,
                              addOrder: handleAddOrder,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(255, 1, 107, 3),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          if (cartItems.isNotEmpty)
                            Positioned(
                              right: 0,
                              bottom: 16,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 15,
                                  minHeight: 15,
                                ),
                                child: Text(
                                  '${cartItems.length}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/home.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildCategorySection(
                    context, 'New Arrivals', newArrivals, () {}, isLoading),
                const SizedBox(height: 20),
                _buildCategorySection(
                    context, 'Top Sellers', topSellers, () {}, isLoading),
                const SizedBox(height: 20),
                _buildCategorySection(context, 'More of what you like',
                    moreLikes, () {}, isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String title,
      List products, VoidCallback seeMoreCallback, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Categories(
                      category: title,
                      products: products,
                    ),
                  ),
                );
              },
              child: const Text(
                'See more',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final priceList = product['current_price'];
                    final price = priceList[0]['NGN'][0];

                    return Column(
                      children: [
                        Container(
                          height: 150,
                          width: 130,
                          margin: const EdgeInsets.only(right: 10),
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
                                          ? Icons.favorite_border
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
                                          ? Icons.shopping_cart_outlined
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
              ),
      ],
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
