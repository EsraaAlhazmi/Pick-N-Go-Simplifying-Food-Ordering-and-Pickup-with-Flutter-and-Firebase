import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickapp/constants/table.dart';
import 'package:pickapp/models/users.dart';
import 'package:pickapp/services/auth_service.dart';

class ProviderFoodService extends AuthService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  addProviderFood(Users providerFood) async {
    await firebaseFirestore
        .collection(kTableUser)
        .doc(providerFood.userID)
        .set({
      kColumnUserId: providerFood.userID,
      kColumnUserName: providerFood.name,
      kColumnUserPhone: providerFood.phone,
      kColumnUserLatitude: providerFood.latitude,
      kColumnUserLongitude: providerFood.longitude,
      kColumnUserProviderType: providerFood.providerType,
      kColumnUserDescription: providerFood.description,
      kColumnUserPhoto: providerFood.photo,
      kColumnUserRole: "ProviderFood"
    });

    return true;
  }

  Future<String?> addPhoto() async {
    File? file;
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      file = File(image.path);

      String uniqFileName = DateTime.now().millisecondsSinceEpoch.toString() +
          path.basename(image.path).toString();
      var refStorage = FirebaseStorage.instance.ref("images/$uniqFileName");
      await refStorage.putFile(file);
      var url = await refStorage.getDownloadURL();
      return url;
    }
    return null;
  }

  getAllProvider() async {
    List providers = [];
    await firebaseFirestore
        .collection(kTableUser)
        .where(kColumnUserRole, isEqualTo: "ProviderFood")
        .get()
        .then((querysnapshot) => {
              querysnapshot.docs
                  .forEach((element) => providers.add(element.data()))
            });

    return providers;
  }

  getProviderProfile(String? id) async {
    List provider = [];
    await firebaseFirestore
        .collection(kTableUser)
        .doc(id)
        .get()
        .then((value) => provider.add(value.data()));
    return provider;
  }

  updateProvider(Users provider) async {
    await firebaseFirestore.collection(kTableUser).doc(provider.userID).update({
      "name": provider.name,
      "description": provider.description,
      "phone": provider.phone,
    });
    return true;
  }

  updateProviderLocation(Users provider) async {
    var result = await firebaseFirestore
        .collection(kTableUser)
        .doc(provider.userID)
        .update({
      "latitude": provider.latitude,
      "longitude": provider.longitude,
    });
    return result;
  }

  Future<bool> updateProviderPhoto() async {
    String? photoUrl = await addPhoto();
    var result = await firebaseFirestore
        .collection(kTableUser)
        .doc(AuthService().getCurrentUser()!.uid)
        .update({"photo": photoUrl});
    return true;
  }
}
