class Asset {
  final int? id;
  final String utilization;
  final String status;
  final String assetType;
  final String ram;
  final String cpu;
  final String location;
  final String serialNumber;
  final String? brand;
  final String? model;

  Asset(this.id,this.utilization, this.status, this.assetType, this.ram, this.cpu,
      this.location, this.serialNumber, this.brand, this.model);
}
