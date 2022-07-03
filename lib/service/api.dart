import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart';
import 'package:idgames_archive_browser/model/archive_model.dart';
import 'dart:math';

class ApiService {
  String endpoint = "https://www.doomworld.com/idgames/api/api.php?action=";

  Future<Contents> getListEntry(String query) async {
    Response response = await get(Uri.parse(
        endpoint + 'search&query=${query}&type=title&sort=date&out=json'));
    if (response.statusCode == 200) {
      return Contents.fromRawJson(response.body);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<FileElement> getEntry(int id) async {
    Response response =
        await get(Uri.parse(endpoint + 'get&id=${id}' + '&out=json'));
    if (response.statusCode == 200) {
      return FileElement.fromJson(json.decode(response.body)["content"]);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<FileElement> getFutureEntry(int? id) async {
    Response response =
        await get(Uri.parse(endpoint + 'get&id=${id}' + '&out=json'));
    if (response.statusCode == 200) {
      return FileElement.fromJson(json.decode(response.body)["content"]);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  // https://www.doomworld.com/idgames/api/api.php?action=latestfiles&limit=1&out=json

}
