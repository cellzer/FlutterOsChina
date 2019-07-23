import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/pages/common_web_page.dart';
import 'package:flutter_app/utils/data_utils.dart';
import 'package:flutter_app/utils/net_utils.dart';

class NewsListItem extends StatelessWidget {
  final Map<String, dynamic> newsList;

  const NewsListItem({Key key, this.newsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _getDetailUrl(context);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xffaaaaaa),
          ),
        )),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, bottom: 20),
          child: Column(
            children: <Widget>[
              Text(
                '${newsList['title']}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '@${newsList['author']} ${newsList['pubDate'].toString().split(' ')[0]}',
                      style:
                          TextStyle(color: Color(0xaaaaaaaa), fontSize: 14.0),
                    ),
                  ),
                  Icon(
                    Icons.message,
                    color: Color(0xaaaaaaaa),
                  ),
                  Text(
                    '${newsList['commentCount']}',
                    style: TextStyle(color: Color(0xaaaaaaaa), fontSize: 14.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _getDetailUrl(BuildContext context) {
    DataUtils.getAccessToken().then((token) {
      Map<String, dynamic> params = Map<String, dynamic>();
      params['access_token'] = token;
      params['dataType'] = 'json';
      params['id'] = newsList['id'];
      NetUtils.get(AppUrls.NEWS_DETAIL, params).then((data) {
        if (data != null && data.isNotEmpty) {
          Map<String, dynamic> map = json.decode(data);
          print('NEWS_DETAIL: $map');

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CommonWebPage(
                    url: map['url'],
                    title: newsList["title"],
                  )));
        }
      });
    });

    return null;
  }
}
