import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: unused_element
File _image = _image;
final picker = ImagePicker();

Future getCameraImage() async {
  final XFile? cameraImage = await picker.pickImage(source: ImageSource.camera);

  setState(() {
    if (cameraImage != null) {
      _image = File(cameraImage.path);
    } else {
      print("No Image Selected.");
    }
  });
}

void setState(Null Function() param0) {}

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
          getCameraImage();
        },
        child: const Text('Receipt Scan'),
      ),
    );
  }
}
