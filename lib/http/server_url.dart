/*
 * @Author: FeliksLv 
 * @Date: 2020-08-16 18:02:23 
 * @Last Modified by: FeliksLv
 * @Last Modified time: 2021-05-12 14:48:32
 * @Message 服务端接口地址
 */

class ServerUrl {
  static const String BASE_URL = "";

  static const String TEST_BASE_URL = "";

  /// 推送测试接口
  static const String TEST_PUSH = TEST_BASE_URL + "/push";

  /// 推送回调
  static const String TEST_PUSH_CALLBACK = TEST_BASE_URL + "/push/callback";

  /// 上传接口
  static const String UPLOAD_URL = TEST_BASE_URL + "/course/upload-android";

  static const String UPLOAD_HTML_URL = TEST_BASE_URL + "/course/upload";

  /// 自习室
  static const String ROOM_URL = TEST_BASE_URL + "/room";

  /// 获取这周是第几周
  static const String TIME_INFO = TEST_BASE_URL + "/course/timeInfo";

  /// 版本更新信息
  static const String UPDATE_INFO = TEST_BASE_URL + "/general/updateInfo";

  /// 获取资讯列表
  static const String NEWS_LIST = TEST_BASE_URL + "/News/list";

  /// 获取资讯内容
  static const String NEWS_CONTENT = TEST_BASE_URL + "/News/content";

  /// 隐私政策
  static const String PRIVACY = "https://www.baidu.com";
}
