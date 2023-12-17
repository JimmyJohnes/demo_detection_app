import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:demo_detection_app/counted_objects.dart';
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
	Widget image  = Image.asset("assets/labels/Milk-Carton-Packaging-Mockup.jpg",fit: BoxFit.fill);
	List<String?> classNames = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 70, 0, 100),
	shadowColor: Colors.grey,
        title: Center(child: Text(widget.title, style: const TextStyle(
		color: Colors.white,
		fontSize: 24.0,
		fontWeight: FontWeight.bold,
	),)),
      ),
      body: Column(
        children: [
		  Center(
			    child: Container(
			    width: 300,
			    height: 300,
				padding: const EdgeInsets.all(20),
				decoration: BoxDecoration(
					borderRadius: const BorderRadius.all(Radius.circular(50)),
					border: Border.all(color: Colors.white),
				) ,
			      child: image
			),
		),
		ElevatedButton(onPressed: (){
			Navigator.push(context, 
			MaterialPageRoute(builder: (_) => CountObjects(objNames: classNames))
			);
		}, child: Text("View Counted Classes"))
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 70, 0, 125),
      floatingActionButton: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
		FloatingActionButton(
		onPressed: () async {
		},
		tooltip: "Open From Camera",
		child: const Icon(Icons.camera),
	      ), // This trailing comma makes auto-formatting nicer for build methods.
	      FloatingActionButton(
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
		 classNames = [];
		 for (var i in objDetect){
		 	classNames.add(i.className);
		 }
		 File foo = File(imageFile.path);
		setState(() {
			 image = model.renderBoxesOnImage(foo, objDetect);
			});
		},
		tooltip: 'Open From Gallery',
		child: const Icon(Icons.photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      ],
      )
    );
  }
}
