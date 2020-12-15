import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:schedule_dva232/map/core/error/exceptions.dart';
import 'package:schedule_dva232/map/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Domain Layer
abstract class BuildingRepository {
  Future <Either<Failure,Building>> getBuilding(String name);
  Future <Either<Failure,Building>> getLastBuilding();
}

//Data Layer
abstract class BuildingAssetsDataSource {
  Future <BuildingModel> getBuilding(String name);
}

abstract class BuildingCacheDataSource {
  Future <BuildingModel> getLastBuilding();
  Future<void> cacheBuilding(BuildingModel buildingToCache);
}

class BuildingAssetsDataSourceImpl implements BuildingAssetsDataSource {

  @override
  Future<BuildingModel> getBuilding (String name)  async {
    final String buildings = await rootBundle.loadString("assets/buildings_rooms.json");
    Map<String, dynamic> jsonBuildings = json.decode(buildings);
    for (Map<String, dynamic> building in jsonBuildings['buildings']) {
      if (building['name'] == name)  {
        return Future.value(BuildingModel(
            name: building['name'],
            campus: building['campus'],
            floors: building['floors'],
          )
        );
      }
    }
    throw AssetsException();
  }
}

class BuildingCacheDataSourceImpl implements BuildingCacheDataSource {
  final SharedPreferences sharedPreferences;
  BuildingCacheDataSourceImpl({@required this.sharedPreferences});
  @override
  Future<BuildingModel> getLastBuilding() {
    final jsonStringBuilding = sharedPreferences.getString('CACHED_BUILDING');
    if(jsonStringBuilding != null) {
      return Future.value(BuildingModel.fromJson(json.decode(jsonStringBuilding)));
    }
    else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheBuilding(BuildingModel buildingToCache) {
    return sharedPreferences.setString('CACHED_BUILDING', json.encode(buildingToCache.toJson()));
  }
}

class BuildingRepositoryImpl implements BuildingRepository {
  final BuildingCacheDataSource cacheDataSource;
  final BuildingAssetsDataSource assetsDataSource;

  BuildingRepositoryImpl({
    @required this.cacheDataSource,
    @required this.assetsDataSource
  });

  @override
  Future<Either<Failure, Building>> getBuilding(String name) async {
    //Get the building data from assets
    try {
      final buildingToCache = await assetsDataSource.getBuilding(name);
      // Remember the building
      cacheDataSource.cacheBuilding(buildingToCache);
      return Right(buildingToCache);
    }
    //If fails to get building data
    on AssetsException {
      return Left(AssetsFailure());
    }
  }
  @override
  Future<Either<Failure, Building>> getLastBuilding() async {
    try {
      final cacheBuilding = await cacheDataSource.getLastBuilding();
      return Right(cacheBuilding);
    }
    on CacheException {
      return Left(CacheFailure());
    }
  }
}