import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/components/customer_app_bar.dart';
import 'package:pickapp/constants/color.dart';
import 'package:pickapp/screens/myorder_history_detail.dart';
import 'package:pickapp/services/order_service.dart';

import '../components/customer_sidebar.dart';

class MyOrdersHistory extends StatefulWidget {
  const MyOrdersHistory({super.key});

  @override
  State<MyOrdersHistory> createState() => _MyOrdersHistoryState();
}

class _MyOrdersHistoryState extends State<MyOrdersHistory> {
  List myOrders = [];
  getMyOrder() async {
    var result = await OrderService().getMyOrdersHistory();
    setState(() {
      myOrders = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomerSideBar(),
      appBar: const CustomerAppBar(
        title: 'Orders History',
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            myOrders[index]['orderStatus'] == 'Wait'
                                ? Icons.timer
                                : myOrders[index]['orderStatus'] == "In Process"
                                    ? Icons.settings
                                    : myOrders[index]['orderStatus'] == "Ready"
                                        ? Icons.done
                                        : Icons.done_all,
                            color: kPrimaryColor,
                          ),
                          Text(DateFormat.yMMMEd().add_jm().format(
                              DateTime.parse(myOrders[index]["orderDate"]
                                  .toDate()
                                  .toString()))),
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MyOrderHistoryDetails(
                                      orderId: myOrders[index]['orderId'],
                                    );
                                  }));
                                },
                                child: const Text(
                                  style: TextStyle(color: Colors.white),
                                  "Details",
                                ),
                              ))
                        ],
                      ));
                }),
                itemCount: myOrders.length,
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
