import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickapp/constants/table.dart';
import 'package:pickapp/models/item.dart';

class ItemService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<bool> addItem(Item item) async {
    String? photoUrl = await addPhoto();
    var documentRef = firebaseFirestore.collection(kTableProduct).doc();
    documentRef.set({
      kColumnItemId: documentRef.id,
      kColumnName: item.name,
      kColumnDescription: item.description,
      kColumnPrice: item.price,
      kColumnProviderID: item.providerID,
      kColumnphoto: photoUrl,
      kColumnIsActive: true
    });
    return true;
  }

  Future<bool> updateItem(Item item) async {
    String? photoUrl = await addPhoto();
    if (photoUrl != null) {
      await firebaseFirestore
          .collection(kTableProduct)
          .doc(item.itemId)
          .update({
        kColumnName: item.name,
        kColumnDescription: item.description,
        kColumnPrice: item.price,
        kColumnProviderID: item.providerID,
        kColumnphoto: photoUrl
      });
    } else {
      await firebaseFirestore
          .collection(kTableProduct)
          .doc(item.itemId)
          .update({
        kColumnName: item.name,
        kColumnDescription: item.description,
        kColumnPrice: item.price,
        kColumnProviderID: item.providerID,
      });
    }
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

  deleteItem(String? id) {
    firebaseFirestore
        .collection(kTableProduct)
        .doc(id)
        .update({"isActive": false});
    return true;
  }

  Future<List> displayItems(String providerID) async {
    List items = [];

    await firebaseFirestore
        .collection(kTableProduct)
        .where('providerID', isEqualTo: providerID)
        .where('isActive', isEqualTo: true)
        .get()
        .then((querysnapshot) => {
              querysnapshot.docs.forEach((element) {
                items.add(element.data());
              })
            });

    return items;
  }

  Future<List> displayItemsById(String? id) async {
    List items = [];

    await firebaseFirestore
        .collection(kTableProduct)
        .doc(id)
        .get()
        .then((querysnapshot) => {items.add(querysnapshot.data())});

    return items;
  }
}
