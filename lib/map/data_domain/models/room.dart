
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
  class RoomModel extends Room {
    RoomModel({
      @required Building building,
      @required String name,
      @required int floor,
      @required Coordinates position,
      @required List<Coordinates> path,
    }) :super(name: name, floor: floor, position: position, building: building, path: path );

   /* Map<String, dynamic> toJson() {
      return {
        "name": name,
        "path": path,
        "floor": floor,
        "position": {
          "x": position.x,
          "y": position.y
        },
        "building_name": building.name,
        "building_campus": building.campus,
        "building_floors": building.floors
      };
    }

    factory RoomModel.fromJson(Map<String, dynamic> jsonRoom) {
      return RoomModel(
          building: Building(
            floors:jsonRoom['building_floors'],
            campus:jsonRoom['building_campus'],
            name:jsonRoom['building_name']),
          name: jsonRoom ['name'],
          path: jsonRoom ['path'],
          floor: jsonRoom ['floor'],
          position: Coordinates(
             x: jsonRoom['position']['x'], y: jsonRoom['position']['y']));
    }*/
  }