import 'package:flutter/material.dart';
import 'loginRoute.dart';
import 'themeChangeRoute.dart';

Map<String, WidgetBuilder> routes = <String, WidgetBuilder> {
  "login": (context) => LoginRoute(),
  "themes": (context) => ThemeChangeRoute(),
};