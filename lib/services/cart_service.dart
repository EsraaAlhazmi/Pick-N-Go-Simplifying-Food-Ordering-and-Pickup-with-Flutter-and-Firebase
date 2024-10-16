// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:pickapp/data/sql_db.dart';

class Cart extends ChangeNotifier {
  int total = 0;
  SqlDb sqlDb = SqlDb();

  Future<List<Map>> getData() async {
    List<Map> response = await sqlDb.readData("select * from cart");
    return response;
  }

  Future<int> addToCart(String itemId, int quantity, num unitPrice) async {
    int response = await sqlDb.insertData(
        'insert into cart(itemId,quantity,unitPrice)values("$itemId",$quantity,$unitPrice)');
    total = await getCartCount();
    notifyListeners();

    print(total);
    return response;
  }

  Future<int> removeItemFromCart(String itemId) async {
    int response =
        await sqlDb.deleteData("delete from cart where itemId=$itemId");
    total = await getCartCount();
    notifyListeners();

    return response;
  }

  Future<int> deleteCart() async {
    int response = await sqlDb.deleteData("delete from cart");
    total = await getCartCount();
    notifyListeners();
    return response;
  }

  Future<int> getCartCount() async {
    List<Map> rows = await sqlDb.readData("select count(*)as count from cart");
    int count = rows[0]['count'];
    return count;
  }

  checkInCart(String itemId) async {
    List<Map> response = await sqlDb
        .readData("select count(*) as rows from cart where itemId='$itemId'");
    total = await getCartCount();
    notifyListeners();
    return response[0]['rows'] > 0 ? true : false;
  }
}
