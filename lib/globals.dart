import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

late List<CameraDescription> cameras;


Widget image  = Container(
	decoration: const BoxDecoration(
	      color: Color.fromARGB(100, 70, 0, 125),
	),
	child: const Padding(
	  padding: EdgeInsets.all(8.0),
	  child: Center(
		child: Text("Choose a picture to run object detection",
			style: TextStyle(
				fontSize: 24,
				color: Colors.black54,
				),)),
	)
);

late File imageFile;
