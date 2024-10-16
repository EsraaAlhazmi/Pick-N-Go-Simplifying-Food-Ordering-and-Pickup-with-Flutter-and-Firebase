import 'package:flutter/material.dart';
import 'package:pickapp/constants/color.dart';
import 'package:pickapp/constants/table.dart';
import 'package:pickapp/services/cart_service.dart';

import '../components/customer_app_bar.dart';
import '../services/item_service.dart';

class ListItemsOfProviderPage extends StatefulWidget {
  const ListItemsOfProviderPage({
    Key? key,
    this.providerId,
  }) : super(key: key);
  final String? providerId;

  @override
  State<ListItemsOfProviderPage> createState() =>
      _ListItemsOfProviderPageState();
}

class _ListItemsOfProviderPageState extends State<ListItemsOfProviderPage> {
  List items = [];
  fetchData() async {
    var result = await ItemService().displayItems(widget.providerId.toString());
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
      appBar: const CustomerAppBar(
        title: 'Our Product',
      ),
      body: Column(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                crossAxisCount: 2,
                childAspectRatio: .54),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.orange,
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
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      child: Text(
                        items[index][kColumnPrice].toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        Cart cart = Cart();

                        var result = await cart.addToCart(
                            items[index][kColumnItemId],
                            1,
                            items[index][kColumnPrice]);

                        //await cart.deleteCart();
                        // bool test =
                        //     await cart.checkInCart(items[index][kColumnItemId]);
                        // if (test == false) {
                        //   var result = await cart.addToCart(
                        //       items[index][kColumnItemId],
                        //       1,
                        //       items[index][kColumnPrice]);
                        //   if (result > 0) {
                        //     print("total:${cart.totalCart}");
                        //   }
                        // }
                      },
                      child: Container(
                        color: kPrimaryColor,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                            ),
                            Text(
                              "Add To Cart",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
