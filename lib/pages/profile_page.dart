import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/common/event_bus.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/pages/profile_detail.dart';
import 'package:flutter_app/utils/net_utils.dart';
import 'login_web_page.dart';
import 'package:flutter_app/utils/data_utils.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List menuTitles = [
    '我的消息',
    '阅读记录',
    '我的博客',
    '我的问答',
    '我的活动',
    '我的团队',
    '邀请好友',
  ];
  List menuIcons = [
    Icons.message,
    Icons.print,
    Icons.error,
    Icons.phone,
    Icons.send,
    Icons.people,
    Icons.person,
  ];

  String userAvatar;
  String userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showUerInfo();
    eventBus.on<LoginEvent>().listen((onData) {
      //获取用户信息并显示
      _getUerInfo();
    });
    eventBus.on<LogoutEvent>().listen((onData) {
      //获取用户信息并显示
     _showUerInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader();
          }
          index -= 1;
          return ListTile(
            leading: Icon(menuIcons[index]),
            title: Text(menuTitles[index]),
            trailing: Icon(Icons.arrow_forward_ios),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: menuTitles.length + 1);
  }

  Container _buildHeader() {
    return Container(
      height: 150.0,
      color: Color(AppColors.APP_THEME),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: userAvatar != null
                  ? Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(AppColors.APPBAR),
                          width: 2,
                        ),
                        image: DecorationImage(
                            image: NetworkImage(userAvatar),
                            fit: BoxFit.cover),
                      ),
                    )
                  : Image.asset(
                      'assets/images/ic_avatar_default.png',
                      width: 60.0,
                      height: 60.0,
                    ),
              onTap: () {
                DataUtils.isLogin().then((isLogin){
                  if (isLogin) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                        ProfileDetailPage()
                    ));
                  }else {
                    _login();
                  }


                });


              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              userName ??= "点击头像登录",
              style: TextStyle(color: Color(AppColors.APPBAR)),
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    final result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginWebPage()));
    if (result != null && result == "refresh") {
      eventBus.fire(LoginEvent());
    }
  }

  void _showUerInfo() {
    DataUtils.getUserInfo().then((user) {
      if (mounted) {
        setState(() {
          if (user != null) {
            userAvatar = user.avatar;
            userName = user.name;
          } else {
            userAvatar = null;
            userName = null;
          }
        });
      }
    });

  }

  void _getUerInfo() {
    DataUtils.getAccessToken().then((accessToken) {
      if (accessToken == null || accessToken.length == 0) {
        return;
      }

      Map<String, dynamic> params = Map<String, dynamic>();
      params['access_token'] = accessToken;
      params['dataType'] = 'json';
      print('accessToken: $accessToken');
      NetUtils.get(AppUrls.OPENAPI_USER, params).then((data) {
        //{"gender":"male","name":"Damon2019","location":"湖南 长沙","id":2006874,"avatar":"https://oscimg.oschina.net/oscnet/up-21zvuaor7bbvi8h2a4g93iv9vve2wrnz.jpg!/both/50x50?t=1554975223000","email":"3262663349@qq.com","url":"https://my.oschina.net/damon007"}
        print('data: $data');
        DataUtils.saveUserInfo(data);
        Map<String, dynamic> map = json.decode(data);
        if (mounted) {
          setState(() {
            userAvatar = map['avatar'];
            userName = map['name'];
          });
        }
      });
    });
  }
}
