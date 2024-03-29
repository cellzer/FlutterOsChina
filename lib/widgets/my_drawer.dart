import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/about_page.dart';
import 'package:flutter_app/pages/publish_tweet_page.dart';
import 'package:flutter_app/pages/settings_page.dart';
import 'package:flutter_app/pages/tweet_black_house.dart';

class MyDrawer extends StatelessWidget {
  final String headImgPath;
  final List menuTitle;
  final List menuIcons;

  const MyDrawer(
      {Key key,
      @required this.headImgPath,
      @required this.menuTitle,
      @required this.menuIcons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: ListView.separated(
          padding: const EdgeInsets.all(0.0), //解决状态栏问题
          itemBuilder: (context, index) {
            if (index == 0) {
              return Image.asset(headImgPath, fit: BoxFit.cover);
            }
            index -= 1;

            return ListTile(
              leading: Icon(menuIcons[index]),
              title: Text(menuTitle[index]),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                switch (index) {
                  case 0:
                  //PublishTweetPage
                    _navPush(context, PublishTweetPage());
                    break;
                  case 1:
                  //TweetBlackHousePage
                    _navPush(context, TweetBlackHousePage());
                    break;
                  case 2:
                  //AboutPage
                    _navPush(context, AboutPage());
                    break;
                  case 3:
                  //SettingsPage
                    _navPush(context, SettingsPage());
                    break;
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            if (index == 0) {
              return Divider(height: 0.0);
            } else {
              return Divider(height: 1.0);
            }
          },
          itemCount: menuTitle.length + 1),
    );
  }

  _navPush(BuildContext context,Widget page){
    Navigator.of(context).pop(); //把drawer收起
    Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
  }
}
