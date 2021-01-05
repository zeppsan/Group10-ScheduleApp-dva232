import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:schedule_dva232/map/core/error/exceptions.dart';
import 'package:schedule_dva232/map/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';

//Domain Layer
abstract class BuildingRepository {
  Future <Either<Failure,Building>> getBuilding(String name);
}

//Data Layer
abstract class BuildingAssetsDataSource {
  Future <Building> getBuilding(String name);
}

// Data source implementation
class BuildingAssetsDataSourceImpl implements BuildingAssetsDataSource {
  @override
  Future<Building> getBuilding (String name)  async {
    // read the json source file
    final String buildings = await rootBundle.loadString("assets/buildings_rooms.json");
    Map<String, dynamic> jsonBuildings = json.decode(buildings);
    for (Map<String, dynamic> building in jsonBuildings['buildings']) {
      if (building['name'] == name)  { // if building is found
        return Future.value(Building(
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

//Building Repository Implementation
class BuildingRepositoryImpl implements BuildingRepository {
  final BuildingAssetsDataSource assetsDataSource;

  BuildingRepositoryImpl({
    @required this.assetsDataSource
  });

  @override
  Future<Either<Failure, Building>> getBuilding(String name) async {
    //Get the building data from assets
    try {
      final building = await assetsDataSource.getBuilding(name);
      return Right(building);
    }
    //If fails to get building
    on AssetsException {
      return Left(AssetsFailure());
    }
  }
}