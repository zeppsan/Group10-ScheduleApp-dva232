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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0,0.0,10.0,10.0),
                    child: Image(
                      //height: 100.0,
                      image: AssetImage('assets/U1.jpg'),
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
