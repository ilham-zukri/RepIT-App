class SparePart {
  final int id;
  final String type;
  final String brand;
  final String model;
  final String qrPath;
  final String serialNumber;
  String status;
  String createdAt;
  final int? purchaseId;
  final int? assetId;

  SparePart({
    required this.id,
    required this.type,
    required this.purchaseId,
    required this.brand,
    required this.model,
    required this.qrPath,
    required this.serialNumber,
    required this.status,
    required this.assetId,
    required this.createdAt,
  });
}
