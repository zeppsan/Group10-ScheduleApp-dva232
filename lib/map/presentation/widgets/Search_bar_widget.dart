import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/data_domain/usecases/get_room_list_usecase.dart';
import 'package:schedule_dva232/map/presentation/searching_ploc/searching_logic.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';
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

  //Autocomplete the search fwith room names
  @override
  Widget build(BuildContext context) {
    return roomNames == null
      ? CircularProgressIndicator()
      : searchTextField = AutoCompleteTextField<String>(
      controller: txt,
      key: key,
      clearOnSubmit: false,
      submitOnSuggestionTap: true,
      suggestions: roomNames,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () {
            widget.mode == 'browsing'
                ? Navigator.of(context).pushNamed(
                '/searching', arguments: roomToFind)
                : dispatchGetRoom(roomToFind);
          },
          icon: Icon(Icons.search_rounded),
          color: lightTheme ? const Color(0xff2c1d33) : const Color(0xffeeb462),
        ),
        hintText: "Search room",
        hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: lightTheme ? const Color(0xff2c1d33) : const Color(
                0xffeeb462)
        ),
      ),
      itemFilter: (item, query) {
        return item.toLowerCase().startsWith(query.toLowerCase());
      },
      itemSorter: (a, b) {
        return a.compareTo(b);
      },
      textChanged: (value) {
        setState(() {
          roomToFind = value;
        });
      },
      textSubmitted: (value) {
        setState(() {
          roomToFind = value;
        });
        widget.mode == 'browsing'
            ? Navigator.of(context).pushNamed(
            '/searching', arguments: roomToFind)
            : dispatchGetRoom(roomToFind);
      },
      itemSubmitted: (item) {
        setState(() {
          roomToFind = item;
        });
        widget.mode == 'browsing'
            ? Navigator.of(context).pushNamed('/searching', arguments: roomToFind)
            : dispatchGetRoom(roomToFind);
      },
      itemBuilder: (context, item) {
        return row(item);
      },
    );
  }

  Widget row(String room) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          Container(
            child: Text(room, style: TextStyle(
                fontSize: 20.0,
                color: lightTheme ? const Color(0xff2c1d33) : const Color(
                    0xffeeb462))),
          ),
        ],
      ),
    );
  }

  void dispatchGetRoom(String roomToFind) {
    BlocProvider.of<SearchingLogic>(context)
        .add(GetRoomEvent(roomToFind));
  }
}