import 'package:flutter/material.dart';
import 'package:pickapp/components/customer_app_bar.dart';
import 'package:pickapp/components/customer_sidebar.dart';
import 'package:pickapp/components/primary_button.dart';
import 'package:pickapp/components/text_form_field_border.dart';
import 'package:pickapp/constants/color.dart';
import 'package:pickapp/services/order_service.dart';

import '../services/cart_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final expredate = TextEditingController();

  payment() async {
    await OrderService().addOrder();
    Cart().deleteCart();
    Navigator.pushReplacementNamed(context, "SuccessPayment");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomerSideBar(),
      appBar: const CustomerAppBar(title: "Checkout"),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 150,
            width: double.infinity,
            child: Image.asset('images/credit.png'),
          ),
          TextFormFildeBorder(
            label: const Text("Name on Card"),
            validator: (value) {
              if (value!.length < 10) return "Name must be As Credit Card";
              return null;
            },
            prefixIcon: const Icon(Icons.person),
          ),
          TextFormFildeBorder(
            label: const Text("Card Number"),
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.credit_card),
            validator: (value) {
              if (value!.length < 16) return "Crdit number must be 16 digit";
              return null;
            },
          ),
          TextFormFildeBorder(
            label: const Text("Expire Date"),
            controller: expredate,
            onTap: () {
              showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2050),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: kPrimaryColor, // header background color
                          onPrimary: Colors
                              .white, // header text color // body text color
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: kPrimaryColor, // button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  }).then((value) {
                setState(() {
                  expredate.text = value != null
                      ? "${value.day} / ${value.month} / ${value.year}"
                      : "";
                });
              });
            },
            prefixIcon: const Icon(Icons.date_range),
          ),
          const TextFormFildeBorder(
            maxLength: 3,
            label: Text("Security Code:CVC"),
            prefixIcon: Icon(Icons.lock),
          ),
          PrimaryButton(
              onPressed: () {
                payment();
              },
              child: const Text("Payment"))
        ]),
      ),
    );
  }
}
