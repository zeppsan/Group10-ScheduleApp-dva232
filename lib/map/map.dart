//import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../appComponents/bottomNavigationLoggedIn.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
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
                          height: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/U1.jpg',
                                //fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.width -180, left: MediaQuery.of(context).size.width -200, //give the values according to your requirement
                                child: Icon(Icons.location_on),
                              ),
                            ],
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
