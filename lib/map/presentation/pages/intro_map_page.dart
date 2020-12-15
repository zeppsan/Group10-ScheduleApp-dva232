import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/presentation/widgets/basic_map_widget.dart';
import 'package:schedule_dva232/map/presentation/widgets/browsing_plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';

class IntroMapPage extends StatelessWidget {
  @override build(BuildContext context) {
    return Scaffold(
      //TODO: Is there common AppBar to Share?
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: buildBody(context),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
  }
}

  Widget buildBody (BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                //TODO: change to appropriate widget
                TopControlsWidget(),
                //TODO: change to appropriate widget
                BasicMapWidget (basicMapToShow: 'basic'),
                //Should there be something on the bottom?
                //BottomControlsWidget(),
                //TODO:Common bottomWidget?
              ]
          ),
        )
    );
  }

  //TODO: Change accordingly to UI design
  //TODO:This should probably be Stateless. Probably create another file
  class TopControlsWidget extends StatefulWidget {
    const TopControlsWidget({ Key key }): super(key: key);

    @override
    _TopControlsState createState() => _TopControlsState();
  }

  class _TopControlsState extends State<TopControlsWidget> {
    String inputStr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            onChanged: (value) {
              inputStr = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),),
              hintText: "Search room",

              suffixIcon: IconButton(
                onPressed: (){
                  Navigator.of(context).pushNamed('/searching', arguments: inputStr);
                },
                icon: Icon(Icons.search_rounded),
                //size: 34.0,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Text('Buildings U & T'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/browsing', arguments: 'U');
                  },
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: ElevatedButton(
                  child: Text('Building R'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/browsing', arguments: 'R');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
