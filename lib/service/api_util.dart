import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:http/http.dart';
import 'package:idgames_archive_browser/service/api.dart';

import '../model/archive_model.dart';

class ApiServiceUtil {
  String endpoint = "https://www.doomworld.com/idgames/api/api.php?action=";

  Future<String> pingIdGames() async {
    Response response = await get(Uri.parse(endpoint + 'ping&out=json'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["content"]["status"];
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  int _random(Random source, int min, int max) {
    return source.nextInt(int.parse(max.toString()) - min);
  }

  Future<FileElement> getRandomEntry(Random rng) async {
    Response response = await http.get(Uri.parse(
        'https://www.doomworld.com/idgames/api/api.php?action=latestfiles&limit=1&out=json'));
    if (response.statusCode == 200) {
      int rand = jsonDecode(response.body)["content"]["file"]["id"];
      var random = rng;
      return ApiService().getEntry(_random(random, 1, rand));
    } else {
      throw 'Error';
    }
  }
}
