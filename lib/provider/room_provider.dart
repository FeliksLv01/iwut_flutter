import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:iwut_flutter/extensions/extensions.dart';
import 'package:iwut_flutter/model/room/building.dart';
import 'package:iwut_flutter/model/room/campus.dart';
import 'package:iwut_flutter/model/room/room_model.dart';
import 'package:iwut_flutter/service/room_service.dart';
import 'package:iwut_flutter/utils/course_util.dart';
import 'package:iwut_flutter/utils/room_util.dart';

class RoomProvider extends ChangeNotifier {
  /// 当前被激活的选择器
  int? _activeSelector;

  /// 当前选择的校区
  WHUTCampus? _curCampus;

  /// 当前选择的楼栋
  Building? _curBuilding;

  /// 当前选择的楼层
  int? _curFloor;

  /// 当前选择的自习开始时间
  int? _startHour;
  int? _startMinute;

  /// 自习结束时间
  int? _endHour;
  int? _endMinute;

  /// 页面是否正在加载数据
  bool? _isLoading;

  /// 是否有加载错误
  String? _loadingError;

  /// 网络请求返回的原始数据
  List<RoomData>? _rawRoomData;

  /// 在当前的条件下（特定校区，特定时间）可用的楼栋列表
  List<Building>? _buildings;

  /// 在当前条件下可用的楼层列表
  List<int?>? _floors;

  /// 在当前条件下可用的教室列表
  List<int>? _rooms;

  /// 一系列的Getter与Setter
  int? get activeSelector => _activeSelector;
  WHUTCampus? get curCampus => _curCampus;
  Building? get curBuilding => _curBuilding;
  int? get curFloor => _curFloor;
  int? get startHour => _startHour;
  int? get startMinute => _startMinute;
  int? get endHour => _endHour;
  int? get endMinute => _endMinute;
  bool? get isLoading => _isLoading;
  String? get loadingError => _loadingError;
  bool get dataReady => _rawRoomData != null;
  List<Building>? get buildings => _buildings;
  List<int?>? get floors => _floors;
  List<int>? get rooms => _rooms;

  set curFloor(int? value) => _notify(() => _curFloor = value);
  set activeSelector(int? value) => _notify(() => _activeSelector = value);
  set buildings(List<Building>? value) => _notify(() => _buildings = value);
  set rooms(List<int>? value) => _notify(() => _rooms = value);
  set floors(List<int?>? value) => _notify(() => _floors = value);
  set rawRoomData(List<RoomData>? value) => _notify(() => _rawRoomData = value);
  set isLoading(bool? value) => _notify(() => _isLoading = value);
  set loadingError(String? value) => _notify(() => _loadingError = value);
  set curBuilding(Building? value) => _notify(() => _curBuilding = value);
  set curCampus(WHUTCampus? value) => _notify(() => _curCampus = value);

  /// 计算当前自习室页面应当处于的状态
  /// 0：代表选择器还未就绪，用户还未完成时间或者校区的信息
  /// 1：代表页面从服务器加载自习室数据
  /// 2：代表由于网络加载出现错误
  /// 3：代表由于未知的原因，当前的自习室数据为空，需要重新加载
  /// 4：代表未知错误，理论上是不应该出现的，如果出现说明代码逻辑出现了问题
  /// 5：代表当前处于选择楼栋的阶段
  /// 6：代表当前处于选择楼层的阶段
  /// 7：代表当前处于展示可用教室的阶段
  int get curStage {
    if (!selectorReady) {
      return 0;
    } else if (isLoading!) {
      return 1;
    } else if (loadingError != null) {
      return 2;
    } else if (_rawRoomData == null) {
      return 3;
    } else if (curBuilding == null && buildings != null) {
      return 5;
    } else if (curFloor == null && floors != null) {
      return 6;
    } else if (rooms != null) {
      return 7;
    } else {
      return 4;
    }
  }

  /// 点击返回按钮之后，回退选择层级
  /// 返回false代表已经处于顶层，无法再回退
  /// 返回true代表层级回退成功
  bool backUp() {
    if (curBuilding == null) {
      return false;
    } else if (curFloor == null) {
      curBuilding = null;
      floors = null;
      rooms = null;
      return true;
    } else {
      curFloor = null;
      rooms = null;
      return true;
    }
  }

  initEndTime() {
    if (_startHour != null && _startMinute != null) {
      _endHour = _startHour;
      _endMinute = _startMinute;
    }
  }

  /// 修改当前所选择的楼层
  updateFloor(int? floor) {
    curFloor = floor;
    rooms = RoomUtil.getUsableRoom(_rawRoomData, _curCampus, _curBuilding, _curFloor);
  }

  /// 修改当前所选择的楼栋
  updateBuilding(Building building) {
    curBuilding = building;
    floors = RoomUtil.getUsableFloor(_rawRoomData, curCampus, building);
  }

  /// 修改当前的校区
  updateCampus(WHUTCampus campus) {
    curCampus = campus;
    curBuilding = null;
    curFloor = null;
    buildings = null;
    floors = null;
    rooms = null;
    if (selectorReady && _rawRoomData == null) {
      loadRoomData();
    } else if (selectorReady && _rawRoomData != null) {
      buildings = RoomUtil.getUsableBuildings(_rawRoomData, campus);
    }
  }

  /// 更新开始自习的时间
  updateStartTime(int hour, int minute) {
    // 如果开始自习的时间要更晚于结束的时间，那么就更新结束的时间，使其等于开始时间
    if (_endHour != null && _endMinute != null && (hour > _endHour! || (hour == _endHour && minute > _endMinute!))) {
      _endHour = hour;
      _endMinute = minute;
    }
    // 如果更改后的时间归属的大节与之前的一致，就没必要再次进行请求
    final oldSections = CourseUtil.getBigSections(_startHour, _startMinute, _endHour, _endMinute);
    final newSections = CourseUtil.getBigSections(hour, minute, _endHour, _endMinute);
    _startHour = hour;
    _startMinute = minute;
    notifyListeners();

    if (selectorReady && (oldSections == null || !ListEquality().equals(oldSections, newSections))) loadRoomData();
  }

  /// 更新结束自习的时间
  updateEndTime(int hour, int minute) {
    // 如果结束自习的时间要更早于开始的时间，那么就更新开始的时间，使其等于结束的时间
    if (_startHour != null && _startMinute != null && (hour < _startHour! || (hour == _startHour && minute < _startMinute!))) {
      _startHour = hour;
      _startMinute = minute;
    }
    // 如果更改后的时间归属的大节与之前的一致，就没必要再次进行请求
    final oldSections = CourseUtil.getBigSections(_startHour, _startMinute, _endHour, _endMinute);
    final newSections = CourseUtil.getBigSections(_startHour, _startMinute, hour, minute);
    _endHour = hour;
    _endMinute = minute;
    notifyListeners();

    if (selectorReady && (oldSections == null || !ListEquality().equals(oldSections, newSections))) loadRoomData();
  }

  void _notify(Function() action) {
    action();
    notifyListeners();
  }

  /// 开始时间的文字
  String get startTimeText {
    if (_startHour != null && _startMinute != null) {
      return "${_startHour!.length2Str}:${_startMinute!.length2Str}";
    } else {
      return "开始时间";
    }
  }

  /// 结束时间的文字
  String get endTimeText {
    if (_endHour != null && _endMinute != null) {
      return "${_endHour!.length2Str}:${_endMinute!.length2Str}";
    } else {
      return "结束时间";
    }
  }

  /// 选择器是否已经就绪，如果校区，开始时间，结束时间全部都设置好，就说明选择器已经就绪
  bool get selectorReady {
    return _endHour != null && _endMinute != null && _startHour != null && _startMinute != null && _curCampus != null;
  }

  /// 重新加载并刷新自习室的数据
  loadRoomData() async {
    loadingError = null;
    isLoading = true;
    rawRoomData = null;
    buildings = null;
    curBuilding = null;
    curFloor = null;
    rooms = null;

    var sections = CourseUtil.getBigSections(startHour, startMinute, endHour, endMinute);
    // 如果sections为空，就说明没有查找到时间段内包含的课程，传入0获取所有课程
    if (sections == null || sections.isEmpty) sections = [0];
    await RoomService.getRoomList(sections, (list) {
      rawRoomData = list as List<RoomData>?;
      buildings = RoomUtil.getUsableBuildings(list, curCampus);
    }, (message) {
      loadingError = message;
      rawRoomData = null;
      buildings = null;
      rooms = null;
    });
    isLoading = false;
  }
}
