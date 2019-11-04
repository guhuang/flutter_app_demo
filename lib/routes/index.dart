import 'package:flutter/material.dart';
import 'loginRoute/login_route.dart';
import 'themeChangeRoute.dart';

Map<String, WidgetBuilder> routes = <String, WidgetBuilder> {
  "login": (context) => LoginRoute(),
  "themes": (context) => ThemeChangeRoute(),
};