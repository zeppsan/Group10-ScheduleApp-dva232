part of 'searching_logic.dart';

//Events in searching mode
abstract class SearchingEvent {
  SearchingEvent([List props = const <dynamic>[]]);
}

class GetBuildingEvent extends SearchingEvent {
  final String name;
  GetBuildingEvent(this.name):super ([name]);
}

class GetRoomEvent extends SearchingEvent {
  final String inputString;
  GetRoomEvent(this.inputString):super([inputString]);
}

// Get Floor Plan Event
class GetPlanEvent extends SearchingEvent {
  Room room;
  int currentFloor;
  GetPlanEvent(this.currentFloor, this.room):super([currentFloor, room]);
}

class GetKnownRoomEvent extends SearchingEvent {
  final Room room;
  GetKnownRoomEvent(this.room):super([room]);
}