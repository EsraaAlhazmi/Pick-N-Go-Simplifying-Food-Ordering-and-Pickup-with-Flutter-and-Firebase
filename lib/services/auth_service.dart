import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickapp/constants/table.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  Future<UserCredential?> signUp(String email, String password) async {
    final UserCredential userCredential = await auth
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  Future<UserCredential?> signIn(String email, String password) async {
    final UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<String?> getUserName() async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    if (auth.currentUser != null) {
      String name = await firebaseFirestore
          .collection(kTableUser)
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) => value.data()!['name']);
      return name;
    }
    return null;
  }

  getUserEmail() {
    return auth.currentUser!.email;
  }

  bool isLogin() {
    return auth.currentUser?.uid != null ? true : false;
  }

  void signOut() {
    auth.signOut();
  }

  Future<String?> getUserType() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userType;
    await FirebaseFirestore.instance
        .collection(kTableUser)
        .where('userID', isEqualTo: user?.uid)
        .limit(1)
        .get()
        .then((value) => {userType = value.docs[0].data()[kColumnUserRole]});
    return userType;
  }
}
