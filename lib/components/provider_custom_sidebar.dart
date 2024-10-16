import 'package:flutter/material.dart';
import 'package:pickapp/constants/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderSideBar extends StatefulWidget {
  const ProviderSideBar({super.key});

  @override
  State<ProviderSideBar> createState() => _ProviderSideBarState();
}

class _ProviderSideBarState extends State<ProviderSideBar> {
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
              onTap: () =>
                  Navigator.pushReplacementNamed(context, "providerProfile")),
          ListTile(
            leading: const Icon(Icons.double_arrow_outlined),
            title: const Text("Orders"),
            onTap: () => Navigator.pushNamed(context, "order"),
          ),
          ListTile(
            leading: const Icon(Icons.double_arrow_outlined),
            title: const Text("Items"),
            onTap: () => Navigator.pushNamed(context, "listItem"),
          ),
        ],
      ),
    );
  }
}
