part of 'browsing_logic.dart';

// Events in browsing mode
abstract class BrowsingEvent {
  BrowsingEvent([List props = const <dynamic>[]]);
}

class GetKnownBuildingEvent extends BrowsingEvent {
  final Building building;
  GetKnownBuildingEvent(this.building):super ([building]);
}

class GetBuildingEvent extends BrowsingEvent {
  final String name;
  GetBuildingEvent(this.name):super ([name]);
}

// Get Floor Plan
class GetPlanEvent extends BrowsingEvent {
  Building building;
  int currentFloor;
  GetPlanEvent(this.currentFloor, this.building):super([currentFloor, building]);
}

// Get Original State
class GetOriginalEvent extends BrowsingEvent {}


class GetRoomEvent extends BrowsingEvent {
  final String inputString;
  GetRoomEvent(this.inputString):super([inputString]);
}

