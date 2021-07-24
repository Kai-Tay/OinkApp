import 'package:flutter/material.dart';
import 'database.dart';

var db = new Database();

class Receipt extends StatefulWidget {
  const Receipt({Key? key}) : super(key: key);

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.brown,
          shadowColor: Colors.transparent,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {
          //scanReceiptNormal()
        },
        child: const Text('Receipt Scan'),
      ),
    );
  }
}
