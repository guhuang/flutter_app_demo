import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import 'global.dart';
import '../models/githubUser.dart';
import '../models/repo.dart';

class Http {
  BuildContext context;
  Options _options;
  String url;
  Map<String, dynamic> params;
  String method;
  String tip;
  Http([this.context]) {
    _options = Options(extra: {"context": context});
  }
  static Dio dio = new Dio(BaseOptions(
    baseUrl: 'http://zuowen.api.juhe.cn', // 聚合数据历史天气接口
    headers: {},
  ));

  static void init() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        return options;
      },
      onResponse: (Response response) async {
        return response;
      },
      onError: (DioError e) async {
        // Do something with response error
        return  e;//continue
      }
    ));
    // 设置用户token（可能为null，代表未登录）
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;
  }

  merge ({
    String method,
    int sendTimeout,
    int receiveTimeout,
    Map<String, dynamic> extra,
    Map<String, dynamic> headers,
    ResponseType responseType,
    String contentType,
    ValidateStatus validateStatus,
    bool receiveDataWhenStatusError,
    bool followRedirects,
    int maxRedirects,
    RequestEncoder requestEncoder,
    ResponseDecoder responseDecoder,
  }) {
    _options = Options(
      method: method ?? (_options.method ?? dio.options.method),
      sendTimeout: sendTimeout ?? (_options.sendTimeout ?? dio.options.sendTimeout),
      receiveTimeout: receiveTimeout ?? (_options.receiveTimeout ?? dio.options.receiveTimeout),
      extra: extra ?? Map.from(_options.extra ?? dio.options.extra ?? {}),
      headers: headers ?? Map.from(_options.headers ?? dio.options.headers ?? {}),
      responseType: responseType ?? (_options.responseType ?? dio.options.responseType),
      contentType: contentType ?? (_options.contentType ?? dio.options.contentType),
      validateStatus: validateStatus ?? (_options.validateStatus ?? dio.options.validateStatus),
      receiveDataWhenStatusError:
      receiveDataWhenStatusError ?? (_options.receiveDataWhenStatusError ?? dio.options.receiveDataWhenStatusError),
      followRedirects: followRedirects ?? (_options.followRedirects ?? dio.options.followRedirects),
      maxRedirects: maxRedirects ?? (_options.maxRedirects ?? dio.options.maxRedirects),
      requestEncoder: requestEncoder,
      responseDecoder: responseDecoder ?? (_options.responseDecoder ?? dio.options.responseDecoder),
    );
  }

  request (String url, {Map<String, dynamic> params, String method = 'POST', Map<String, dynamic> options, String tip = '',}) async {
    var response;
    if (method.toLowerCase() == 'get') {
      response = await dio.get(
        url,
        queryParameters: params,
        options: _options
      );
      return response;
    } else {
      response = await dio.post(
        url,
        data: params,
        options: _options
      );
      return response;
    }
  }

  // 登录接口，登录成功后返回用户信息
  Future<GithubUser> login(String login, String pwd) async {
    String basic = 'Basic ' + base64.encode(utf8.encode('$login:$pwd'));
    var r = await dio.get(
      "/users/$login",
      options: _options.merge(headers: {
        HttpHeaders.authorizationHeader: basic
      }, extra: {
        "noCache": true, //本接口禁用缓存
      }),
    );
    //登录成功后更新公共头（authorization），此后的所有请求都会带上用户身份信息
    dio.options.headers[HttpHeaders.authorizationHeader] = basic;
    //清空所有缓存
    Global.netCache.cache.clear();
    //更新profile中的token信息
    Global.profile.token = basic;
    return GithubUser.fromJson(r.data);
  }

  //获取用户项目列表
  Future<List<Repo>> getRepos(
      {Map<String, dynamic> queryParameters, //query参数，用于接收分页信息
        refresh = false}) async {
    if (refresh) {
      // 列表下拉刷新，需要删除缓存（拦截器中会读取这些信息）
      _options.extra.addAll({"refresh": true, "list": true});
    }
    var r = await dio.get<List>(
      "user/repos",
      queryParameters: queryParameters,
      options: _options,
    );
    return r.data.map((e) => Repo.fromJson(e)).toList();
  }
}