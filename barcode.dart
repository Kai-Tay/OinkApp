import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart' as Main;
import 'receipt.dart';

class Barcode extends StatefulWidget {
  const Barcode({Key? key}) : super(key: key);

  @override
  _BarcodeState createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  String _scanBarcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.brown,
            shadowColor: Colors.transparent,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () {
            scanBarcodeNormal();
          },
          child: const Text('Barcode Scan'),
        ),
        SizedBox(width: 30),
        Receipt(),
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', false, ScanMode.BARCODE);
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    print(_scanBarcode);
//getting data from barcode
    if (_scanBarcode != "-1") {
      var url = Uri.parse(
        "https://api.upcitemdb.com/prod/trial/lookup?upc=$_scanBarcode",
      );
      var response = await http.get(url);
      String rawJson = response.body;
      var title = jsonDecode(rawJson)['items'][0]["title"];
      print(title);
      Main.titleTxt.text = title;
    }
  }

  ///

}
