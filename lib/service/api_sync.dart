import 'package:idgames_archive_browser/model/archive_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

class ApiServiceUtil {
  late int randomEntryId = 20337;
  /* int random(min, max) {
    return min + Random().nextInt(max - min);
  } */

  Future<int> getRandomEntryId() async {
    //  id;
    await http
        .get(Uri.parse(
            'https://www.doomworld.com/idgames/api/api.php?action=latestfiles&limit=1&out=json'))
        .then((response) {
      if (response.statusCode == 200) {
        randomEntryId = /* last_id =  */ FileElement
                .fromJson(jsonDecode(response.body)["content"]["file"]["id"])
            .id as int;
        // return random(1, last_id.id);
      }
    });
    // log(response.statusCode);
    throw Error();
  }
}
