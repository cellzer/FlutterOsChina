import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/event_bus.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/utils/data_utils.dart';
import 'package:flutter_app/utils/net_utils.dart';
import 'package:flutter_app/widgets/base/empty_view.dart';
import 'package:flutter_app/widgets/base/footer_loadmore.dart';
import 'package:flutter_app/widgets/news_list_item.dart';

import 'login_web_page.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {

  bool isLogin = false;
  int curPage = 1;
  List newsList;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        curPage++;
        getNewsList(true);
      }
    });
    DataUtils.isLogin().then((isLogin) {
      if (!mounted) return;
      setState(() {
        this.isLogin = isLogin;
      });
    });
    eventBus.on<LoginEvent>().listen((event) {
      if (!mounted) return;
      setState(() {
        this.isLogin = true;
      });
      //获取新闻列表
      getNewsList(false);
    });
    eventBus.on<LogoutEvent>().listen((event) {
      if (!mounted) return;
      setState(() {
        this.isLogin = false;
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLogin) {
      return EmptyView();


    }
    return RefreshIndicator(
      onRefresh: _pullToRefresh,
      child: buildListView(),
    );
  }
  getNewsList(bool isLoadMore) async {
    DataUtils.isLogin().then((isLogin) {
      if (isLogin) {
        DataUtils.getAccessToken().then((accessToken) {
          if (accessToken == null || accessToken.length == 0) {
            return;
          }
          Map<String, dynamic> params = Map<String, dynamic>();
          params['access_token'] = accessToken;
          params['catalog'] = 1;
          params['page'] = curPage;
          params['pageSize'] = 10;
          params['dataType'] = 'json';

          NetUtils.get(AppUrls.NEWS_LIST, params).then((data) {
            print('NEWS_LIST: $data');
            if (data != null && data.isNotEmpty) {
              Map<String, dynamic> map = json.decode(data);
              List _newsList = map['newslist'];
              if (!mounted) return;
              setState(() {
                if (isLoadMore) {
                  newsList.addAll(_newsList);
                } else {
                  newsList = _newsList;
                }
              });
            }
          });
        });
      }
    });
  }
  Widget buildListView() {
    if (newsList == null) {
      getNewsList(false);
      return CupertinoActivityIndicator();
    }
    return ListView.builder(
        controller: _controller,
        itemCount: newsList.length+1, //lsn 15
        itemBuilder: (context, index) {
          if(index==newsList.length){
            return FooterView();
          }

          return NewsListItem(newsList: newsList[index]);
        });
  }
  Future<Null> _pullToRefresh() async {
    curPage = 1;
    getNewsList(false);
    return null;
  }

}
