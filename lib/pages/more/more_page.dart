import 'dart:io';
import 'dart:math';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/config/icon_font.dart';
import 'package:iwut_flutter/global.dart';
import 'package:iwut_flutter/pages/more/widgets/more_card.dart';
import 'package:iwut_flutter/pages/more/widgets/more_dialog.dart';
import 'package:iwut_flutter/pages/more/widgets/theme_card.dart';
import 'package:iwut_flutter/pages/schedule/widgets/dialog/delete_dialog.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/provider/message_provider.dart';
import 'package:iwut_flutter/provider/theme_provider.dart';
import 'package:iwut_flutter/provider/transparent_provider.dart';
import 'package:iwut_flutter/routers/navigator.dart';
import 'package:iwut_flutter/service/database_service.dart';
// import 'package:iwut_flutter/utils/debug_util.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:iwut_flutter/widgets/my_behavior.dart';
import 'package:iwut_flutter/widgets/my_scroll_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/more_badge_card.dart';

class MorePage extends StatefulWidget {
  MorePage({Key? key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    var messageProvider = Provider.of<MessageProvider>(context);
    return Scaffold(
      appBar: _buildAppBar() as PreferredSizeWidget?,
      backgroundColor: AppColor(context).moreBGColor,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: MyScrollView(
          children: [
            Visibility(
              visible: messageProvider.activityMessage,
              child: MoreCard(
                iconData: Icons.celebration,
                title: messageProvider.pushInfo?.content ?? '',
                onTap: () => IwutNavigator.goWebView(context, messageProvider.pushInfo?.getActivityUrl() ?? ''),
                showNext: true,
                isActivity: true,
              ),
            ),
            ThemeCard(),
            MoreCard(
              iconData: IconFont.delete,
              title: '清除课表',
              onTap: () => deleteCourse(),
            ),
            MoreCard(
              iconData: IconFont.image,
              title: '更换背景',
              onTap: () => changeBackgroundImage(),
            ),
            MoreCard(
              iconData: IconFont.book_reader,
              title: '自习室',
              onTap: () => IwutNavigator.goRoomPage(context),
              showNext: true,
            ),
            // MoreCard(
            //   imagePath: ImagePath.NEWS_ICON,
            //   title: '理工资讯',
            //   onTap: () => IwutNavigator.go(context, Routes.news),
            //   showNext: true,
            // ),
            MoreCard(
              iconData: Icons.wifi,
              title: '校园网登录',
              onTap: () => IwutNavigator.goWifiLogin(context),
              showNext: true,
            ),
            // MoreBadgeCard(
            //   Icon(IconFont.planet, size: 70.sp, color: AppColor(context).element2),
            //   '关于Token团队',
            //   () => IwutNavigator.goWebView(context, 'https://itoken.team/', title: 'Token团队'),
            //   showNext: true,
            // ),
            MoreBadgeCard(
              badges.Badge(
                padding: EdgeInsets.all(2),
                position: badges.BadgePosition(top: -8, end: -1),
                showBadge: messageProvider.versionMessage || Global.isFirstOpen,
                badgeContent: Text(' '),
                child: Icon(
                  IconFont.about1,
                  color: AppColor(context).element2,
                ),
              ),
              messageProvider.versionMessage ? '可更新至最新版本' : '当前已是最新版本～',
              messageProvider.versionMessage
                  ? () {
                      showIwutDialog(
                          context: context,
                          routeSettings: RouteSettings(name: 'updateVersion'),
                          builder: (context) {
                            return MoreDialog(
                              "检测到新版本，确定要更新吗?",
                              () => launch(messageProvider.updateInfo!.updateUrl!),
                              title: '版本更新',
                              cancelStyle: TextStyle(color: Colors.grey),
                              sureStyle: TextStyle(color: Colors.blueAccent),
                            );
                          });
                    }
                  : () {
                      setState(() {
                        Global.isFirstOpen = false;
                        messageProvider.minusMessage();
                      });
                      showToast('当前版本：${Global.currentVersion}');
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColor(context).appBarBgColor,
      title: GestureDetector(
        onTap: () {
          // count++;
          // if (count == 5) {
          //   count = 0;
          //   Global.openDialogObserver = !Global.openDialogObserver;
          //   showToast('${Global.openDialogObserver ? '开启' : '关闭'}弹窗log');
          // }
        },
        child: Text(
          '更多',
          style: TextStyle(
            color: AppColor(context).moreText,
            fontSize: 57.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      elevation: 2,
      leading: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(Icons.arrow_back_ios, color: AppColor(context).element2),
        onPressed: () => IwutNavigator.goBack(context),
      ),
      actions: [
        Consumer<ThemeProvider>(builder: (context, model, _) {
          var iconData = IconFont.sun;
          if (model.theme == AppTheme.Dark) {
            iconData = IconFont.moon;
          } else if (model.theme == AppTheme.System && (Theme.of(context).brightness == Brightness.dark)) {
            iconData = IconFont.moon;
          }
          return IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(iconData, color: AppColor(context).element2),
              onPressed: () {
                if (model.theme == AppTheme.Dark) {
                  model.updateTheme(AppTheme.Bright);
                } else if (model.theme == AppTheme.Bright) {
                  model.updateTheme(AppTheme.Dark);
                } else if (model.theme == AppTheme.System) {
                  if (Theme.of(context).brightness == Brightness.dark) {
                    model.updateTheme(AppTheme.Bright);
                  } else {
                    model.updateTheme(AppTheme.Dark);
                  }
                }
              });
        })
      ],
    );
  }

  deleteCourse() {
    showIwutDialog(
        context: context,
        routeSettings: RouteSettings(name: 'deleteAllCoursesDialog'),
        builder: (context) {
          return DeleteDialog(
            () async {
              var dao = await dbService.getCourseDao();
              dao.deleteAll();
              Provider.of<CourseProvider>(context, listen: false).updateCourses([]);
              HomeWidgetUtil.updateWidget(name: "widget.CourseWidgetProvider");
              // 重新导入后，周一周二课表消失
              var scrollProvider = Provider.of<TransparentProvider>(context, listen: false);
              scrollProvider.alphaMonday = 1;
              scrollProvider.alphaTuesday = 1;
            },
            content: '确定要删除课表数据吗？',
          );
        });
  }

  changeBackgroundImage() {
    showCupertinoModalPopup(
      context: context,
      routeSettings: RouteSettings(name: 'ChangeBGImageSheet'),
      builder: (context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            //操作按钮集合
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _selectBackgroundImage();
              },
              child: Text('更换背景', style: TextStyle(fontSize: 45.sp)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _resetBackground();
              },
              child: Text('恢复默认背景', style: TextStyle(fontSize: 45.sp)),
            ),
          ],
        );
      },
    );
  }

  _resetBackground() {
    var courseProvider = Provider.of<CourseProvider>(context, listen: false);
    courseProvider.deleteBGImage();
    StorageUtil().deleteBackGround();
  }

  _selectBackgroundImage() async {
    PickedFile? image = await ImagePicker().getImage(source: ImageSource.gallery);
    // 没有选取任何图片
    if (image == null) {
      return null;
    } else {
      var file = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1080, ratioY: 1920),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '图片裁剪',
            toolbarColor: Color.fromARGB(255, 69, 200, 220),
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Color.fromARGB(255, 69, 200, 220),
          )
        ],
      );
      if (file == null) return;
      var courseProvider = Provider.of<CourseProvider>(context, listen: false);
      int num = Random().nextInt(1000);
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      String fileName = '$path/background_$num.jpg';
      final File fileTemp = File(file.path);
      await fileTemp.copy(fileName);
      StorageUtil().setBackgroundImage(fileName);
      courseProvider.setBGImage(fileName);
    }
  }
}
