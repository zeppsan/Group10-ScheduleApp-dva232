import 'dart:async';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedule_dva232/map/data_domain/usecases/get_building_usecase.dart';
part 'browsing_events.dart';
part 'browsing_states.dart';

const String BUILDING_NOT_FOUND_MESSAGE = 'Can not find the building';
const String INVALID_INPUT_MESSAGE = 'Write the whole room name';
//presentation logic

class BrowsingLogic extends Bloc<BrowsingEvent, BrowsingState> {
  final GetBuilding getBuilding;

  BrowsingLogic({
    @required this.getBuilding,
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
  }
}