import 'package:flutter/material.dart';

import '../components/customer_app_bar.dart';

class MyOrderDetails extends StatefulWidget {
  const MyOrderDetails({super.key});

  @override
  State<MyOrderDetails> createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomerAppBar(
        title: 'My Orders Details',
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset("images/provider.jpg"),
                            ),
                            const SizedBox(width: 70),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Product Name Product ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text("Unit Price: 12"),
                                SizedBox(height: 10),
                                Text("Quntity: 12"),
                                SizedBox(height: 10),
                                Text("Total: 12"),
                                SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
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
