import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pixel_shopping_app/models/cart_model.dart';

class CheckoutForm extends StatefulWidget {
  final List<CartItem> cartItems;
  final ValueChanged<List<CartItem>> onCartUpdate;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const CheckoutForm({
    super.key,
    required this.cartItems,
    required this.onCartUpdate,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  State<CheckoutForm> createState() => CheckoutFormState();
}

class CheckoutFormState extends State<CheckoutForm> {
  int? mm;
  int? year;
  void openExpiryDate() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 150,
                            child: CupertinoPicker.builder(
                              itemExtent: 40,
                              onSelectedItemChanged: (index) {
                                mm = index + 1;
                                setState(() {});
                              },
                              selectionOverlay: Container(
                                width: double.maxFinite,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1),
                                  ),
                                ),
                              ),
                              childCount: 12,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 150,
                            child: CupertinoPicker.builder(
                              itemExtent: 40,
                              onSelectedItemChanged: (index) {
                                year = index + 2024;
                                setState(() {});
                              },
                              selectionOverlay: Container(
                                width: double.maxFinite,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1),
                                  ),
                                ),
                              ),
                              childCount: 20,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${index + 2024}',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                mm = null;
                                year = null;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 1, 107, 3),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 107, 3),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              width: 90,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 1, 107, 3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Center(
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressController2 = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameOnCardController = TextEditingController();
  final TextEditingController _numberOnCardController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }

  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  String? validateLocation() {
    if (selectedCountry == null ||
        selectedState == null ||
        selectedCity == null) {
      return 'Please select your country, state, and city';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Delivery Options',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 60,
              width: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(43, 158, 158, 158),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      height: 50,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Text(
                          'Delivery',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Pickup',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'First Name*',
                        style: TextStyle(
                          color: Color.fromARGB(166, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: widget.firstNameController,
                    decoration: const InputDecoration(
                      hintText: 'First Name*',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(129, 158, 158, 158),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (name) => name!.length < 3
                        ? 'First Name should be at least 3 characters'
                        : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Last Name*',
                        style: TextStyle(
                          color: Color.fromARGB(166, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: widget.lastNameController,
                    decoration: const InputDecoration(
                      hintText: 'Last Name*',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(129, 158, 158, 158),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (name) => name!.length < 3
                        ? 'Last Name should be at least 3 characters'
                        : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Email*',
                        style: TextStyle(
                          color: Color.fromARGB(166, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email*',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(129, 158, 158, 158),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Phone Number*',
                        style: TextStyle(
                          color: Color.fromARGB(166, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  IntlPhoneField(
                    controller: _phoneNumberController,
                    flagsButtonPadding: const EdgeInsets.all(4),
                    dropdownIconPosition: IconPosition.trailing,
                    decoration: const InputDecoration(
                      labelText: '+234',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    initialCountryCode: 'NG',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                    validator: (phone) {
                      if (phone == null || phone.completeNumber.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Address 1*',
                        style: TextStyle(
                          color: Color.fromARGB(166, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      hintText: 'Address 1*',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(129, 158, 158, 158),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (name) => name!.length < 5
                        ? 'Address should be at least 5 characters'
                        : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Address 2',
                        style: TextStyle(
                          color: Color.fromARGB(166, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _addressController2,
                    decoration: const InputDecoration(
                      hintText: 'Address 2',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(129, 158, 158, 158),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Country*',
                        style: TextStyle(
                          color: Color.fromARGB(166, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'State*',
                        style: TextStyle(
                          color: Color.fromARGB(166, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CSCPicker(
                    onCountryChanged: (country) {
                      setState(() {
                        selectedCountry = country;
                      });
                    },
                    onStateChanged: (state) {
                      setState(() {
                        selectedState = state;
                      });
                    },
                    onCityChanged: (city) {
                      setState(() {
                        selectedCity = city;
                      });
                    },
                    countryDropdownLabel: 'Country',
                    stateDropdownLabel: 'State*',
                    cityDropdownLabel: 'City*',
                    layout: Layout.horizontal,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Builder(
                      builder: (context) {
                        return Text(
                          validateLocation() ?? '',
                          style: TextStyle(
                            color: validateLocation() != null
                                ? Colors.red
                                : Colors.transparent,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Post Code*',
                        style: TextStyle(
                          color: Color.fromARGB(166, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _postCodeController,
                    decoration: const InputDecoration(
                      hintText: 'Post Code*',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(129, 158, 158, 158),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (name) => name!.length != 4
                        ? 'Post Code should be 4 digits'
                        : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Payment Options',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(43, 158, 158, 158),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            height: 50,
                            width: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: Text(
                                'Card',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Bank Transfer',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Name on Card*',
                        style: TextStyle(
                          color: Color.fromARGB(166, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _nameOnCardController,
                    decoration: const InputDecoration(
                      hintText: 'Name on Card*',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(129, 158, 158, 158),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (name) => name!.length < 5
                        ? 'Name on Card should be at least 5 characters'
                        : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Number on Card*',
                        style: TextStyle(
                          color: Color.fromARGB(166, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      TextFormField(
                        controller: _numberOnCardController,
                        decoration: const InputDecoration(
                          hintText: '1234 1234 1234 1234',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(129, 158, 158, 158),
                          ),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 50),
                        ),
                        validator: (number) => number!.length != 16
                            ? 'Number on Card should be 16 digits'
                            : null,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(13),
                            child: Image.asset(
                              'assets/masterlogo.png',
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Expire Date*',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: openExpiryDate,
                            child: Container(
                              width: 160,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(244, 158, 158, 158),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${mm?.toString().padLeft(2, '0') ?? 'MM'} / ${year ?? 'YYYY'}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CVV*',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 160,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(244, 158, 158, 158),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  hintText: '000*',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                  border: InputBorder.none,
                                ),
                                controller: _cvvController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This field is required';
                                  } else if (value.length != 3) {
                                    return 'CVV must be exactly 3 digits';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Items'),
                            Text('${widget.cartItems.length}'),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery'),
                            Text('₦5,000'),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Services'),
                            Text('₦3,500'),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          width: 370,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(136, 158, 158, 158),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Do you have a Coupon Code?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 210,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              244, 158, 158, 158),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextFormField(
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          decoration: const InputDecoration(
                                            hintText: 'Enter Coupon Code',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 1, 107, 3),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Apply',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 1, 107, 3),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
