import 'package:flutter/material.dart';
import 'package:pickapp/components/customer_app_bar.dart';
import 'package:pickapp/components/customer_sidebar.dart';

class SuccessPayment extends StatefulWidget {
  const SuccessPayment({super.key});

  @override
  State<SuccessPayment> createState() => _SuccessPaymentState();
}

class _SuccessPaymentState extends State<SuccessPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomerSideBar(),
        appBar: const CustomerAppBar(
          title: "Success Payment",
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50))),
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.done_all_sharp,
                color: Colors.green,
                size: 100,
              ),
              Text(
                "Success Payment",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text("You can traking your orders ")
            ],
          ),
        ));
  }
}
