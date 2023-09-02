import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/model/news/news_list.dart';
import 'package:iwut_flutter/routers/navigator.dart';
import 'package:iwut_flutter/service/news_service.dart';
import 'package:iwut_flutter/widgets/custom_pull_to_refresh.dart';
import 'package:iwut_flutter/widgets/iwut_scaffold.dart';

class NewsListPage extends StatefulWidget {
  NewsListPage({Key? key}) : super(key: key);

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  CustomRefresherController _controller = CustomRefresherController();
  int _pageNum = 0;
  List<NewsModel> _data = [];
  DateTime? now;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _onLoad();
  }

  Widget get emptyView {
    return GestureDetector(
      onTap: _onLoad,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh,
              size: 200.w,
              color: AppColor(context).element6,
            ),
            Text(
              "数据加载失败",
              style: TextStyle(
                fontSize: 40.sp,
                color: Color(0xFFC0C2C6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onLoad() async {
    _pageNum += 1;
    var rsp = await NewsService.getNewsList(page: _pageNum);
    if (rsp.length != 0) {
      _data.addAll(rsp);
      if (mounted) setState(() {});
      _controller.finishLoad(true, noMore: rsp.isEmpty);
    } else {
      _controller.finishLoad(false);
    }
  }

  Widget _buildTitle(String source, int time) {
    var date = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return Container(
      margin: EdgeInsets.only(bottom: 5.w),
      child: Row(
        children: [
          Text(source, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColor(context).element6)),
          Spacer(),
          Text(
            '${date.year}-${date.month}-${date.day}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColor(context).element6),
          )
        ],
      ),
    );
  }

  Widget _buildNewsCell(int index) {
    return GestureDetector(
      onTap: () => IwutNavigator.goNewsContent(context, _data[index].postId!),
      child: AspectRatio(
        key: Key('news_$index'),
        aspectRatio: 4.7,
        child: Container(
          margin: EdgeInsets.only(
            top: 24.w,
            left: 31.w,
            right: 31.w,
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: AppColor(context).moreCellBGColor,
            borderRadius: BorderRadius.circular(17.w),
            boxShadow: [BoxShadow(blurRadius: 2, spreadRadius: 1, color: Color.fromARGB(23, 0, 0, 0))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(_data[index].source!, _data[index].publishDate!),
              Divider(thickness: 1, height: 1, color: Colors.grey),
              Container(
                margin: EdgeInsets.only(top: 5.w),
                child: Text(
                  _data[index].title!,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14, color: AppColor(context).textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, index) => _buildNewsCell(index),
      itemCount: _data.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IwutScaffold(
      title: '理工资讯',
      titleColor: Colors.white,
      appBarColor: AppColor(context).roomNavigatorColor,
      body: CustomRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: _controller,
        onLoading: _onLoad,
        emptyView: emptyView,
        child: _buildBody(),
      ),
    );
  }
}
