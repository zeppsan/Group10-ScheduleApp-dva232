import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';

import 'building.dart';

class Room {
  final Building building;
  final String name;
  final int floor;
  final LatLng position;

  Room({
    @required this.building,
    @required this.name,
    @required this.floor,
    @required this.position,
  });
}
  class RoomModel extends Room {
    RoomModel({
      @required Building building,
      @required String name,
      @required int floor,
      @required LatLng position,
    }) :super(name: name, floor: floor, position: position, building: building );

    Map<String, dynamic> toJson() {
      return {
        "name": name,
        "floor": floor,
        "position": {
          "lat": position.latitude,
          "lng": position.longitude
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
          floor: jsonRoom ['floor'],
          position: LatLng(
              jsonRoom['position']['lat'], jsonRoom['position']['lng']));
    }
  }