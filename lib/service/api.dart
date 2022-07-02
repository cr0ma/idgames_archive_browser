import 'dart:convert';
import 'package:http/http.dart';
import 'package:idgames_archive_browser/model/archive_model.dart';

class ApiService {
  String endpoint = "https://www.doomworld.com/idgames/api/api.php?action=";

  Future<Contents> getListEntry(String query) async {
    Response response = await get(Uri.parse(
        // https://www.doomworld.com/idgames/api/api.php?action=search&query=chest&type=filename&sort=date
        endpoint + 'search&query=${query}&type=title&sort=date&out=json'));
    if (response.statusCode == 200) {
      // return (json.decode(response.body)["content"]["file"])
      //     .map((i) => FileElement.fromJson(i));
      // var body = json.decode(response.body)["content"] /* ["content"]["file"] */
      //     as Map<String, Object>;
      // return body.map((p) => Contents.fromJson(p)).toList();
      return Contents.fromRawJson(response.body);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<FileElement> getEntry(int id) async {
    Response response =
        await get(Uri.parse(endpoint + 'get&id=${id}' + '&out=json'));
    if (response.statusCode == 200) {
      // final List result = jsonDecode(response.body)["content"] /* as List */;
      // return result.map((e) => FileElement.fromJson(e)).toList();
      // return (json.decode(response.body)["content"])
      //     .map((i) => FileElement.fromJson(i))
      //     .toList();
      return FileElement.fromJson(json.decode(response.body)["content"]);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Stream<Contents> getListEntries(Duration refreshTime, String query) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getListEntry(query);
    }
  }
}
