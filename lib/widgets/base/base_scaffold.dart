
import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
//全局样式控制
class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseScaffold({Key key, this.title, this.body}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          title,
          style: TextStyle(
            color: Color(AppColors.APPBAR),
          ),
        ),
        iconTheme: IconThemeData(color: Color(AppColors.APPBAR)),
      ),
        body:body
    );
  }
}
