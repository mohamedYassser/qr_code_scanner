import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool flashOn = false;
  bool cameraBack = true;


  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Stack(children: [
              _buildQrView(context),
              Positioned(
                  right: 150,
                  top: 80,
                  child: IconButton(
                    icon: Icon(
                      Icons.switch_camera,
                      color: cameraBack ? Colors.grey : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        cameraBack = !cameraBack;
                      });
                      controller?.flipCamera();
                    },
                  )),
              Positioned(
                left: 150,
                top: 80,
                child: IconButton(
                  icon: Icon(
                    Icons.flash_on,
                    color: flashOn ? Colors.white : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      flashOn = !flashOn;
                    });
                    controller?.toggleFlash();
                  },
                ),
              ),
              Positioned(
                bottom: 60,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    result != null
                        ? 'Barcode Type: ${describeEnum(result!.format)} Data: ${result!.code}'
                        : 'Scan Code',
                    maxLines: 3,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.cyanAccent,
          borderRadius: 5,
          borderLength: 10,
          borderWidth: 5,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
