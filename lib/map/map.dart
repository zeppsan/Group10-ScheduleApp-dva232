//import 'dart:html';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schedule_dva232/map/DirectionPainter.dart';

import 'dart:ui';

import '../appComponents/bottomNavigationLoggedIn.dart';


class MdhMap extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MdhMap> with TickerProviderStateMixin {

  double x;
  double y;

  Future parseJson() async{
    final String buildings = await rootBundle.loadString("assets/buildings_rooms.json");
    print('inside room_repository the file is read');
    Map<String, dynamic> jsonBuildings = json.decode(buildings);

    for (Map<String, dynamic> room in jsonBuildings['buildings'][0]['rooms']) {
      if(room['name'] == 'alfa'){
        setState(() {
          x = room['position']['x'];
          y = room['position']['y'];
        });
        print(room['position']['x']);
      }
    }


  }

  @override
  void initState() {
    parseJson();
    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Map")),
      ),
      body: Container(
        //color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
          //  color: const Color(0xffdfb15b),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    onTap: () {
                      setState(() {
                        print('Test');
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Search room",

                      suffixIcon: Icon(
                        Icons.search_rounded,
                        size: 34.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){},
                          child: Text(
                            "House U & T",
                          ),

                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){},
                          child: Text(
                            "House R",
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0,10.0,0.0),
                  child: Container(
                    child: ClipRect(
                      child: InteractiveViewer(
                        //boundaryMargin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                        minScale: 0.1,
                        maxScale: 5.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,

                         // height: 340,
                          height: MediaQuery.of(context).size.height * 0.55,
                          decoration: BoxDecoration(color: Colors.white),
                          child: FittedBox (
                            fit: BoxFit.contain,
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/U1.2.jpg',
                                 //fit: BoxFit.cover,
                                ),
                                Positioned(
                                  left: x, // x lat
                                  top: y , // y long

                                  child: Icon(
                                    Icons.location_on,
                                    size: 100,
                                    color: Colors.deepOrange[800],
                                  ),
                                ),

                              CustomPaint(
                                //size: Size(350, MediaQuery.of(context).size.height),
                                painter: DirectionPainter(),
                              ),
                            ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.arrow_back_rounded),
                      ),

                      Expanded(child: Center(child: Text("Floor: 1")),),
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.arrow_forward_rounded),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

        ),

      ),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
  }
}


 //skapa funktion som kollar vilken painter-klass som ska användas..



