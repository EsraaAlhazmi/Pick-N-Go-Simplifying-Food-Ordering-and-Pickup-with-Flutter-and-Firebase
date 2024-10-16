// ignore_for_file: public_member_api_docs, sort_constructors_first

class Item {
  String? itemId;
  String? name;
  num? price;
  String? description;
  String? providerID;
  String? photo;
  bool? isActive;

  Item(
      {required this.name,
      required this.price,
      this.photo,
      this.description,
      this.itemId,
      required this.providerID,
      this.isActive = true});
}
