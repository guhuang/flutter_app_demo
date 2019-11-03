import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app_demo/common/http.dart';
import '../../common/global.dart';
import '../../common/http.dart';

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
    var cache = _getTemporaryData();
    cache.then((res) => {
      setState(() {
        cacheList = res;
      })
    });
  }
  _getTemporaryData () async{
    String tempPath = (await getTemporaryDirectory()).path;
    File cacheFile = new File('$tempPath/cache.json');
    try {
      List cacheList = json.decode((await cacheFile.readAsString()));
      print('type......${cacheList.runtimeType}$cacheList');
      return cacheList;
    } on FileSystemException {
      return [];
    }
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
    print('building.......${this.cacheList}');
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
            child: Text('搜索'),
            onPressed: () async{
              print('onpressed');
              String searchKey = textController.text;
              if (searchKey != null || searchKey != '') {
                String tempPath = (await getTemporaryDirectory()).path;
                File cacheFile = new File('$tempPath/cache.json');
                List cacheList = await _getTemporaryData();
                cacheList.add(searchKey);
                String cache = json.encode(cacheList);
                await cacheFile.writeAsString('$cache');
                _getTemporaryData();
              }
            },
          ),
          RaisedButton(
            child: Text('点我打开侧边栏'),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      )
    );
  }

}

