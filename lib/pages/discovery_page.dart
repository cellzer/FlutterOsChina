import 'package:flutter/material.dart';

class DiscoveryPage extends StatefulWidget {
  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  List<Map<String, IconData>> blocks = [
    {
      '开源众包': Icons.pageview,
      '开源软件': Icons.speaker_notes_off,
      '码云推荐': Icons.screen_share,
      '代码片段': Icons.assignment,
    },
    {
      '扫一扫': Icons.camera_alt,
      '摇一摇': Icons.camera,
    },
    {
      '码云封面人物': Icons.person,
      '线下活动': Icons.android,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index1) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Color(0xffaaaaaa),
                  ),
                  bottom: BorderSide(
                    width: 1,
                    color: Color(0xffaaaaaa),
                  ))),
          child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, innerIndex) {
                return InkWell(
                  child: Container(
                    height: 50,
                    child: ListTile(
                      leading: Icon(
                          blocks[index1].values.elementAt(innerIndex)
                      ),
                      title: Text(blocks[index1].keys.elementAt(innerIndex)),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),

                );

              },
              separatorBuilder: (context, index2) {
                return Divider(height: 2, color: Color(0xffaaaaaa));
              },
              itemCount: blocks[index1].length),
        );
      },
      itemCount: blocks.length,
    );
  }
}
