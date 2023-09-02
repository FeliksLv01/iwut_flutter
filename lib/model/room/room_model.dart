
class RoomResponse {
  RoomResponse({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  List<RoomData>? data;

  factory RoomResponse.fromJson(Map<String, dynamic> json) => RoomResponse(
    code: json["code"],
    message: json["message"],
    data: List<RoomData>.from(json["data"].map((x) => RoomData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class RoomData {
  RoomData({
    this.id,
    this.region,
    this.buildingOldName,
    this.buildingNewName,
    this.floor,
    this.roomNum,
    this.fullName,
    this.enabled,
  });

  int? id;
  String? region;
  String? buildingOldName;
  String? buildingNewName;
  int? floor;
  int? roomNum;
  String? fullName;
  bool? enabled;

  factory RoomData.fromJson(Map<String, dynamic> json) => RoomData(
    id: json["id"],
    region: json["region"],
    buildingOldName: json["buildingOldName"],
    buildingNewName: json["buildingNewName"],
    floor: json["floor"],
    roomNum: json["roomNum"],
    fullName: json["fullName"],
    enabled: json["enabled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "region": region,
    "buildingOldName": buildingOldName,
    "buildingNewName": buildingNewName,
    "floor": floor,
    "roomNum": roomNum,
    "fullName": fullName,
    "enabled": enabled,
  };

  bool operator==(other) {
    if(other is! RoomData) {return false;}

    final RoomData room = other;
    return room.region == this.region &&
        room.buildingNewName == this.buildingNewName &&
        room.buildingOldName == this.buildingOldName &&
        room.floor == this.floor &&
        room.roomNum == this.roomNum;
  }
  @override
  int get hashCode {
    return "$region$fullName$floor$roomNum".hashCode;
  }

  @override
  String toString() {
    return 'RoomData{region: $region, buildingOldName: $buildingOldName, buildingNewName: $buildingNewName, floor: $floor, roomNum: $roomNum, fullName: $fullName}';
  }



}