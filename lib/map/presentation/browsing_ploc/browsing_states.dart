part of 'browsing_logic.dart';

// Browsing mode states
abstract class BrowsingState {
  BrowsingState([List props  = const <dynamic>[]]);
}

class BuildingLoadedState extends BrowsingState {
  final Building building;
  BuildingLoadedState({@required this.building}):super ([building]);
}

class LoadingState extends BrowsingState{}

class EmptyState extends BrowsingState{}

class ErrorState extends BrowsingState {
  final String message;
  ErrorState ({@required this.message}):super ([message]);
}

class RoomFoundState extends BrowsingState {
  final Room room;
  RoomFoundState({@required this.room}):super([room]);
}

class PlanLoaded extends BrowsingState {
  final Building building;
  int currentFloor;
  PlanLoaded({@required this.building, @required this.currentFloor}):super ([building, currentFloor]);
}

