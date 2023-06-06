import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ML Demo TextScanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _imagePicker = ImagePicker();
  TextRecognizer textDetector = TextRecognizer();
  String? recognizeText;
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: (_image != null)
                        ? FileImage(_image!)
                        : const AssetImage("assets/image.jpg") as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                child: const Text('From Gallery'),
                onPressed: () async {
                  await getImage(ImageSource.gallery);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                child: const Text('Take a picture'),
                onPressed: () async {
                  await getImage(ImageSource.camera);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(child: Text(recognizeText ?? ''))),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getImage(ImageSource source) async {
    // pick image
    final pickedFile = await _imagePicker.pickImage(source: source);
    setState(() {
      if (pickedFile!.path.isNotEmpty) {
        print("Image selected");
        _image = File(pickedFile.path);
      } else {
        print('No Image Selected');
      }
    });
    // processImage
    final tempRecognizeText = await textDetector.processImage(
      InputImage.fromFilePath(pickedFile!.path),
    );
    setState(() {
      recognizeText = tempRecognizeText.text;
    });
    print(recognizeText!);
  }
}
