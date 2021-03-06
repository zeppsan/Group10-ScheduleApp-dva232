import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schedule_dva232/map/data_domain/models/coordinates.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:meta/meta.dart';
import 'package:schedule_dva232/map/core/error/exceptions.dart';
import 'package:schedule_dva232/map/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';

//Domain Layer
abstract class RoomRepository {
  Future <Either<Failure,Room>> getRoom(String name);
  Future <List<String>> getRoomList();
}

//Data Layer
abstract class RoomAssetsDataSource {
  Future <Room> getRoom(String name);
  Future <List<String>> getRoomList();
}

// Building Source Implementation
class RoomAssetsDataSourceImpl implements RoomAssetsDataSource {
  @override
  Future<List<String>> getRoomList() async {
    List<String> roomNames = List<String>();
    // read the json source file
    final String buildings = await rootBundle.loadString(
        "assets/buildings_rooms.json");
    Map<String, dynamic> jsonBuildings = json.decode(buildings);
    // Fill in the room list
    for (Map<String, dynamic> building in jsonBuildings['buildings']) {
      for (Map<String, dynamic> room in building['rooms']) {
        roomNames.add(room['name']);
      }
    }
    return Future.value(roomNames);
  }

  @override
  Future<Room> getRoom(String name) async {
    List<Coordinates> direction = List<Coordinates>();
    //read the json file
    final String buildings = await rootBundle.loadString(
        "assets/buildings_rooms.json");
    Map<String, dynamic> jsonBuildings = json.decode(buildings);
    for (Map<String, dynamic> building in jsonBuildings['buildings']) {
      for (Map<String, dynamic> room in building['rooms']) {
        //toUpper case is not needed here, if all rooms are Upper case in the json.
        // If some of them look like Alfa or something, then yes, but in this case it should be both sides from ||
        if (room['name'].toString().toUpperCase() == name || room['name'].toString().toUpperCase().replaceAll(new RegExp(r"\s+|-"), "" )== name) {
          //if room is found
          for (Map<String, dynamic> coordinate in room['path']) {
            direction.add(
                new Coordinates(x: coordinate['x'], y: coordinate['y']));
          }

          return Future.value(
              Room(
                building: Building(floors: building['floors'],
                  name: building['name'],
                  campus: building['campus']),
                name: room['name'],
                floor: room['floor'],
                path: direction,
                position: Coordinates(
                  x: room['position']['x'], y: room['position']['y'])
            )
          );
        }
      }
    }
    //room not found
    throw AssetsException();
  }
}

// Room Repository Implementation
class RoomRepositoryImpl implements RoomRepository {
  final RoomAssetsDataSource assetsDataSource;

  RoomRepositoryImpl({
    @required this.assetsDataSource
  });

  @override
  Future <List<String>> getRoomList() async {
      final List<String> roomlist = await assetsDataSource.getRoomList();
      return roomlist;
  }

  @override
  Future<Either<Failure, Room>> getRoom(String name) async {
    //Get the room data from assets
    try {
      final room= await assetsDataSource.getRoom(name);
      return Right(room);
    }
    //If fails to get room data
    on AssetsException {
      return Left(AssetsFailure());
    }
  }
}