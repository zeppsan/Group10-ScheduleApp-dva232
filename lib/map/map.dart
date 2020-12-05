import 'package:flutter/material.dart';

import '../appComponents/bottomNavigationLoggedIn.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
  }
}
