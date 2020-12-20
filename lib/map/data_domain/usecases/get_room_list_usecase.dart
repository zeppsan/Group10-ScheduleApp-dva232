import 'package:schedule_dva232/map/data_domain/repositories/room_repository.dart';

class GetRoomList {
  final RoomRepository  repository;
  GetRoomList (this.repository);

  Future <List<String>> call() async {
    return await repository.getRoomList();
  }
}