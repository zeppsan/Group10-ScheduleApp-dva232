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
}

//Data Layer
abstract class BuildingAssetsDataSource {
  Future <BuildingModel> getBuilding(String name);
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


class BuildingRepositoryImpl implements BuildingRepository {
  final BuildingAssetsDataSource assetsDataSource;

  BuildingRepositoryImpl({
    @required this.assetsDataSource
  });

  @override
  Future<Either<Failure, Building>> getBuilding(String name) async {
    //Get the building data from assets
    try {
      final buildingToCache = await assetsDataSource.getBuilding(name);
      return Right(buildingToCache);
    }
    //If fails to get building data
    on AssetsException {
      return Left(AssetsFailure());
    }
  }

}