import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';

class DbInstanceUrl {
  late Box box;

  Future<void> saveUrl(String url) async {
    box = await Hive.openBox<String>(URL_BOX);
    await box.put(URL_KEY, url);
  }

  Future<String> getUrl() async {
    box = await Hive.openBox<String>(URL_BOX);
    String url = box.get(URL_KEY) ?? instanceUrl;
    return url;
  }

  Future<int> deleteUrl() async {
    box = await Hive.openBox<String>(URL_BOX);
    return await box.clear();
  }
}
