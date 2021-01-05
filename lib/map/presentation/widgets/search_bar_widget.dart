import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/data_domain/usecases/get_room_list_usecase.dart';
import 'package:schedule_dva232/map/presentation/browsing_ploc/browsing_logic.dart' as bl;
import 'package:schedule_dva232/map/presentation/searching_ploc/searching_logic.dart' as sl;

// Widget to present search bar
class SearchBarWidget extends StatefulWidget {
  final String mode;
  final String roomToFind;
  const SearchBarWidget ({ Key key, this.mode, this.roomToFind}): super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState(roomToFind);
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  List<String> roomNames;
  String roomToFind;
  AutoCompleteTextField searchTextField;
  var txt=TextEditingController();

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  _SearchBarWidgetState(this.roomToFind);

  //Get room names to list as suggestions
  void loadList() async {
    var getRoomList = ic.serviceLocator.get<GetRoomList>();
    roomNames = await getRoomList();
    setState(() {});
  }

  @override
  void initState() {
    loadList();
    super.initState();
    txt.text=roomToFind;
  }

  //Autocomplete the search with room names
  @override
  Widget build(BuildContext context) {
    return roomNames == null
      ? CircularProgressIndicator()
      : searchTextField = AutoCompleteTextField<String>(
        controller: txt,
        key: key,
        clearOnSubmit: widget.mode == 'browsing' ? true: false,
        submitOnSuggestionTap: true,
        suggestions: roomNames,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              dispatchGetRoom(roomToFind, widget.mode);
            },
            icon: Icon(Icons.search_rounded),
            color: Theme.of(context).accentColor,
          ),
          labelText: "Search room",
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor,
          ),
        ),
        itemFilter: (item, query) {
          return item.toLowerCase().startsWith(query.toLowerCase());
        },
        itemSorter: (a, b) {
          return a.compareTo(b);
        },
        textChanged: (value) {
          setState(() { roomToFind = value; });
        },
        textSubmitted: (value) {
          setState(() { roomToFind = value; });
          dispatchGetRoom(roomToFind, widget.mode);
        },
        itemSubmitted: (item) {
          setState(() { roomToFind = item; });
          dispatchGetRoom(roomToFind, widget.mode);
        },
        itemBuilder: (context, item) {
          return row(item);
        },
      );
  }

  // Widget presenting alternatives
  Widget row(String room) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          Container(
            child: Text(
              room,
              style: TextStyle(
                fontSize: 20.0,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dispatchGetRoom(String roomToFind, String mode ) {
    mode == 'searching'
    ? BlocProvider.of<sl.SearchingLogic>(context)
        .add(sl.GetRoomEvent(roomToFind))
    : BlocProvider.of<bl.BrowsingLogic>(context)
        .add(bl.GetRoomEvent(roomToFind));
  }
}