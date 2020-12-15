import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schedule_dva232/map/data_domain/models/coordinates.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:meta/meta.dart';
import 'package:schedule_dva232/map/core/error/exceptions.dart';
import 'package:schedule_dva232/map/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Domain Layer
abstract class RoomRepository {
  Future <Either<Failure,Room>> getRoom(String name);
  Future <Either<Failure,Room>> getLastRoom();
}

//Data Layer
abstract class RoomAssetsDataSource {
  Future <RoomModel> getRoom(String name);
}

abstract class RoomCacheDataSource {
  Future <RoomModel> getLastRoom();
  Future<void> cacheRoom(RoomModel roomToCache);
}

class RoomAssetsDataSourceImpl implements RoomAssetsDataSource {

  @override
  Future<RoomModel> getRoom (String name)  async {
    final String buildings = await rootBundle.loadString("assets/buildings_rooms.json");
    Map<String, dynamic> jsonBuildings = json.decode(buildings);
    for (Map<String, dynamic> building in jsonBuildings['buildings']) {
      for (Map<String, dynamic> room in building['rooms']) {
        if (room['name'].toString().toLowerCase() == name) {
          //if room is found
          print('the room is found');
          print (room['position']['x']);
          print(room['position']['y']);
          return Future.value(RoomModel(
              building: Building (floors: building['floors'], name:building['name'], campus: building['campus']),
              name: room['name'],
              floor: room['floor'],
              position: Coordinates(
                  x: room['position']['x'], y: room['position']['y'])));
        }
      }
    }
    //room not found
    throw AssetsException();
  }
}

class RoomCacheDataSourceImpl implements RoomCacheDataSource {
  final SharedPreferences sharedPreferences;
  RoomCacheDataSourceImpl({@required this.sharedPreferences});
  @override
  Future<RoomModel> getLastRoom() {
    final jsonStringBuilding = sharedPreferences.getString('CACHED_ROOM');
    if(jsonStringBuilding != null) {
      return Future.value(RoomModel.fromJson(json.decode(jsonStringBuilding)));
    }
    else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheRoom(RoomModel roomToCache) {
    return sharedPreferences.setString('CACHED_ROOM', json.encode(roomToCache.toJson()));
  }
}



class RoomRepositoryImpl implements RoomRepository {
  final RoomCacheDataSource cacheDataSource;
  final RoomAssetsDataSource assetsDataSource;

  RoomRepositoryImpl({
    @required this.cacheDataSource,
    @required this.assetsDataSource
  });

  @override
  Future<Either<Failure, Room>> getRoom(String name) async {
    //Get the room data from assets
    try {
      final roomToCache = await assetsDataSource.getRoom(name);
      // Remember the room
      cacheDataSource.cacheRoom(roomToCache);
      return Right(roomToCache);
    }
    //If fails to get room data
    on AssetsException {
      return Left(AssetsFailure());
    }
  }
  @override
  Future<Either<Failure, Room>> getLastRoom() async {
    try {
      final cacheRoom = await cacheDataSource.getLastRoom();
      return Right(cacheRoom);
    }
    on CacheException {
      return Left(CacheFailure());
    }
  }
}