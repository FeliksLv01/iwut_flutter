import 'package:iwut_flutter/config/log/log.dart';
import 'package:iwut_flutter/http/http_request.dart';
import 'package:iwut_flutter/http/server_url.dart';
import 'package:iwut_flutter/model/news/news_content.dart';
import 'package:iwut_flutter/model/news/news_list.dart';

class NewsService {
  static Future<List<NewsModel>> getNewsList({int page = 1, int pageSize = 10}) async {
    if (page < 1) page = 1;
    var rsp = await HttpRequest.instance!.get(ServerUrl.NEWS_LIST, parameters: {'page': page, 'pageSize': pageSize});
    List<NewsModel> newsList = [];
    if (rsp['code'] == 0 && rsp['data'].length != 0) {
      newsList = NewsListModel.fromJson(rsp['data']).NewsList;
    } else {
      Log.error('网络请求异常', tag: '网络');
    }
    return newsList;
  }

  static Future<NewsContent?> getNewsContent(String? postId) async {
    var rsp = await HttpRequest.instance!.get(ServerUrl.NEWS_CONTENT, parameters: {'postId': postId});
    if (rsp['code'] != 0) {
      Log.error('网络请求异常', tag: '网络');
      return null;
    }
    var newsContent = NewsContent.fromJson(rsp['data']);
    return newsContent;
  }
}
