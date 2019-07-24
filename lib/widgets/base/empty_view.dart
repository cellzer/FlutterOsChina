import 'package:flutter/material.dart';
import 'package:flutter_app/common/event_bus.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/pages/login_web_page.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("登录后查看更多内容"),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginWebPage()));
              if (result != null && result == 'refresh') {
                //登录成功
                eventBus.fire(LoginEvent());
              }
            },
            color:Color(AppColors.APP_THEME),
            child: Text("去登录",style: TextStyle(color:Colors.white),),


          )
        ],
      ),
    );
  }
}
