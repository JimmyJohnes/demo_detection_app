import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:image_picker_android/image_picker_android.dart';
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
	Image dk = Image.asset("assets/labels/Milk-Carton-Packaging-Mockup.jpg");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
      width: 250,
      height: 250,
        child: Stack(
		children: [
			i
		],
	),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
	  ModelObjectDetection model = await PytorchLite.loadObjectDetectionModel(
		"assets/model/best(1).torchscript",
		10, 640, 640,
		objectDetectionModelType: ObjectDetectionModelType.yolov8,
		labelPath: "assets/labels/labels.txt"
		);
		PickedFile? imageFile = await ImagePickerAndroid().pickImage(source: ImageSource.gallery);
	 var img = await File(imageFile!.path).readAsBytes();
	 List<ResultObjectDetection> objDetect = await model.getImagePrediction(img,minimumScore: 0.1,iOUThreshold: 0.3);
	 print("=======================\n");
	 for (var i in objDetect){
	 	print(i.className);
	 }
	 File foo = File(imageFile.path);
	 i = model.renderBoxesOnImage(foo, objDetect);
	 dk = Image.file(foo);
		setState(() {
				});
	},
        tooltip: 'Open Camera',
        child: const Icon(Icons.camera),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
