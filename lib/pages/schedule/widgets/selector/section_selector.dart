import 'package:flutter/cupertino.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/utils/utils.dart';

import 'bottom_selector.dart';

class SectionSelector extends StatefulWidget {
  final String initStr;
  final List<String>? sectionList;
  final TextEditingController controller;
  SectionSelector(this.initStr, this.sectionList, this.controller);

  @override
  _SectionSelectorState createState() => _SectionSelectorState();
}

class _SectionSelectorState extends State<SectionSelector> {
  int? index;
  FixedExtentScrollController? sc;

  @override
  void initState() {
    super.initState();
    sc = FixedExtentScrollController();
    for (int i = 0; i < widget.sectionList!.length; i++) {
      if (widget.sectionList![i] == widget.initStr) {
        index = i;
      }
    }
    Future.delayed(Duration(seconds: 0), () {
      sc!.jumpToItem(index!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSelector(_buildContent(), () {
      widget.controller.text = widget.sectionList![index!];
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
          index = value;
          setState(() {});
        },
      ),
    );
  }

  List<Widget> _buildItems() {
    List<Widget> items = [];
    List<String> sectionList = widget.sectionList!;
    for (int i = 0; i < sectionList.length; i++) {
      Center item = Center(
        child: Text(
          sectionList[i],
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
