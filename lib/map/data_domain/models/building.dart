import 'package:meta/meta.dart';

//Data Layer - Entity
class Building {
  final String campus;
  final String name;
  final int floors;

  Building({
    @required this.floors,
    @required this.campus,
    @required this.name
  });
}

//Domain Layer - Model
class BuildingModel extends Building {
  BuildingModel({
    @required String name,
    @required String campus,
    @required int floors,
  }):super(name: name,campus: campus,floors: floors);

  /*factory BuildingModel.fromJson(Map<String, dynamic> jsonBuilding) {
    return BuildingModel (floors: jsonBuilding['floors'],campus: jsonBuilding['campus'],name: jsonBuilding['name']);
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "campus": campus,
      "floors": floors,
    };
  }*/
}