import 'package:schedule_dva232/map/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/map/data_domain/repositories/building_repository.dart';

class GetBuilding {
  final BuildingRepository  repository;
  GetBuilding (this.repository);

  Future <Either<Failure,Building>> call(String name) async {
    return await repository.getBuilding(name);
  }
}
