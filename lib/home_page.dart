import 'package:flutter/material.dart';
import 'package:flutter_app/pages/discovery_page.dart';
import 'package:flutter_app/pages/news_list_page.dart';
import 'package:flutter_app/pages/profile_page.dart';
import 'package:flutter_app/pages/publish_tweet_page.dart';
import 'package:flutter_app/pages/tweet_page.dart';
//import 'package:flutter_app/plugins/FlutterToast.dart';
import 'package:flutter_app/utils/data_utils.dart';
import 'package:flutter_app/widgets/my_drawer.dart';
import 'package:flutter_app/widgets/navigation_icon_view.dart';
import 'constants/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _appBarTitle = ['资讯', '动弹', '发现', '我的'];
  final _icons = [
    'assets/images/ic_nav_news_normal.png',
    'assets/images/ic_nav_tweet_normal.png',
    'assets/images/ic_nav_discover_normal.png',
    'assets/images/ic_nav_my_normal.png'
  ];
  final _activeIcons = [
    'assets/images/ic_nav_news_actived.png',
    'assets/images/ic_nav_tweet_actived.png',
    'assets/images/ic_nav_discover_actived.png',
    'assets/images/ic_nav_my_pressed.png'
  ];

  List<NavigationIconView> _navigationIconViews;
  var _currentIndex = 0;
  List<Widget> _pages;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    for (int i; i < 4; i++) {
//      _navigationIconViews.add(NavigationIconView(
//          title: _appBarTitle[i],
//          iconPath: _icons[i],
//          activeIconPath: _activeIcons[i]));
//    }
    _navigationIconViews = [
      NavigationIconView(
          title: '资讯',
          iconPath: 'assets/images/ic_nav_news_normal.png',
          activeIconPath: 'assets/images/ic_nav_news_actived.png'),
      NavigationIconView(
          title: '动弹',
          iconPath: 'assets/images/ic_nav_tweet_normal.png',
          activeIconPath: 'assets/images/ic_nav_tweet_actived.png'),
      NavigationIconView(
          title: '发现',
          iconPath: 'assets/images/ic_nav_discover_normal.png',
          activeIconPath: 'assets/images/ic_nav_discover_actived.png'),
      NavigationIconView(
          title: '我的',
          iconPath: 'assets/images/ic_nav_my_normal.png',
          activeIconPath: 'assets/images/ic_nav_my_pressed.png'),
    ];
    _pages = [
      NewsListPage(),
      TweetPage(),
      DiscoveryPage(),
      ProfilePage(),
    ];

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          _appBarTitle[_currentIndex],
          style: TextStyle(color: Color(AppColors.APPBAR)),
        ),
        iconTheme: IconThemeData(color: Color(AppColors.APPBAR)),
      ),
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        //禁止滑动
        itemBuilder: (BuildContext context, int index) {
          return _pages[index];
        },
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          _currentIndex = index;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(AppColors.APP_THEME),
        child: Icon(
          Icons.add,
          color: Color(AppColors.APPBAR),

        ), onPressed: () {
          DataUtils.isLogin().then((islogin){

            if (islogin) {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  PublishTweetPage()));

            }else {
//              FlutterToast.showToast(
//                '请先登录!',
//                duration: 'short',
//                textColor: 0xffff0000,
//                textSize: 20.0,
//              );
            }
          });


      },


      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: _navigationIconViews.map((view) => view.item).toList(),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.animateToPage(index,
                duration: Duration(microseconds: 1), curve: Curves.ease);
          }),


      drawer: MyDrawer(
        headImgPath: "assets/images/cover_img.jpg",
        menuTitle: ['发布动弹', '动弹小黑屋', '关于', '设置'],
        menuIcons: [Icons.send, Icons.home, Icons.error, Icons.settings],
      ),
    );
  }
}
