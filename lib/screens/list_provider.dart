import 'package:flutter/material.dart';
import 'package:pickapp/components/customer_app_bar.dart';
import 'package:pickapp/components/customer_sidebar.dart';
import 'package:pickapp/constants/table.dart';
import 'package:pickapp/screens/list_items_of_provider.dart';
import 'package:pickapp/services/provider_food_service.dart';

class ListProverPage extends StatefulWidget {
  const ListProverPage({super.key});

  @override
  State<ListProverPage> createState() => _ListProverPageState();
}

class _ListProverPageState extends State<ListProverPage> {
  List providers = [];
  fetchData() async {
    var result = await ProviderFoodService().getAllProvider();
    setState(() {
      providers = result;
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
        drawer: const CustomerSideBar(),
        appBar: const CustomerAppBar(title: "List Providers"),
        body: ListView(
          children: [
            Image.asset('images/resturant.jpg'),
            GridView.builder(
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  crossAxisCount: 2,
                  childAspectRatio: .7),
              itemCount: providers.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListItemsOfProviderPage(
                              providerId:
                                  providers[index][kColumnUserId].toString()))),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        providers[index][kColumnUserPhoto] == null
                            ? Image.asset(
                                "images/provider.jpg",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                providers[index][kColumnUserPhoto],
                                fit: BoxFit.cover,
                              ),
                        const SizedBox(height: 10),
                        Text(
                          providers[index][kColumnUserName],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
