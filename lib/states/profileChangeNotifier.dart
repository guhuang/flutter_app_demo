import 'package:flutter/material.dart';
import '../common/global.dart';
import '../models/profile.dart';
import '../models/githubUser.dart';

// 更改全局共享状态需要保存用户信息，并且通知依赖子组件更新
class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

// Github用户模型
class GithubUserModel extends ProfileChangeNotifier {
  GithubUser get githubUser => _profile.githubUser;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => githubUser != null;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set githubUser(GithubUser githubUser) {
    if (githubUser?.login != _profile.githubUser?.login) {
      _profile.lastLogin = _profile.githubUser?.login;
      _profile.githubUser = githubUser;
      notifyListeners();
    }
  }
}

// 主题模型
class ThemeModel extends ProfileChangeNotifier {
  // 获取当前主题，如果为设置主题，则默认使用蓝色主题
  ColorSwatch get theme => Global.themes
      .firstWhere((e) => e.value == _profile.theme, orElse: () => Colors.blue);

  // 主题改变后，通知其依赖项，新主题会立即生效
  set theme(ColorSwatch color) {
    if (color != theme) {
      _profile.theme = color[500].value;
      notifyListeners();
    }
  }
}