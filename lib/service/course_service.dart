import 'package:dio/dio.dart';
import 'package:iwut_flutter/config/log/log.dart';
import 'package:iwut_flutter/dao/course_dao.dart';
import 'package:iwut_flutter/http/http_request.dart';
import 'package:iwut_flutter/http/mock_request.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/model/course/course_model.dart';
import 'package:iwut_flutter/model/time.dart';
import 'package:iwut_flutter/utils/utils.dart';

import 'database_service.dart';

class CourseService {
  static Future getCourseListByHtml(String html, OnSuccess onSuccess, OnFail onFail) async {
    try {
      List<dynamic>? responseList = [];
      // ignore: unused_local_variable
      FormData formData = FormData.fromMap({'html': html});
      var response = await MockRequest.post(action: 'course');
      //var response = await HttpRequest.instance!.formDataPost(ServerUrl.UPLOAD_HTML_URL, formData: formData);
      if (response['code'] == 0) {
        responseList = response['data'];
        CourseListModel courseListModel = CourseListModel.fromJson(responseList!);
        List<Course> modelList = CourseUtil.typeChange(courseListModel.courseList);
        modelList = CourseUtil.colorAllocate(modelList);
        CourseDao dao = await dbService.getCourseDao();
        dao.insertCourses(modelList);
        HomeWidgetUtil.updateWidget(name: "widget.CourseWidgetProvider");
        onSuccess(modelList);
      } else {
        onFail(response['message']);
        Log.error("课表解析失败 ${response}", tag: "网络");
      }
    } catch (e) {
      Log.error(e.toString(), tag: '网络');
      onFail("请求网络数据异常");
    }
  }

  static Future getTime(OnSuccess onSuccess, OnFail onFail) async {
    try {
      // Mock
      Time time = new Time(week: 1, monday: null, termStart: DateTime(2021, 8, 30));
      StorageUtil().setTermStart(time.termStart.toString());
      onSuccess(time);
      // var response = await HttpRequest.instance!.get(ServerUrl.TIME_INFO);
      // if (response['code'] == 0) {
      //   Time time = Time.fromJson(response['data']['time']);
      //   // 存储开学时间
      //   StorageUtil().setTermStart(time.termStart.toString());
      //   onSuccess(time);
      // } else {
      //   onFail(response['message']);
      // }
    } catch (e) {
      Log.error(e.toString(), tag: '网络');
      onFail("请求网络数据异常");
    }
  }
}
