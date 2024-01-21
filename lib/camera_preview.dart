import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'globals.dart';
import 'dart:io';

class TakePicture extends StatefulWidget {
  const TakePicture ({super.key, required this.controller});
  final controller;

  @override
  State<TakePicture> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    	appBar: AppBar( backgroundColor: const Color.fromARGB(255, 70, 0, 125),),
	body: Column(
		children: [
			Expanded(
				child: CameraPreview(widget.controller)
			),
			Padding(
			  padding: const EdgeInsets.all(16.0),
			  child: ElevatedButton(onPressed: ()async{
			  	var pic = await widget.controller.takePicture();
				imageFile = File(pic.path);
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
				Navigator.pop(context);
			  }, 
			style: const ButtonStyle(
			      backgroundColor: MaterialStatePropertyAll(Colors.white),
			      ),
			  child: const Padding(
			    padding: EdgeInsets.all(10.0),
			    child: Row(
			    mainAxisAlignment: MainAxisAlignment.center,
			    	children: [
			    		Text("Take Picture", style: TextStyle(color: Colors.black),),
			    		Icon(Icons.camera, color: Colors.black,)
			    	],
			    ),
			  )),
			)
		],
	),
      backgroundColor: const Color.fromARGB(255, 70, 0, 125),
    );
  }
}
