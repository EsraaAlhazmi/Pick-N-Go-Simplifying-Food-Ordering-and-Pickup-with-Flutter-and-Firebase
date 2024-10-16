import 'package:flutter/material.dart';

import '../services/provider_food_service.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () async {
                ProviderFoodService().signOut();
                await Navigator.pushReplacementNamed(context, "login");
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
        child: Text("profile customer"),
      ),
    );
  }
}
