// ignore_for_file: public_member_api_docs, sort_constructors_first
class CustomerOrder {
  String? orderId;
  DateTime? orderDate;
  String? customerId;
  String? providerId;
  String? orderStatus;

  CustomerOrder({
    this.orderId,
    this.orderDate,
    this.customerId,
    this.providerId,
    this.orderStatus,
  });
}
