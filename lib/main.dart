import 'package:flutter/material.dart';
import 'common/global.dart';
import 'package:provider/provider.dart';
import 'states/profileChangeNotifier.dart';
import 'routes/index.dart';
import 'routes/homePage/homeRoute.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: GithubUserModel()),
      ],
      child: Consumer<ThemeModel>(
        builder: (BuildContext context, themeModel, Widget child) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
            onGenerateTitle: (context){
              return 'aaaaaaaaaa';
            },
            home: HomeRoute(), //应用主页
            routes: routes,
          );
        },
      ),
    );
  }
}