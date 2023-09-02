import 'package:flutter/cupertino.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/pages/schedule/widgets/selector/bottom_selector.dart';
import 'package:iwut_flutter/utils/utils.dart';

class WeekScopeSelector extends StatefulWidget {
  final int? weekStart;
  final int? weekEnd;
  final TextEditingController controller;
  WeekScopeSelector(this.weekStart, this.weekEnd, this.controller);

  @override
  _WeekScopeSelectorState createState() => _WeekScopeSelectorState();
}

class _WeekScopeSelectorState extends State<WeekScopeSelector> {
  int? weekStart = 1;
  int? weekEnd = 1;
  FixedExtentScrollController? startController;
  FixedExtentScrollController? endController;

  @override
  void initState() {
    super.initState();
    weekStart = widget.weekStart;
    weekEnd = widget.weekEnd;
    startController = FixedExtentScrollController(initialItem: weekStart! - 1);
    endController = FixedExtentScrollController(initialItem: weekEnd! - weekStart!);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSelector(_buildContent(), () {
      widget.controller.text = "第" + weekStart.toString() + "-" + weekEnd.toString() + "周";
    });
  }

  Widget _buildContent() {
    return Container(
      height: 475.h,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(165.w, 20.h, 170.w, 58.h),
      color: AppColor(context).pickerPanelBGColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildPicker(),
      ),
    );
  }

  List<Widget> _buildPicker() {
    return [
      Expanded(
        child: CupertinoPicker(
          itemExtent: 110.h,
          scrollController: startController,
          useMagnifier: true,
          magnification: 80 / 70,
          children: _buildItems(index: weekStart),
          onSelectedItemChanged: (int index) {
            weekStart = index + 1;
            weekEnd = weekStart;
            endController!.jumpToItem(0);
            setState(() {});
          },
        ),
      ),
      _buildLabel("—"),
      Expanded(
        child: CupertinoPicker(
          itemExtent: 110.h,
          scrollController: endController,
          useMagnifier: true,
          magnification: 80 / 70,
          children: _buildItems(start: weekStart!, index: weekEnd),
          onSelectedItemChanged: (int index) {
            weekEnd = weekStart! + index;
            setState(() {});
          },
        ),
      ),
    ];
  }

  Widget _buildLabel(String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 40.h, 0, 40.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 50.sp,
          color: AppColor(context).element2,
        ),
      ),
    );
  }

  List<Widget> _buildItems({int start = 1, int? index = 1}) {
    List<Widget> list = [];
    for (int i = start; i <= 20; i++) {
      var item = Center(
        child: Text(
          '第$i周',
          style: TextStyle(
            fontSize: 46.sp,
            color: i == index ? AppColor(context).element2 : AppColor(context).element1,
          ),
        ),
      );
      list.add(item);
    }
    return list;
  }
}
