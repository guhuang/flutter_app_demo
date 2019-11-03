import 'package:flutter/material.dart';
import '../../../common/http.dart';

class Resume extends StatefulWidget {
  @override
  _ResumeState createState() => new _ResumeState();
}

class _ResumeState extends State<Resume> {
  var list = [];
  initState() {
    super.initState();
    _getCity();
  }
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.blue,
          child: Center(
            child: Text('年级：${list[index]['name']}，id号：${list[index]['id']}'),
          ),
        );
      }
    );
  }

  Future _getCity() async {
    var res = await Http(context).request('/zuowen/typeList', method: 'get', params: {
      'key': '511cb1c23b8ffd9541a9a72d96f36574',
      'id': 1
    });
    setState(() {
      list = res.data['result'];
    });
  }
}
