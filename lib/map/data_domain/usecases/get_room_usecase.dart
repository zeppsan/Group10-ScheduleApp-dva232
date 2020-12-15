import 'package:schedule_dva232/map/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/map/data_domain/repositories/room_repository.dart';

class GetRoom {
  final RoomRepository  repository;
  GetRoom (this.repository);

  Future <Either<Failure,Room>> call(String name) async {
    return await repository.getRoom(name);
  }
}
