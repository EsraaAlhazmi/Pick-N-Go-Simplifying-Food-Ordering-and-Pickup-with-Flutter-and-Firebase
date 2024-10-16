// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pickapp/services/order_service.dart';

import '../components/customer_app_bar.dart';

class MyOrderHistoryDetails extends StatefulWidget {
  String? orderId;

  MyOrderHistoryDetails({
    Key? key,
    this.orderId,
  }) : super(key: key);
  @override
  State<MyOrderHistoryDetails> createState() => _MyOrderHistoryDetailsState();
}

class _MyOrderHistoryDetailsState extends State<MyOrderHistoryDetails> {
  List myOrderDetail = [];
  getOrderDetail() async {
    var result = await OrderService().getMyOrderHistoryDetails(widget.orderId);
    setState(() {
      myOrderDetail = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomerAppBar(
        title: 'History Details',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 00,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [],
            ),
          ),
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                itemBuilder: ((context, index) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: myOrderDetail[0]['photo'] == null
                                  ? Image.asset(
                                      "images/provider.jpg",
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      myOrderDetail[index]['photo'],
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 70),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${myOrderDetail[index]['name']}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                    "Unit Price: ${myOrderDetail[index]['unitPrice']}"),
                                const SizedBox(height: 10),
                                Text(
                                    "Quntity: ${myOrderDetail[index]['quantity']}"),
                                const SizedBox(height: 10),
                                Text(
                                    "Total: ${myOrderDetail[index]['quantity'] * myOrderDetail[index]['unitPrice']}"),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                itemCount: myOrderDetail.length,
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
