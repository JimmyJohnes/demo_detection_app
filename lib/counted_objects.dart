import 'package:flutter/material.dart';

class CountObjects extends StatefulWidget {
  const CountObjects({super.key,this.objNames = const ["Foo", "Bar","Baz","Foo"]});
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
    body: Column(
      children: [
        Expanded(
          child: Stack(
            children: [
	    Container(
		decoration: const BoxDecoration(
			borderRadius:BorderRadius.vertical(bottom: Radius.circular(50)),
			color: Colors.white
		),
		),
	    Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
		decoration: const BoxDecoration(
			borderRadius:BorderRadius.vertical(bottom: Radius.circular(50), top: Radius.circular(15)),
			color: const Color.fromARGB(255, 70, 0, 125),
		),
                child: ListView.builder(itemBuilder: (_, index) {
	  return Padding(
	    padding: const EdgeInsets.all(16.0),
	    child: Row(
	    mainAxisAlignment: MainAxisAlignment.spaceBetween,
	    children: [
		  Text("${frequencies.keys.elementAt(index)}", style: TextStyle(color: Colors.white,fontSize: 24.0),),
		  Text("${frequencies[frequencies.keys.elementAt(index)]}", style: TextStyle(color: Colors.white, fontSize: 24.0),),
	    ],),
	  );
	},itemCount: frequencies.length,),
              ),
            ),
	    ]
          ),
        ),
	  Padding(
	    padding: const EdgeInsets.all(16.0),
	    child: Row(
	      children: [
	        Expanded(
	          child: ElevatedButton(
			style: const ButtonStyle(
			      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 155, 70, 185)),
			      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0)),
			),
	          onPressed: (){
	          	Navigator.pop(context);
	          },
	          child: const Text("Back"),
	          ),
	        ),
	      ],
	    ),
	  )
      ],
    ),
	backgroundColor: const Color.fromARGB(255, 70, 0, 125),
    )   ;
}
}
