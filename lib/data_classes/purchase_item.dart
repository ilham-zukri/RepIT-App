class PurchaseItem {
  int? id;
  final String type;
  final int? typeId;
  final String brand;
  final String model;
  int amount;
  final int priceEa;
  final int priceTotal;

  PurchaseItem(
      {this.id,
      required this.type,
      this.typeId,
      required this.brand,
      required this.model,
      required this.amount,
      required this.priceEa,
      required this.priceTotal});

  Map<String, dynamic> toMap() {
    return {
      "asset_type": type,
      "brand": brand,
      "amount": amount,
      "model": model,
      "price_ea": priceEa,
      "total_price": priceTotal
    };
  }

  Map<String, dynamic> toMapSp() => {
        "type_id": typeId,
        "brand": brand,
        "amount": amount,
        "model": model,
        "price_ea": priceEa,
        "total_price": priceTotal
      };
}
