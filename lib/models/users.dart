// ignore_for_file: public_member_api_docs, sort_constructors_first
class Users {
  String? userID;
  String? name;
  String? role;
  String? providerType;
  String? description;
  String? position;
  String? photo;
  String? phone;
  num? latitude;
  num? longitude;

  Users(
      {this.userID,
      this.name,
      this.role,
      this.providerType,
      this.description,
      this.photo,
      this.phone,
      this.latitude,
      this.longitude});
}
