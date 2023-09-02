import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/config/log/log.dart';
import 'package:iwut_flutter/pages/room/bottom_selector.dart';
import 'package:iwut_flutter/utils/utils.dart';

class RoomTimeSelector extends StatefulWidget {
  final int minHour;
  final int minMinute;
  final int maxHour;
  final int maxMinute;
  final int? initHour;
  final int? initMinute;
  final Function(int hour, int minute)? onSubmit;

  const RoomTimeSelector(
      {Key? key,
      int? minHour,
      int? minMinute,
      int? maxHour,
      int? maxMinute,
      int? initHour,
      int? initMinute,
      this.onSubmit})
      : this.minHour = minHour == null ? 8 : minHour,
        this.minMinute = minMinute == null ? 0 : minMinute,
        this.maxHour = maxHour == null ? 21 : maxHour,
        this.maxMinute = maxMinute == null ? 25 : maxMinute,
        this.initHour = initHour == null ? minHour : initHour,
        this.initMinute = initMinute == null ? minMinute : initMinute,
        super(key: key);

  @override
  _RoomTimeSelectorState createState() => _RoomTimeSelectorState();
}

class _RoomTimeSelectorState extends State<RoomTimeSelector> {
  int? currentHour;
  int? currentMinute;

  List<int?> usableHours = [];
  List<int?> usableMinutes = [];

  FixedExtentScrollController? hourSC;
  FixedExtentScrollController? minuteSC;

  @override
  void initState() {
    super.initState();
    usableHours = _getUsableHours();
    currentHour = widget.initHour != null ? widget.initHour : usableHours.first;
    usableMinutes = _getUsableMinutes();
    currentMinute = usableMinutes.first;
    hourSC = FixedExtentScrollController();
    minuteSC = FixedExtentScrollController();
    Future.delayed(Duration.zero, () async {
      _initPickerScroll();
    });
  }

  _initPickerScroll() {
    if (widget.initHour == null) return;
    final desHour = widget.initHour;
    final desMinute = widget.initMinute;

    makeScroll(FixedExtentScrollController sc, int index) {
      sc.animateToItem(index, duration: Duration(milliseconds: 200), curve: Curves.linear);
    }

    makeScroll(hourSC!, usableHours.indexOf(desHour));
    Log.debug("$usableMinutes, ${usableMinutes.indexOf(desMinute)}");
    makeScroll(minuteSC!, usableMinutes.indexOf(desMinute));
  }

  @override
  Widget build(BuildContext context) {
    return buildSelector(
      context,
      _buildSelectorContent(),
      () {
        if (widget.onSubmit != null) widget.onSubmit!(currentHour!, currentMinute!);
      },
    );
  }

  /// 构建选择器内容主体（Pickers）
  Widget _buildSelectorContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildPickers(),
    );
  }

  /// 构建上/下午、小时、分钟三个选择器列表
  List<Widget> _buildPickers() {
    return [
      Expanded(
        child: CupertinoPicker(
          itemExtent: 110.h,
          scrollController: hourSC,
          useMagnifier: true,
          magnification: 80 / 70,
          children: usableHours
              .map((e) => Center(
                      child: Text(
                    "${e! < 10 ? '0$e' : '$e'}",
                    style: TextStyle(
                      fontSize: 46.sp,
                      color: currentHour == e ? AppColor(context).element2 : AppColor(context).element1,
                    ),
                  )))
              .toList(),
          onSelectedItemChanged: (int index) {
            currentHour = usableHours[index];
            _onSelectedChange();
          },
        ),
      ),
      _buildLabel(":"),
      Expanded(
        child: CupertinoPicker(
          itemExtent: 110.h,
          scrollController: minuteSC,
          useMagnifier: true,
          magnification: 80 / 70,
          children: usableMinutes
              .map((e) => Center(
                      child: Text(
                    "${e! < 10 ? '0$e' : '$e'}",
                    style: TextStyle(
                      fontSize: 46.sp,
                      color: currentMinute == e ? AppColor(context).element2 : AppColor(context).element1,
                    ),
                  )))
              .toList(),
          onSelectedItemChanged: (int index) {
            currentMinute = usableMinutes[index];
            _onSelectedChange();
          },
        ),
      ),
    ];
  }

  /// 构建时分选择框右上角的时、分提示Label
  Widget _buildLabel(String title) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 46.sp,
          color: AppColor(context).element2,
        ),
      ),
    );
  }

  /// 获取当前可选的小时列表
  List<int?> _getUsableHours() {
    return List.generate(widget.maxHour - widget.minHour + 1, (index) => widget.minHour + index);
  }

  /// 获取当前可选的分钟列表
  List<int?> _getUsableMinutes() {
    if (currentHour == widget.minHour && widget.minHour == widget.maxHour) {
      return List.generate(widget.maxMinute - widget.minMinute + 1, (index) => widget.minMinute + index);
    } else if (currentHour == widget.minHour) {
      return List.generate(60 - widget.minMinute, (index) => widget.minMinute + index);
    } else if (currentHour == widget.maxHour) {
      return List.generate(widget.maxMinute + 1, (index) => index);
    } else {
      return List.generate(60, (index) => index);
    }
  }

  /// 当选择器中的任意一项发生变化都会调用该方法
  _onSelectedChange() {
    // 更新可用的小时与分钟
    final newHours = _getUsableHours();
    final newMinutes = _getUsableMinutes();

    if (!ListEquality().equals(newHours, usableHours)) {
      currentHour = newHours.first;
      hourSC!.animateToItem(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
      usableHours = newHours;
    }
    if (!ListEquality().equals(newMinutes, usableMinutes)) {
      usableMinutes = _getUsableMinutes();
      currentMinute = newMinutes.first;
      minuteSC!.animateToItem(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
    }
    setState(() {});
  }
}
