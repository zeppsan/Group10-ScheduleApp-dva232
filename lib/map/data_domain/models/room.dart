
import 'package:meta/meta.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/map/data_domain/models/coordinates.dart';

import 'building.dart';

class Room {
  final Building building;
  final String name;
  final int floor;
  final Coordinates position;
  final List<Coordinates> path;

  Room({
    @required this.building,
    @required this.name,
    @required this.floor,
    @required this.position,
    @required this.path,
  });
}


