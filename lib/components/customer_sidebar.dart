import 'package:flutter/material.dart';
import 'package:pickapp/constants/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerSideBar extends StatefulWidget {
  const CustomerSideBar({super.key});

  @override
  State<CustomerSideBar> createState() => _CustomerSideBarState();
}

class _CustomerSideBarState extends State<CustomerSideBar> {
  String? email;
  String? fullname;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          getSahredRefrence();
        }));
  }

  void getSahredRefrence() async {
    final sharedPref = await SharedPreferences.getInstance();
    fullname = sharedPref.getString("fullanme");
    email = sharedPref.getString("email");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: kPrimaryColor),
            accountName: Text(
              fullname ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.amber[700],
              child: const Icon(
                Icons.person_2_outlined,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.double_arrow_outlined),
            title: const Text("Provider"),
            onTap: () => Scaffold.of(context).closeDrawer(),
          ),
          ListTile(
            leading: const Icon(Icons.double_arrow_outlined),
            title: const Text("Orders"),
            onTap: () => Navigator.pushNamed(context, "myOrders"),
          ),
        ],
      ),
    );
  }
}
