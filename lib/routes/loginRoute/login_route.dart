import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/global.dart';
import '../../models/githubUser.dart';
import '../../common/http.dart';
import '../../states/profileChangeNotifier.dart';
import '../../common/toast.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;
  bool submitClick = false;

  @override
  void initState() {
    super.initState();
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
    _unameController.text = Global.profile.lastLogin;
    if (_unameController.text != null && _unameController.text != '') {
      _nameAutoFocus = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: Column(
            children: <Widget>[
              TextFormField(
                  autofocus: _nameAutoFocus,
                  controller: _unameController,
                  decoration: InputDecoration(
                    hintText: '填写账号或邮箱',
                    prefixIcon: Icon(Icons.person),
                  ),
                  // 校验用户名（不能为空）
                  validator: (v) {
                    return v.trim().isNotEmpty ? null : '用户名不能为空';
                  }),
              TextFormField(
                controller: _pwdController,
                autofocus: !_nameAutoFocus,
                decoration: InputDecoration(
                    hintText: '密码',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          pwdShow ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      },
                    )),
                obscureText: !pwdShow,
                //校验密码（不能为空）
                validator: (v) {
                  return v.trim().isNotEmpty ? null : '密码不能为空';
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (!submitClick) {
                        _onLogin(context);
                      } else {
                        setState(() {
                          submitClick = true;
                        });
                      }
                    },
                    textColor: Colors.white,
                    child: Text('登录'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin(BuildContext context) async {
    // 提交前，先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
//      showLoading(context);
      var user;
      try {
        user = await (Http()..merge(extra: {'name': 'scy'})).request('/zuowen/typeList', method: 'get', params: {
          'key': '511cb1c23b8ffd9541a9a72d96f36574',
          'id': 2
        });
        print('''
          ${user.statusCode}
          ${user.request}
          ${user.headers}
          ${user.extra}
          ${user.data}
        ''');
        // 因为登录页返回后，首页会build，所以我们传false，更新user后不触发更新
//        Provider.of<GithubUserModel>(context, listen: false).githubUser = user;
      } catch (e) {
        print('出错');
        //登录失败则提示
//        _showToast(context);
      } finally {
        // 隐藏loading框
        _showToast(context);
//        Navigator.of(context).pop();
      }
//      if (user != null) {
//        // 返回
//        Navigator.of(context).pop();
//      }
    }
  }

  _showToast (BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('确认弹窗'),
            contentPadding: EdgeInsets.only(left: 20),
            children: <Widget>[
              Text('登录失败，请重新尝试！'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () { Navigator.pop(context); },
                    child: const Text('取消'),
                  ),
                  SimpleDialogOption(
                    onPressed: () { Navigator.pop(context); },
                    child: const Text('确认'),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }
}