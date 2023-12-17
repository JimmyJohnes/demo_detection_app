import 'package:flutter/material.dart';

class CountObjects extends StatefulWidget {
  const CountObjects({super.key,required this.objNames});
  final List<String?> objNames;

  @override
  State<CountObjects> createState() => _CountObjectsState();
}

class _CountObjectsState extends State<CountObjects> {
  _initFrequencies(){
	  Map<String?, int> freq = Map<String,int>();
	  for (var i in widget.objNames){
	  	if(!freq.containsKey(i)){
			freq[i] = 1;
		}
	  }
	  for(var i in freq.keys){
		int foo = 0;
	  	for(var j in widget.objNames){
			if ( i == j){
				foo++;
			}
		}
		freq[i] = foo;
	  }
	  return freq;
  }
  late Map<String, int> frequencies = _initFrequencies();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 70, 0, 100),
	shadowColor: Colors.grey,
        title: const Center(child: Text("Demo Detection App", style: TextStyle(
		color: Colors.white,
		fontSize: 24.0,
		fontWeight: FontWeight.bold,
	),)),
      ),
    body: ListView.builder(itemBuilder: (_, index) {
	  return Row(
	  mainAxisAlignment: MainAxisAlignment.spaceBetween,
	  children: [
		  Text("${frequencies.keys.elementAt(index)}", style: TextStyle(color: Colors.white,fontSize: 24.0),),
		  Text("${frequencies[frequencies.keys.elementAt(index)]}", style: TextStyle(color: Colors.white, fontSize: 24.0),),
	  ],);
	},itemCount: frequencies.length,),
	backgroundColor: const Color.fromARGB(255, 70, 0, 125),
    )   ;
}
}
