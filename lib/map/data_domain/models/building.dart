import 'package:meta/meta.dart';

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