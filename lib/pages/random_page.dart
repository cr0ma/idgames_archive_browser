import 'dart:math';

import 'package:filesize/filesize.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:idgames_archive_browser/platform/windows_platform_commands.dart';

import 'package:idgames_archive_browser/service/api_util.dart';
import 'package:idgames_archive_browser/model/archive_model.dart';

import 'package:get_time_ago/get_time_ago.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class RandomEntryPage extends StatefulWidget {
  RandomEntryPage({Key? key}) : super(key: key);
  int? id;
  @override
  State<RandomEntryPage> createState() => _RandomEntryPageState();
}

class _RandomEntryPageState extends State<RandomEntryPage> {
  late Future<SharedPreferences> prefs;
  @override
  void initState() {
    super.initState();
    prefs = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Acrylic(
      tint: Colors.black,
      tintAlpha: 0.1,
      blurAmount: 0.5,
      child: Column(
        children: [
          FutureBuilder<FileElement>(
              future: ApiServiceUtil().getRandomEntry(Random()),
              builder: (context, snapshot) {
                dev.log(snapshot.data.toString());
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: IntrinsicColumnWidth(),
                              1: FixedColumnWidth(550)
                            },
                            border: TableBorder.all(
                              color: Colors.transparent,
                              width: 0,
                            ),
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text("Title:"),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        snapshot.data!.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text("Size:"),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        filesize(
                                            snapshot.data!.size.toString()),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text("Date:"),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        GetTimeAgo.parse(
                                          snapshot.data!.date,
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Rating:",
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: RatingBarIndicator(
                                          rating: snapshot.data!.rating,
                                          itemCount: 5,
                                          itemSize: 15.0,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, _) => Icon(
                                            mat.Icons.star,
                                            color: mat.Colors.amber,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              elevation: 1,
                              child: CommandBar(
                                overflowBehavior:
                                    CommandBarOverflowBehavior.dynamicOverflow,
                                compactBreakpointWidth: 768,
                                primaryItems: [
                                  CommandBarButton(
                                    onPressed: () {
                                      WindowsPlatformCommands()
                                          .runOpenUrl(snapshot.data!.url);
                                    },
                                    icon: Tooltip(
                                        message:
                                            "Open on doomworld.com/idgames",
                                        child: Icon(mat.Icons.open_in_browser)),
                                    label: Text(
                                      "Open on /idgames",
                                      style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold, /* color: Colors.green */
                                      ),
                                    ),
                                  ),
                                  CommandBarSeparator(),
                                  CommandBarButton(
                                    onPressed: () {
                                      WindowsPlatformCommands().runNotepadOnTxtfile(
                                          "C:/Giochi/DOOM/mirror/pc/games/idgames/" +
                                              snapshot.data!.dir +
                                              snapshot.data!.filename);
                                    },
                                    icon: Tooltip(
                                        message:
                                            "Opens the textfile with Notepad",
                                        child: Icon(mat.Icons.note)),
                                    label: Text(
                                      "Read textfile",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  CommandBarSeparator(),
                                  CommandBarButton(
                                    onPressed: () async {
                                      var idGamesMirrorPath = await prefs.then(
                                          (c) =>
                                              c.getString("idGamesMirrorPath"));
                                      var sourcePortPath = await prefs.then(
                                          (c) => c.getString("sourcePortPath"));

                                      var dir = snapshot.data!.dir;

                                      var filename = snapshot.data!.filename;

                                      var argsString =
                                          '${Uri.file(idGamesMirrorPath!, windows: true).toFilePath(windows: false).substring(1)}/${dir}${filename}';

                                      WindowsPlatformCommands().runDoom(
                                          sourcePortPath!,
                                          argsString.toString());
                                    },
                                    icon: Tooltip(
                                        message: "Play with a sourceport",
                                        child: Icon(mat.Icons.play_arrow)),
                                    label: Text(
                                      "Play",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  dev.log(snapshot.data.toString());
                  return Center(
                      child: Expanded(
                          child: Text(
                    "No data from API, try again",
                    textScaleFactor: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )));
                }
                return Expanded(child: Center(child: ProgressRing()));
              }),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: FilledButton(
                child: Text(
                  "Get Random pwad",
                  textScaleFactor: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  var rng = Random();
                  ApiServiceUtil().getRandomEntry(rng);
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
