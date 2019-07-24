import 'package:flutter/material.dart';
import 'package:flutter_app/common/event_bus.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/utils/data_utils.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '设置',
            style: TextStyle(color: Color(AppColors.APPBAR)),
          ),
          iconTheme: IconThemeData(color: Color(AppColors.APPBAR)),
        ),
        body: Center(
            child: FlatButton(
                color: Color(AppColors.APP_THEME),
                onPressed: () {
                  DataUtils.clearLoginInfo();
                  Navigator.of(context).pop();
                  eventBus.fire(LogoutEvent());
                },
                textColor: Colors.white,
                child: Text("退出登录",))));
  }
}
