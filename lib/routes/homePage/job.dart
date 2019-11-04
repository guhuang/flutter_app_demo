import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_demo/common/iconfont.dart';
import 'package:path_provider/path_provider.dart';
import '../../common/temp_cache.dart';

class Job extends StatefulWidget {
  @override
  _JobState createState() => new _JobState();
}

class _JobState extends State<Job> {
  final textController = TextEditingController();
  List cacheList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var cache = new TempCache().getStorage('searchKey');
    cache.then((res) {
      setState(() {
        cacheList = res ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> textList = [];
    for (var value in cacheList) {
      textList.add(Container(
        padding: EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 0),
        child: Text(value),
      ));
    }
    // TODO: implement build
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30, left: 10, right: 10),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '搜索条件',
              ),
            ),
          ),
          Row(
            children: textList
          ),
          RaisedButton(
            child: Text('搜索即缓存'),
            onPressed: () async {
              String searchKey = textController.text;
              if (searchKey != null || searchKey != '') {
                cacheList.add(searchKey);
                await TempCache().setStorage('searchKey', cacheList);
                List list = await TempCache().getStorage('searchKey');
                setState(() {
                  cacheList = list;
                });
              }
            },
          ),
          RaisedButton(
            child: Text('点我打开侧边栏'),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('iconfont自定义测试'),
              Icon(Iconfont.delete, color: Colors.deepPurple,),
              Icon(Iconfont.share, color: Colors.deepOrange,),
            ],
          ),
        ],
      )
    );
  }

}

