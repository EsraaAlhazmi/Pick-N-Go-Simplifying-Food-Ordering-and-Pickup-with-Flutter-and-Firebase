import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickapp/services/auth_service.dart';
import 'package:pickapp/services/cart_service.dart';

class OrderService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  addOrder() async {
    var response = await Cart().getDataGroupByProvider();
    for (var row in response) {
      var documentRef = firebaseFirestore.collection("Orders").doc();
      documentRef.set({
        "orderId": documentRef.id,
        "orderDate": DateTime.now(),
        "providerId": row['providerId'],
        "customerId": AuthService().getCurrentUser()!.uid,
        "orderStatus": "Wait"
      });

      List response2 = await Cart().getCartByProviderId(row['providerId']);
      for (var element in response2) {
        var documentRef2 = firebaseFirestore.collection("OrderDetails").doc();
        documentRef2.set({
          "orderDetailId": documentRef2.id,
          "orderId": documentRef.id,
          "itemId": element['itemId'],
          "name": element['name'],
          "photo": element['photo'],
          "quantity": element['quantity'],
          "unitPrice": element['unitPrice']
        });
      }
    }
  }

  getMyOrders() async {
    var myId = AuthService().getCurrentUser()!.uid;
    List myOrders = [];
    await firebaseFirestore
        .collection('Orders')
        .where('customerId', isEqualTo: myId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        myOrders.add(element);
      }
    });
    return myOrders;
  }

  getMyOrderDetails(String? orderId) async {
    List myOrdersDetails = [];
    await firebaseFirestore
        .collection('OrderDetails')
        .where('orderId', isEqualTo: orderId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        myOrdersDetails.add(element);
      }
    });
    return myOrdersDetails;
  }
}
