import 'package:flutter/material.dart';
import 'package:pixel_shopping_app/screen/account.dart';
import 'package:pixel_shopping_app/screen/liked.dart';
import 'package:pixel_shopping_app/screen/order.dart';
import 'package:pixel_shopping_app/screen/store.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  List<Map<String, dynamic>> cartItems = [];

  List<Map<String, dynamic>> bottomItems = [
    {
      "id": 0,
      "name": "Store",
      "activeImg": Icons.store,
      "inActiveImg": Icons.store_mall_directory_outlined,
    },
    {
      "id": 1,
      "name": "Liked",
      "activeImg": Icons.favorite,
      "inActiveImg": Icons.favorite_border_outlined,
    },
    {
      "id": 2,
      "name": "Orders",
      "activeImg": Icons.note_alt,
      "inActiveImg": Icons.note_alt_outlined,
    },
    {
      "id": 3,
      "name": "Account",
      "activeImg": Icons.person,
      "inActiveImg": Icons.person_2_outlined,
    },
  ];

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });
  }

  void updateCart(List<Map<String, dynamic>> updatedCartItems) {
    setState(() {
      cartItems = updatedCartItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: showTopItem(),
            ),
            showBottomBar(),
          ],
        ),
      ),
    );
  }

  showTopItem() {
    if (selectedIndex == 0) {
      return Store();
    } else if (selectedIndex == 1) {
      return Liked();
    } else if (selectedIndex == 2) {
      return Order();
    } else if (selectedIndex == 3) {
      return Account();
    }
  }

  showBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.lightBlue[50],
        currentIndex: selectedIndex,
        selectedItemColor: Color.fromARGB(255, 1, 107, 3),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          color: const Color.fromARGB(255, 1, 107, 3),
        ),
        unselectedLabelStyle: TextStyle(color: Colors.black),
        items: bottomItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item["inActiveImg"]),
            activeIcon: Icon(item["activeImg"]),
            label: item["name"],
          );
        }).toList(),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
