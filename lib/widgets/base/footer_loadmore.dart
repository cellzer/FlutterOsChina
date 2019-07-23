

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class FooterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 20.0,
              ),
              Text('正在加载...'),
              CupertinoActivityIndicator(),
            ],
          )),
    );
  }
}
