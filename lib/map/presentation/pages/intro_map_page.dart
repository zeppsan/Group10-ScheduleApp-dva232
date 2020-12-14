import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/map/injection_container.dart' as ic;
import 'package:schedule_dva232/map/presentation/widgets/basic_map_widget.dart';
import 'package:schedule_dva232/map/presentation/widgets/plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';
class IntroMapPage extends StatelessWidget {
  @override build(BuildContext context) {
    return Scaffold(
      //TODO: Is there common AppBar to Share?
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: buildBody(context),
    );
  }
}

  Widget buildBody (BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
    return Column(
      children: <Widget>[
        TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a room',
            ),
            onChanged: (value) {
              inputStr = value;
            }
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text('Search'),
                color: Theme
                    .of(context)
                    .accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: () {
                  print('in intro_page searching for ' + inputStr);
                  Navigator.of(context).pushNamed('/searching', arguments: inputStr);
                },
              ),
            ),
            Expanded(
              child: RaisedButton(
                child: Text('Buildings U & T'),
                color: Theme
                    .of(context)
                    .accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: () {
                  Navigator.of(context).pushNamed('/browsing', arguments: 'U');
                },
              ),
            ),
            Expanded(
              child: RaisedButton(
                child: Text('Building R'),
                color: Theme
                    .of(context)
                    .accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: () {
                  Navigator.of(context).pushNamed('/browsing', arguments: 'R');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
