class Asset {
  final int? id;
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

  Asset(this.id,this.utilization, this.status, this.assetType, this.ram, this.cpu,
      this.location, this.serialNumber, this.brand, this.model, this.qrPath);

  Map<String,dynamic> toMap(){
    return{
      "asset_type" : assetType,
      "brand" : brand,
      "model" : model,
      "serial_number" : serialNumber,
      "cpu" : cpu,
      "ram" : ram,
      "utilization" : utilization
    };
  }
}
