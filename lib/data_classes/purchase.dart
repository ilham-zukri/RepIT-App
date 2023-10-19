import 'package:repit_app/data_classes/purchase_item.dart';

class Purchase {
  final int id;
  final int requestId;
  final String vendorName;
  final String purchasedBy;
  final String requester;
  final String createdAt;
  String status;
  final int totalPrice;
  final List<PurchaseItem> items;

  Purchase(
      {required this.id,
      required this.requestId,
      required this.purchasedBy,
      required this.requester,
      required this.createdAt,
      required this.status,
      required this.totalPrice,
      required this.vendorName,
      required this.items});
}
