import 'package:flutter/material.dart';
import 'package:pickapp/components/customer_app_bar.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomerAppBar(
        title: 'My Orders',
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                itemBuilder: ((context, index) {
                  return Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 10),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.timer,
                          ),
                          const Text("Date:1/1/2022 1:15 Am"),
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, "myOrdersDetail"),
                                child: const Text(
                                  style: TextStyle(color: Colors.white),
                                  "Details",
                                ),
                              ))
                        ],
                      ));
                }),
                itemCount: 5,
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
