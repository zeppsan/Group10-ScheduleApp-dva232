import 'dart:async';
import 'package:schedule_dva232/map/core/util/input_converter.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/map/data_domain/usecases/get_building_usecase.dart';
import 'package:schedule_dva232/map/data_domain/usecases/get_room_usecase.dart';
part 'browsing_events.dart';
part 'browsing_states.dart';

const String BUILDING_NOT_FOUND_MESSAGE = 'Can not find the building';
const String INVALID_INPUT_MESSAGE = 'Write the whole room name';
const String ROOM_NOT_FOUND_MESSAGE = 'Can not find the room';

//presentation logic in browsing mode
class BrowsingLogic extends Bloc<BrowsingEvent, BrowsingState> {
  final GetBuilding getBuilding;
  final GetRoom getRoom;
  final InputConverter inputConverter;

  BrowsingLogic({
    @required this.getBuilding,
    @required this.getRoom,
    @required this.inputConverter,
  }) : super(EmptyState());

  @override
  //Map events and states
  //async* returns a stream while async returns a Future
  Stream<BrowsingState> mapEventToState(BrowsingEvent event) async* {
    // yield returns a value and DOES NOT terminate the function
    if (event is GetBuildingEvent) {
      yield LoadingState();
      final failureOrBuilding = await getBuilding(event.name);
      yield failureOrBuilding.fold(
            (failure) => ErrorState(message: BUILDING_NOT_FOUND_MESSAGE),
            (building) => BuildingLoadedState(building: building),
      );
    } else if (event is GetPlanEvent) {
      yield LoadingState();
      yield PlanLoaded(building: event.building, currentFloor: event.currentFloor);
    }
    else if (event is GetOriginalEvent) {
      yield LoadingState();
      yield EmptyState();
    }
    else if (event is GetKnownBuildingEvent) {
      yield BuildingLoadedState(building: event.building);
    }
    else if (event is GetRoomEvent) {
      final inputEither = inputConverter.processInput(event.inputString);
      yield* inputEither.fold (
        (failure) async *{
            yield ErrorState(message: INVALID_INPUT_MESSAGE);
        },
        (str) async* {
          final failureOrRoom = await getRoom(str);
          yield failureOrRoom.fold (
            (failure) => ErrorState(message: ROOM_NOT_FOUND_MESSAGE),
            (room) => RoomFoundState(room:room),
          );
        }
      );
    }
  }
}