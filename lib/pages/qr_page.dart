import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:repit_app/data_classes/asset.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';

import '../services.dart';
import 'asset_detail.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  Asset? asset;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 350.0;

    return Scaffold(
      appBar: customAppBar(context, "Scan QR"),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.green,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: scanArea)),
          ),
          Expanded(
            flex: 1,
            child: Center(
                child: IconButton(
              icon: const Icon(Icons.flashlight_on),
              onPressed: () async {
                await controller?.toggleFlash();
              },
            )),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) async {
        controller.pauseCamera();
        if (scanData.code == null) {
          return;
        }
        try {
          result = scanData;
          await fetchAssetData();
          if (mounted) {
            //stopping camera before going to asset detail
            controller.stopCamera();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AssetDetail(asset: asset!, withAdvancedMenu: false),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xff00ABB3),
                content: Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }
        }
        controller.resumeCamera();
      },
    );
  }

  Future<void> fetchAssetData() async {
    try {
      var data = await Services.getAssetByQrCode(result!.code!);
      if (data == null) {
        return;
      }
      asset = Asset(
        data['id'],
        data['utilization'],
        data['status'],
        data['asset_type'],
        data['ram'],
        data['cpu'],
        data['location'],
        data['serial_number'],
        data['brand'],
        data['model'],
        data['qr_path'],
        data['owner'],
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
