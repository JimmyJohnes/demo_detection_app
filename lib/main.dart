import 'package:flutter/material.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Demo Detection App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	Widget i  = Image.asset("assets/labels/Milk-Carton-Packaging-Mockup.jpg");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: i,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
	  ModelObjectDetection model = await PytorchLite.loadObjectDetectionModel(
		"assets/model/yolov8n.torchscript",
		80,640,640,
	  );
	  List<ResultObjectDetection> objDetect = await model.getImagePrediction(await File("assets/labels/Milk-Carton-Packaging-Mockup.jpg").readAsBytes(),
		minimumScore: 0.1);
		i = model.renderBoxesOnImage(File("assets/labels/Milk-Carton-Packaging-Mockup.jpg"), objDetect);
	},
        tooltip: 'Open Camera',
        child: const Icon(Icons.camera),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
