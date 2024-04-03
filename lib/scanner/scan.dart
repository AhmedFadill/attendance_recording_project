import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String barcodeScanResult = 'Waiting for scan...';
  Future<void> scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on FormatException {
      barcodeScanRes = 'Faild  to scan Barcode';
    }
    if (!mounted) return;
    setState(() {
      barcodeScanResult = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) => Container(
          alignment: Alignment.center,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: scanBarcode, child: Text("Start Scanning")),
              SizedBox(height: 20),
              Text(barcodeScanResult)
            ],
          ),
        ),
      ),
    );
  }
}
