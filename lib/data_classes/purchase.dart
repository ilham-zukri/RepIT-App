import 'package:repit_app/data_classes/purchase_item.dart';

class Purchase {
  final int id;
  final String vendorName;
  final List<PurchaseItem> items;

  Purchase({required this.id, required this.vendorName, required this.items});
}