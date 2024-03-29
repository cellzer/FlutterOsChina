import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/event_bus.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/utils/data_utils.dart';
import 'package:flutter_app/utils/net_utils.dart';
import 'package:flutter_app/widgets/base/empty_view.dart';
import 'package:flutter_app/widgets/base/footer_loadmore.dart';
import 'package:flutter_app/widgets/tweet_list_item.dart';

import 'login_web_page.dart';

class TweetPage extends StatefulWidget {
  @override
  _TweetPageState createState() => _TweetPageState();
}

class _TweetPageState extends State<TweetPage>
    with SingleTickerProviderStateMixin {
  List _tabTitles = ['最新', '热门'];
  List latestTweetList;
  List hotTweetList;
  int curPageTweet = 1;
  int curPageHot = 1;
  ScrollController _controller = ScrollController();
  TabController _tabController;
  bool isLogin = false;
  int curTab = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this)
    ..addListener((){
      //添加监听
      curTab=_tabController.index;
      print("TweetPage--_tabController"+"$curTab");

    });
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        print("TweetPage--_controller"+"$curTab");
        if(curTab==0){
          curPageTweet++;
          getTweetList(isLoadMore: true);
        }else{
          curPageHot++;
          getHotList(isLoadMore: true);

        }
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
        this.isLogin = isLogin;
      });
      if(curTab==0){
        curPageTweet=1;
        getTweetList(isLoadMore: false);
      }else{
        curPageHot=1;
        getHotList(isLoadMore: false);

      }
    });
    eventBus.on<LogoutEvent>().listen((event) {
//      _showUerInfo();
    });
  }

  getTweetList({bool isLoadMore}) async {
    DataUtils.isLogin().then((isLogin) {
      if (isLogin) {
        DataUtils.getAccessToken().then((accessToken) {
          if (accessToken == null || accessToken.length == 0) {
            return;
          }
          Map<String, dynamic> params = Map<String, dynamic>();
          params['access_token'] = accessToken;
          params['user'] =  0;
          params['page'] = curPageTweet;
          params['pageSize'] = 10;
          params['dataType'] = 'json';

          NetUtils.get(AppUrls.TWEET_LIST, params).then((data) {
            print('TWEET_LIST: $data');
            if (data != null && data.isNotEmpty) {
              Map<String, dynamic> map = json.decode(data);
              List _tweetList = map['tweetlist'];
              if (!mounted) return;
              setState(() {
                if (isLoadMore) {
                    latestTweetList.addAll(_tweetList);
                } else {
                    latestTweetList = _tweetList;
                }
              });
            }
          });
        });
      }
    });
  }
  getHotList({bool isLoadMore}) async {
    DataUtils.isLogin().then((isLogin) {
      if (isLogin) {
        DataUtils.getAccessToken().then((accessToken) {
          if (accessToken == null || accessToken.length == 0) {
            return;
          }
          Map<String, dynamic> params = Map<String, dynamic>();
          params['access_token'] = accessToken;
          params['user'] = -1;
          params['page'] = curPageHot;
          params['pageSize'] = 10;
          params['dataType'] = 'json';

          NetUtils.get(AppUrls.TWEET_LIST, params).then((data) {
            print('HOT_LIST: $data');
            if (data != null && data.isNotEmpty) {
              Map<String, dynamic> map = json.decode(data);
              List _tweetList = map['tweetlist'];
              if (!mounted) return;
              setState(() {
                if (isLoadMore) {
                    hotTweetList.addAll(_tweetList);
                } else {
                    hotTweetList = _tweetList;
                }
              });
            }
          });
        });
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLogin) {
      return EmptyView();
    }

    return Column(
      children: <Widget>[
        //tabbar
        Container(
          color: Color(AppColors.APP_THEME),
          child: TabBar(
              controller: _tabController,
              indicatorColor: Color(0xffffffff),
              labelColor: Color(0xffffffff),
              tabs: _tabTitles.map((title) {
                return Tab(
                  text: title,
                );
              }).toList()),
        ),
        Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildLatestTweetList(), _buildHotTweetList()],
            ))
        //list
      ],
    );
  }
  Future<Null> _pullToRefresh() async {
    if(curTab==0){
      curPageTweet=1;
      getTweetList(isLoadMore: false);
    }else{
      curPageHot=1;
      getHotList(isLoadMore: false);

    }
    return null;
  }

  Widget _buildLatestTweetList() {
    if (latestTweetList == null) {
      getTweetList(isLoadMore: false);
      return new Center(
        child: new CupertinoActivityIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: _pullToRefresh,
      child: ListView.separated(
          controller: _controller,
          itemBuilder: (context, index) {
            if (index == latestTweetList.length) {
              return FooterView();
            }
            return TweetListItem(tweetData: latestTweetList[index]);
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 10.0,
              color: Colors.grey[200],
            );
          },
          itemCount: latestTweetList.length + 1),
    );
  }

  Widget _buildHotTweetList() {
    if (hotTweetList == null) {
      getHotList(isLoadMore: false);
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: _pullToRefresh,
      child: ListView.separated(
          controller: _controller,
          itemBuilder: (context, index) {
            if (index == hotTweetList.length) {
              return FooterView();
            }
            return TweetListItem(tweetData: hotTweetList[index]);
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 10.0,
              color: Colors.grey[200],
            );
          },
          itemCount: hotTweetList.length + 1),

    );
  }
}
