
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';


class MapBuildingWidget extends StatelessWidget {
  final Building building;
  final Room room;
  final int floor;
  final bool showCoordinates;

  MapBuildingWidget({ Key key, this.building, this.room, this.floor, this.showCoordinates})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('pixel ratio:');
    if(room!=null){
    print(room.position.latitude);
    print(room.position.longitude);
    print (showCoordinates);}
    return FlutterMap(
      options: MapOptions(
        minZoom: 1,
        maxZoom: 4,
        controller: MapController(),
        zoom: 1,
        crs: CrsSimple(),
        //swPanBoundary: setSWPanBoundary(currentZoom),
        //nePanBoundary: setNEPanBoundary(currentZoom),
        swPanBoundary: LatLng(-1, 0),
        nePanBoundary: LatLng(0, 1),
        center: LatLng(-0.5, 0.5),
      ),

      children: <Widget>[
        TileLayerWidget(options: TileLayerOptions(
          backgroundColor: Colors.white,
          //maxNativeZoom: 4,
          tileProvider: AssetTileProvider(),
          urlTemplate: 'assets/maps/${building.campus}/${building.name}/$floor/{z}_{x}_{y}.png'
        )),
        if (showCoordinates) MarkerLayerWidget(
          options: MarkerLayerOptions(
            markers: [
              Marker(
                width: 30.0,
                height: 30.0,
                point: room.position,
                builder: (context) =>
                  Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 36.0,
                    ),
                  ),
              ),
            ],
          ),
        ),
      ]    );
  }
}
  









