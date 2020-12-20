import 'dart:async';
import 'package:schedule_dva232/map/core/util/input_converter.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/map/data_domain/usecases/get_room_usecase.dart';
part 'searching_events.dart';
part 'searching_states.dart';

const String ROOM_NOT_FOUND_MESSAGE = 'Can not find the room';
const String INVALID_INPUT_MESSAGE = 'Write the whole room name';
//presentation logic

class SearchingLogic extends Bloc<SearchingEvent, SearchingState> {
  final GetRoom getRoom;
  final InputConverter inputConverter;

  SearchingLogic({
    @required this.getRoom,
    @required this.inputConverter,

  }) : super(EmptyState());

  @override
  //Map events and states
  //async* returns a stream while async returns a Future
  Stream<SearchingState> mapEventToState(SearchingEvent event) async* {
    // yield returns a value and DOES NOT terminate the function
    if (event is GetRoomEvent) {
      final inputEither = inputConverter.processInput(event.inputString);
      yield* inputEither.fold (
              (failure) async *{
            yield ErrorState(message: INVALID_INPUT_MESSAGE);
          },
              (str) async* {
            yield LoadingState();
            final failureOrRoom = await getRoom(str);
            yield failureOrRoom.fold (
                  (failure) => ErrorState(message: ROOM_NOT_FOUND_MESSAGE),
                  (room) => RoomLoadedState(room:room),
            );
          }
      );
    }
    else if (event is GetPlanEvent) {
      yield LoadingState();
      yield PlanLoaded(room: event.room, currentFloor: event.currentFloor);
    }
    else if (event is GetKnownRoomEvent) {
      yield RoomLoadedState(room: event.room);
    }
  }
}