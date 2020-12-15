import 'package:schedule_dva232/map/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/map/data_domain/repositories/building_repository.dart';
import 'get_building_usecase.dart';

class GetLastBuilding {
  final BuildingRepository repository;
  GetLastBuilding(this.repository);

  Future<Either<Failure, Building>> call() async {
    return await repository.getLastBuilding();
  }
}