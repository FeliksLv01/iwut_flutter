import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iwut_flutter/model/news/news_content.dart';
import 'package:iwut_flutter/pages/webview/webview_page.dart';
import 'package:iwut_flutter/service/news_service.dart';
import 'package:iwut_flutter/widgets/iwut_scaffold.dart';

class NewsContentPage extends StatefulWidget {
  final String? postId;

  NewsContentPage({Key? key, this.postId}) : super(key: key);

  @override
  _NewsContentPageState createState() => _NewsContentPageState();
}

class _NewsContentPageState extends State<NewsContentPage> {
  final newsContent = ValueNotifier<NewsContent?>(null);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    newsContent.value = await NewsService.getNewsContent(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: newsContent,
      builder: (context, dynamic news, _) {
        if (news == null) return IwutScaffold(title: '资讯信息', body: Container());
        return WebViewPage(
          useShouldOverrideUrlLoading: true,
          initData: news.content,
          title: '资讯信息',
        );
      },
    );
  }
}
