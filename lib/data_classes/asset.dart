class Asset {
  final int? id;
  final String? name;
  String? owner;
  final String utilization;
  final String? status;
  final String assetType;
  final String ram;
  final String cpu;
  final String? location;
  final String serialNumber;
  final String? qrPath;
  final String? brand;
  final String? model;

  // TODO : add purchase id

  Asset(
    this.id,
    this.name,
    this.utilization,
    this.status,
    this.assetType,
    this.ram,
    this.cpu,
    this.location,
    this.serialNumber,
    this.brand,
    this.model,
    this.qrPath,
    this.owner,
  );

  Map<String, dynamic> toMap() {
    return {
      "asset_type": assetType,
      "brand": brand,
      "model": model,
      "serial_number": serialNumber,
      "cpu": cpu,
      "ram": ram,
      "utilization": utilization
    };
  }
}
