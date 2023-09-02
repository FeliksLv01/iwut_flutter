import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/model/room/building.dart';
import 'package:iwut_flutter/provider/room_provider.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class RoomPickerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<RoomProvider>(
        builder: (context, vm, child) => _buildListContent(vm)!,
      ),
    );
  }

  Widget? _buildListContent(RoomProvider vm) {
    final stage = vm.curStage;
    if (stage == 5) {
      return _buildBuildingList(vm);
    } else if (stage == 6) {
      return _buildFloorList(vm);
    } else if (stage == 7) {
      return _buildRoomList(vm);
    }

    return null;
  }

  /// 选择楼栋列表
  Widget _buildBuildingList(RoomProvider vm) {
    final itemCount = vm.buildings?.length ?? 0;
    return ListView.builder(
        itemCount: itemCount == 0 ? 1 : itemCount,
        itemBuilder: (BuildContext context, int index) {
          if (itemCount == 0) {
            return _buildListItem(context, "这里没有发现可以使用的自习室哦");
          } else {
            return _buildAccessibleListItem(
                context, buildingToTitle(vm.buildings![index]), () => vm.updateBuilding(vm.buildings![index]));
          }
        });
  }

  /// 选择楼层列表
  Widget _buildFloorList(RoomProvider vm) {
    final itemCount = vm.floors?.length ?? 0;
    return ListView.builder(
        itemCount: itemCount == 0 ? 1 : itemCount,
        itemBuilder: (BuildContext context, int index) {
          if (itemCount == 0) {
            return _buildListItem(context, "这里没有发现可以使用的自习室哦");
          } else {
            return _buildAccessibleListItem(context, "${vm.floors![index]}楼", () => vm.updateFloor(vm.floors![index]));
          }
        });
  }

  /// 显示教室列表
  Widget _buildRoomList(RoomProvider vm) {
    final itemCount = vm.rooms?.length ?? 0;
    return ListView.builder(
      itemCount: itemCount == 0 ? 1 : itemCount,
      itemBuilder: (BuildContext context, int index) {
        if (itemCount == 0) {
          return _buildListItem(context, "没有可用教室");
        } else {
          return _buildListItem(context, "${vm.rooms![index]}");
        }
      },
    );
  }

  Widget _buildAccessibleListItem(BuildContext context, String title, Function() action,
      {IconData icon = Icons.chevron_right}) {
    return GestureDetector(
      onTap: action,
      child: _buildListItem(context, title, icon: icon),
    );
  }

  Widget _buildListItem(BuildContext context, String title, {IconData? icon}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w).add(EdgeInsets.only(top: 20.h)),
      height: 176.h,
      width: double.infinity,
      decoration: BoxDecoration(color: AppColor(context).pickerPanelBGColor, borderRadius: BorderRadius.circular(23.w)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 72.w),
            child: Text(
              title,
              style: TextStyle(fontSize: 46.sp, color: AppColor(context).element5),
            ),
          ),
          icon != null
              ? Container(
                  margin: EdgeInsets.only(right: 78.w),
                  child: Icon(
                    icon,
                    size: 75.sp,
                    color: AppColor(context).element6,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
