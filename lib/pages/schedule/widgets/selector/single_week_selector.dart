import 'package:flutter/cupertino.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/pages/schedule/widgets/selector/bottom_selector.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

/// appBar上的周数选择器
class SingleWeekSelector extends StatefulWidget {
  final int? weekIndex;
  final int? reallyWeekIndex;
  const SingleWeekSelector({Key? key, this.weekIndex, this.reallyWeekIndex}) : super(key: key);

  @override
  _SingleWeekSelectorState createState() => _SingleWeekSelectorState();
}

class _SingleWeekSelectorState extends State<SingleWeekSelector> {
  int? index;
  int? reallyWeekIndex;
  FixedExtentScrollController? sc;

  @override
  void initState() {
    super.initState();

    sc = FixedExtentScrollController();
    if (widget.weekIndex != null) {
      index = widget.weekIndex;
      reallyWeekIndex = widget.reallyWeekIndex;
      Future.delayed(Duration(seconds: 0), () {
        sc!.jumpToItem(index! - 1);
      });
    } else {
      index = 1;
      reallyWeekIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CourseProvider>(context);
    return BottomSelector(_buildContent(), () {
      provider.weekIndex = index;
    });
  }

  Widget _buildContent() {
    return Container(
      height: 475.h,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(165.w, 20.h, 170.w, 58.h),
      color: AppColor(context).pickerPanelBGColor,
      child: CupertinoPicker(
        itemExtent: 110.h,
        scrollController: sc,
        useMagnifier: true,
        magnification: 52 / 46,
        children: _buildItems(),
        onSelectedItemChanged: (value) {
          index = value + 1;
          setState(() {});
        },
      ),
    );
  }

  List<Widget> _buildItems() {
    List<Widget> items = [];
    for (int i = 1; i <= 20; i++) {
      Center item = Center(
        child: Text(
          i == reallyWeekIndex ? "第$i周(本周)" : "第$i周",
          style: TextStyle(
            fontSize: 46.sp,
            color: i == index ? AppColor(context).element2 : AppColor(context).element1,
          ),
        ),
      );
      items.add(item);
    }
    return items;
  }
}
