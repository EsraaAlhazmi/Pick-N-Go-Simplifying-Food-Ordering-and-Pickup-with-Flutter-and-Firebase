import 'package:flutter/material.dart';
import 'package:pickapp/components/provider_app_bar.dart';
import 'package:pickapp/components/provider_custom_sidebar.dart';
import 'package:pickapp/services/auth_service.dart';

import '../constants/table.dart';
import '../services/item_service.dart';
import 'edit_item.dart';

class ListItemPage extends StatefulWidget {
  const ListItemPage({super.key});

  @override
  State<ListItemPage> createState() => _ListItemPageState();
}

class _ListItemPageState extends State<ListItemPage> {
  List items = [];
  fetchData() async {
    var result =
        await ItemService().displayItems(AuthService().getCurrentUser()!.uid);
    setState(() {
      items = result;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ProviderSideBar(),
      appBar: const ProviderAppBar(title: "List Items"),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            crossAxisCount: 2,
            childAspectRatio: .54),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          String? itemId = items[index][kColumnItemId];
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: items[index][kColumnphoto] == null
                      ? Image.asset(
                          "images/provider.jpg",
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          items[index][kColumnphoto],
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 10),
                Text(
                  items[index][kColumnName],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Text(
                    items[index][kColumnPrice].toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditItemPage(id: itemId))),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                          ),
                          child: const Text(
                            "Edit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ItemService().deleteItem(itemId);
                          Navigator.pushReplacementNamed(context, "listItem");
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                          ),
                          child: const Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
