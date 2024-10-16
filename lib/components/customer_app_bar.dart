import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/cart_service.dart';
import '../services/cutomer_service.dart';

class CustomerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const CustomerAppBar({super.key, required this.title});

  @override
  // TODO: implement preferredSize

  @override
  Widget build(BuildContext context) {
    return AppBar(centerTitle: true, title: Text(title!), actions: [
      GestureDetector(
        onTap: () => Navigator.pushNamed(context, "cart"),
        child: Consumer<Cart>(builder: (context, model, child) {
          return Container(
              margin: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                textBaseline: TextBaseline.ideographic,
                children: [
                  const Icon(Icons.shopping_bag),
                  const SizedBox(width: 10),
                  Text(
                    "${model.total}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ));
        }),
      ),
      IconButton(
        onPressed: () async {
          CustomerService().signOut();
          final sharedPref = await SharedPreferences.getInstance();
          sharedPref.remove('fullname');
          sharedPref.remove('email');
          Navigator.pushReplacementNamed(context, "login");
        },
        icon: const Icon(Icons.logout),
      ),
    ]);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}
