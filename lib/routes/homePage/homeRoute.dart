import 'package:flutter/material.dart';
import 'package:flutter_app_demo/routes/homePage/job.dart';
import 'package:flutter_app_demo/routes/homePage/my_page.dart';
import 'package:flutter_app_demo/routes/homePage/resume.dart';
import 'my_drawer.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    Job(),
    Resume(),
    MyPage()
  ];
  final PageController _controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_currentIndex),
        ),
          drawer: MyDrawer(), //抽屉菜单
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: _defaultColor),
                activeIcon: Icon(Icons.home, color: _activeColor),
                title: Text('职位')
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, color: _defaultColor),
                activeIcon: Icon(Icons.search, color: _activeColor),
                title: Text('简历')
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, color: _defaultColor),
                activeIcon: Icon(Icons.account_circle, color: _activeColor),
                title: Text('我的')
              )
            ]
          )
      ),
    );
  }
}