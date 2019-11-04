import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class TempCache {
  String cachePath = '';
  TempCache({this.cachePath = '/cache.json'});

  // 获取缓存文件
  Future<File> _getTempCacheFile () async {
    String dir = (await getTemporaryDirectory()).path;
    return new File('${dir}${cachePath}');
  }

  // 获取缓存文件dart对象
   Future _getTempCache () async {
    File cacheFile = await _getTempCacheFile();
    try {
      String contents = await cacheFile.readAsString();
      Map cacheMap = json.decode(contents);
      return cacheMap;
    } on FileSystemException {
      return {};
    }
  }

  getStorage (String key) async {
    Map cacheMap = await _getTempCache();
    return cacheMap[key];
  }

  setStorage (String key, dynamic value) async {
    Map cacheMap = await _getTempCache();
    cacheMap[key] = value;
    File cacheFile = await _getTempCacheFile();
    await cacheFile.writeAsString(json.encode(cacheMap));
  }

  removeStorage (String key) async {
    Map cacheMap = await _getTempCache();
    cacheMap.remove(key);
    File cacheFile = await _getTempCacheFile();
    await cacheFile.writeAsString(json.encode(cacheMap));
  }
}