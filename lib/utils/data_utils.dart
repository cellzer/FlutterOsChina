import 'dart:convert';

import 'package:flutter_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataUtils {
  static const String SP_ACCESS_TOKEN = 'access_token';
  static const String SP_REFRESH_TOKEN = 'refresh_token';
  static const String SP_UID = 'uid';
  static const String SP_TOKEN_TYPE = 'token_type';
  static const String SP_EXPIRES_IN = 'expires_in';
  static const String SP_IS_LOGIN = 'is_login';


  //用户信息字段
  static const String SP_USER_DATA = 'user_data';

//  {"access_token":"aa105aaf-ca4f-4458-822d-1ae6a1fa33f9","refresh_token":"daae8b80-3ca6-4514-a8ae-acb3a82c951c","uid":2006874,"token_type":"bearer","expires_in":510070}
  static Future<void> saveLoginInfo(Map<String, dynamic> map) async {
    if (map != null && map.isNotEmpty) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp
        ..setString(SP_ACCESS_TOKEN, map[SP_ACCESS_TOKEN])
        ..setString(SP_REFRESH_TOKEN, map[SP_REFRESH_TOKEN])
        ..setInt(SP_UID, map[SP_UID])
        ..setString(SP_TOKEN_TYPE, map[SP_TOKEN_TYPE])
        ..setInt(SP_EXPIRES_IN, map[SP_EXPIRES_IN])
        ..setBool(SP_IS_LOGIN, true);
    }
  }

  static Future<void> clearLoginInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp
      ..setString(SP_ACCESS_TOKEN, '')
      ..setString(SP_REFRESH_TOKEN, '')
      ..setInt(SP_UID, -1)
      ..setString(SP_TOKEN_TYPE, '')
      ..setInt(SP_EXPIRES_IN, -1)
      ..setBool(SP_IS_LOGIN, false);
  }

  //是否登录
  static Future<bool> isLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLogin = sp.getBool(SP_IS_LOGIN);
    return isLogin != null && isLogin;
  }

  //获取token
  static Future<String> getAccessToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(SP_ACCESS_TOKEN);
  }
  //{"gender":"male","name":"Damon2019","location":"湖南 长沙",
  // "id":2006874,"avatar":"https://oscimg.oschina.net/oscnet/up-21zvuaor7bbvi8h2a4g93iv9vve2wrnz.jpg!/both/50x50?t=1554975223000","email":"3262663349@qq.com","url":"https://my.oschina.net/damon007"}
  static saveUserInfo(String data) async {
    if (data != null ) {
      SharedPreferences sp = await SharedPreferences.getInstance();

      sp.setString(SP_USER_DATA, data);
      Map<String, dynamic> map = json.decode(data);


      User user = new User(
          id: map["id"],
          name: map["name"],
          gender: map["gender"],
          avatar: map["avatar"],
          email: map["email"],
          location: map["location"],
          url: map["url"],
          );
      return user;
    }
    return null;
  }

  //获取用户信息
  static Future<User> getUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLogin = sp.getBool(SP_IS_LOGIN);
    if (isLogin == null || !isLogin) {
      return null;
    }
    User user = new User();
    var data = sp.getString(SP_USER_DATA);
    Map<String, dynamic> map =  json.decode(data);
    user.gender = map["gender"];
    user.name = map["name"];
    user.location = map["location"];
    user.id = map["id"];
    user.avatar = map["avatar"];
    user.email = map["email"];
    user.url =map["url"];
    return user;
  }
}
