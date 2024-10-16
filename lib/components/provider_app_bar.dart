import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/cutomer_service.dart';

class ProviderAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;

  const ProviderAppBar({super.key, required this.title});

  @override
  State<ProviderAppBar> createState() => _ProviderAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}

class _ProviderAppBarState extends State<ProviderAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  // TODO: implement preferredSize

  @override
  Widget build(BuildContext context) {
    return AppBar(centerTitle: true, title: Text(widget.title!), actions: [
      IconButton(
        onPressed: () async {
          await Navigator.pushReplacementNamed(context, "addItem");
        },
        icon: const Icon(Icons.add),
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
}
