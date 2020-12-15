import 'package:schedule_dva232/map/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/map/data_domain/repositories/room_repository.dart';

class GetLastRoom {
  final RoomRepository repository;
  GetLastRoom(this.repository);

  Future<Either<Failure, Room>> call() async {
    return await repository.getLastRoom();
  }
}