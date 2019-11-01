import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_demo/common/http.dart';
import '../../common/global.dart';
import '../../common/http.dart';

class Job extends StatefulWidget {
  @override
  _JobState createState() => new _JobState();
}

class _JobState extends State<Job> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _getCity(context);
  }

  @override
  Widget build(BuildContext context) {
    _getCity(context);
    // TODO: implement build
    return Center(
      child: RaisedButton(
        child: Text('点我打开侧边栏'),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }

  Future _getCity(BuildContext context) async {
    print('对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对对');
    var res = await Http(context).request('/api/weather/city/101030100', method: 'get');
    print('code...........${res.statusCode}');
    print('headers...........${res.headers}');
    print('request...........${res.request}');
    print('extra...........${res.extra}');
    print('data...........${res.data}');
  }
}

