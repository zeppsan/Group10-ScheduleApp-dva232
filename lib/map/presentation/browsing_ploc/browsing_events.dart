part of 'browsing_logic.dart';

abstract class BrowsingEvent {
  BrowsingEvent([List props = const <dynamic>[]]);
}

class GetBuildingEvent extends BrowsingEvent {
  final String name;
  GetBuildingEvent(this.name):super ([name]);
}

class GetPlanEvent extends BrowsingEvent {
  Building building;
  int currentFloor;
  GetPlanEvent(this.currentFloor, this.building):super([currentFloor, building]);
}

class GetOriginalEvent extends BrowsingEvent {}