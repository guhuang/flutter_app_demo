import 'package:flutter/material.dart';
import '../../states/profileChangeNotifier.dart';
import 'package:provider/provider.dart';
import '../../common/gm_avatar.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //移除顶部padding
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(), //构建抽屉菜单头部
            Expanded(child: _buildMenus()), //构建功能菜单
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<GithubUserModel>(
      builder: (BuildContext context, GithubUserModel value, Widget child) {
        return GestureDetector(
          child: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: gmAvatar(
                    value.isLogin ? value.githubUser.avatar_url : '',
                    borderRadius: BorderRadius.circular(50),
                  ),
//                  child: ClipOval(
//                    // 如果已登录，则显示用户头像；若未登录，则显示默认头像
//                    child: value.isLogin
//                      ? gmAvatar(value.githubUser.avatar_url, width: 80)
//                      : Image.asset(
//                          "imgs/01.jpg",
//                          width: 80,
//                          fit: BoxFit.contain,
//                        ),
//                  ),
                ),
                Text(
                  value.isLogin
                      ? value.githubUser.login
//                      : GmLocalizations.of(context).login,
                      : '登录去吧，菜鸡',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            if (!value.isLogin) Navigator.of(context).pushNamed("login");
          },
        );
      },
    );
  }

  // 构建菜单项
  Widget _buildMenus() {
    return Consumer<GithubUserModel>(
      builder: (BuildContext context, GithubUserModel githubUserModel, Widget child) {
        return ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text('换肤'),
              onTap: () => Navigator.pushNamed(context, "themes"),
            ),
            if(githubUserModel.isLogin) ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: Text('注销'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    //退出账号前先弹二次确认窗
                    return AlertDialog(
                      content: Text('确认登出吗？'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('取消'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                          child: Text('确认'),
                          onPressed: () {
                            //该赋值语句会触发MaterialApp rebuild
                            githubUserModel.githubUser = null;
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}