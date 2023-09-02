import 'package:flutter/cupertino.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/model/room/campus.dart';
import 'package:iwut_flutter/pages/room/bottom_selector.dart';
import 'package:iwut_flutter/utils/utils.dart';

class RoomCampusSelector extends StatefulWidget {
  final Function(WHUTCampus)? onSubmit;
  final WHUTCampus? initCampus;

  const RoomCampusSelector({Key? key, this.onSubmit, this.initCampus}) : super(key: key);

  @override
  _RoomCampusSelectorState createState() => _RoomCampusSelectorState();
}

class _RoomCampusSelectorState extends State<RoomCampusSelector> {
  late WHUTCampus curCampus;
  FixedExtentScrollController? sc;

  @override
  void initState() {
    super.initState();

    sc = FixedExtentScrollController();
    if (widget.initCampus != null) {
      final index = WHUTCampus.values.indexOf(widget.initCampus!);
      curCampus = widget.initCampus!;
      Future.delayed(Duration(seconds: 0), () {
        sc!.animateToItem(index, duration: Duration(milliseconds: 200), curve: Curves.linear);
      });
    } else {
      curCampus = WHUTCampus.values.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildSelector(context, _buildSelectorContent(), () {
      if (widget.onSubmit != null) widget.onSubmit!(curCampus);
    });
  }

  /// 构建选择器主体内容
  Widget _buildSelectorContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: CupertinoPicker(
            itemExtent: 90.h,
            scrollController: sc,
            useMagnifier: true,
            magnification: 52 / 46,
            children: WHUTCampus.values
                .map(
                  (e) => Center(
                    child: Text(
                      whutCampusFullTitle(e),
                      style: TextStyle(
                        fontSize: 46.sp,
                        color: curCampus == e ? AppColor(context).element2 : AppColor(context).element1,
                      ),
                    ),
                  ),
                )
                .toList(),
            onSelectedItemChanged: (int index) {
              curCampus = WHUTCampus.values[index];
              setState(() {});
            },
          ),
        )
      ],
    );
  }
}
