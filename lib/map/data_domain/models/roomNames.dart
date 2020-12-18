class RoomNames {
  String name;

  RoomNames({this.name});

  factory RoomNames.fromJson(Map<String, dynamic> jsonRoomList) {
    return RoomNames(
        name: jsonRoomList ['name'],
    );
  }

  Map toJson() => {
    'name': name,
  };
}