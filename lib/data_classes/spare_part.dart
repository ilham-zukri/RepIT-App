class SparePart {
  final int? id;
  final String type;
  final String brand;
  final String model;
  final String? qrPath;
  final String serialNumber;
  final String? status;
  final String? createdAt;
  final int? purchaseId;
  final int? assetId;

  SparePart({
    this.id,
    required this.type,
    this.purchaseId,
    required this.brand,
    required this.model,
    this.qrPath,
    required this.serialNumber,
    this.status,
    this.assetId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    "type": type,
    "brand": brand,
    "model": model,
    "serial_number": serialNumber,
  };
}
