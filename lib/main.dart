import 'package:camera/camera.dart';
import 'package:demo_detection_app/camera_preview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:demo_detection_app/counted_objects.dart';
import 'dart:io';
import 'package:demo_detection_app/globals.dart';



Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    	home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	List<String?> classNames = [];
	late CameraController controller;
	_RunObjDetection(imageFile) async{
		  	  ModelObjectDetection model = await PytorchLite.loadObjectDetectionModel(
		  		"assets/model/best(3).torchscript",
		  		10, 640, 640,
		  		objectDetectionModelType: ObjectDetectionModelType.yolov8,
		  		labelPath: "assets/labels/labels.txt"
		  		);
			 var img = await imageFile.readAsBytes();
		  	 List<ResultObjectDetection> objDetect = await model.getImagePrediction(img,minimumScore: 0.1,iOUThreshold: 0.3);
		  	 classNames = [];
		  	 for (var i in objDetect){
		  		classNames.add(i.className);
		  	 }
		  	 File foo = File(imageFile.path);
		  	setState(() {
		  		 image = model.renderBoxesOnImage(foo, objDetect);
			});
	}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            Stack(
              children: [
	  	Container(
			decoration: const BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))
			),
			height: 600,
		),
	  	Column(
                children: [
		  Center(
			    child: Container(
			    width: 300,
			    height: 450,
				padding: const EdgeInsets.all(20),
			      child: image,
			      ),
		),
		const SizedBox(height: 50),
		Padding(
		  padding: const EdgeInsets.all(8.0),
		  child: Row(
	      mainAxisAlignment: MainAxisAlignment.spaceAround,
	      children: [
		  	ElevatedButton(
			style: const ButtonStyle(
			      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 70, 0, 125)),
			      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0)),
			),
		  	onPressed: () async {
		  		controller = CameraController(cameras[0], ResolutionPreset.max);
		  		controller.initialize().then((_)async{
					await Navigator.push(context, MaterialPageRoute(builder: (context) => TakePicture(controller: controller),));
					setState(() {});
					await _RunObjDetection(imageFile);
					setState(() {});
		  		});

		  	},
		  	child: const Row(
		  	  children: [
		  	    Text("Camera"),
		  	    SizedBox(width: 5,),
		  	    Icon(Icons.camera)
		  	  ],
		  	),
		        ),
		        ElevatedButton(
			style: const ButtonStyle(
			      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 70, 0, 125)),
			      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0)),
			),
		  	onPressed: () async {
		  		XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
				image  = Container(
					decoration: const BoxDecoration(
					      color: Color.fromARGB(100, 70, 0, 125),
					),
					child: const Padding(
					  padding: EdgeInsets.all(8.0),
					  child: Center(
						child: Text("Detecting Objects...",
							style: TextStyle(
								fontSize: 24,
								color: Colors.black54,
								),)),
					)
				);
				setState(() {});
				await _RunObjDetection(File(pickedImage!.path));
				setState(() {});
		  	},
		  	child: const Row(
		  	  children: [
		  	    Icon(Icons.image),
		  	    SizedBox(width: 5,),
		  	    Text("Gallery"),
		  	  ],
		  	),
	      ),
	      ],
	      ),
		)

                ],
              ),
		],
            ),
		const SizedBox(height: 50,),
		Padding(
		  padding: const EdgeInsets.symmetric(horizontal: 30.0),
		  child: Row(
		    children: [
		      Expanded(
		        child: ElevatedButton(
		        	style: const ButtonStyle(
				      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 155, 70, 185)),
		        	      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0)),
		        	),
		        onPressed: (){
		        	Navigator.push(context, 
		        	MaterialPageRoute(builder: (_) => CountObjects(objNames: classNames))
		        	);
		        }, child: const Text("View Counted Classes")),
		      ),
		    ],
		  ),
		)
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 70, 0, 125),
  );
  }
}
