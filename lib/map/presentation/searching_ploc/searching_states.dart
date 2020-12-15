part of 'searching_logic.dart';

abstract class SearchingState {
  SearchingState([List props  = const <dynamic>[]]);
}

class RoomLoadedState extends SearchingState {
  final Room room;
  RoomLoadedState({@required this.room}):super ([room]);
}

class LoadingState extends SearchingState{}

class EmptyState extends SearchingState{}

class ErrorState extends SearchingState {
  final String message;
  ErrorState ({@required this.message}):super ([message]);
}

class PlanLoaded extends SearchingState {
  final Room room;
  int currentFloor;
  PlanLoaded({@required this.room, @required this.currentFloor}):super ([room, currentFloor]);
}