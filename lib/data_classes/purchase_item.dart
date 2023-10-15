class PurchaseItem {
  final String assetType;
  final String brand;
  final String model;
  final int amount;
  final int priceEa;
  final int priceTotal;

  PurchaseItem(
      {required this.assetType,
      required this.brand,
      required this.model,
      required this.amount,
      required this.priceEa,
      required this.priceTotal});

  Map<String, dynamic> toMap(){
    return {
      "asset_type": assetType,
      "brand": brand,
      "amount" : amount,
      "model": model,
      "price_ea": priceEa,
      "total_price": priceTotal
    };
  }
}
