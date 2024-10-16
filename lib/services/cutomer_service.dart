import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickapp/constants/table.dart';
import 'package:pickapp/services/auth_service.dart';

import '../models/users.dart';

class CustomerService extends AuthService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  addCUstomer(Users customer) async {
    await firebaseFirestore.collection(kTableUser).doc(customer.userID).set({
      kColumnUserId: customer.userID,
      kColumnUserName: customer.name,
      kColumnUserRole: customer.role,
      kColumnUserPhone: customer.phone,
    });
    return true;
  }
}
