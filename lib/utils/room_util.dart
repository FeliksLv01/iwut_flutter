import 'package:iwut_flutter/model/room/building.dart';
import 'package:iwut_flutter/model/room/campus.dart';
import 'package:iwut_flutter/model/room/room_model.dart';

class RoomUtil {
  /// 在特定的时间与校区的条件下，计算出当前可用的楼栋
  static List<Building>? getUsableBuildings(List<RoomData>? origin, WHUTCampus? campus) {
    if (origin == null || campus == null) return null;

    var buildings = Set<Building>();
    origin
        .where((element) => element.region == whutCampusShortTitle(campus))
        .forEach((element) => buildings.add(Building(element.buildingOldName, element.buildingNewName)));
    var buildingList = buildings.toList();
    return buildingList;
  }

  /// 在特定时间、校区与楼栋条件下，筛选出可用的楼层
  static List<int?>? getUsableFloor(List<RoomData>? origin, WHUTCampus? campus, Building? building) {
    if (origin == null || campus == null || building == null) return null;

    var floors = Set<int?>();
    origin
        .where((element) => element.region == whutCampusShortTitle(campus))
        .where((element) => element.buildingNewName == building.newName)
        .forEach((element) => floors.add(element.floor));
    var floorList = floors.toList();
    floorList.sort();

    return floorList;
  }

  /// 在特定时间、校区、楼栋与楼层的条件下，筛选出可用的教室
  static List<int>? getUsableRoom(List<RoomData>? origin, WHUTCampus? campus, Building? building, int? floor) {
    if (origin == null || campus == null || building == null || floor == null) return null;

    var rooms = List<int>.filled(0, 0, growable: true);
    origin
        .where((element) => element.region == whutCampusShortTitle(campus))
        .where((element) => element.buildingNewName == building.newName)
        .where((element) => element.floor == floor)
        .forEach((element) => rooms.add(floor * 100 + element.roomNum!));
    rooms.sort();
    return rooms;
  }
}
