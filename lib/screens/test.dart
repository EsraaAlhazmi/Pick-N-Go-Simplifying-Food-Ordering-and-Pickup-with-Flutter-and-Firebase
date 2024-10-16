import 'package:flutter/material.dart';
import 'package:pickapp/services/item_service.dart';

import '../models/item.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  void job() async {
    await ItemService().addItem(Item(
        name: "test", price: 100, providerID: 'YPwuK2pQ3KUmOYXgwWgsZOJmFMx1'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: ElevatedButton(
                  onPressed: job, child: const Text("Take Photo"))),
        ],
      ),
    );
  }
}
