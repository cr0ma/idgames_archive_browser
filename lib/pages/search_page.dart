import 'dart:developer';
import 'dart:ffi';

import 'package:filesize/filesize.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as flu;
import 'package:flutter/material.dart' as mat;
import 'package:get_time_ago/get_time_ago.dart';
// import 'package:idgames_archive_browser/platform/preferences_platform.dart';

import 'package:idgames_archive_browser/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:win32/win32.dart';

import 'package:idgames_archive_browser/model/archive_model.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../platform/windows_platform_commands.dart';
import 'package:path/path.dart' as pat;

import 'package:idgames_archive_browser/platform/windows_platform_commands.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String query;

  late Future<SharedPreferences> prefs;
  void initState() {
    super.initState();
    query = "";
    prefs = SharedPreferences.getInstance();

    // prefs = Preferences();
    // idGamesMirrorPath = Preferences().idGamesMirrorPath;
  }

  String? idGamesMirrorPath;
  @override
  Widget build(BuildContext context) {
    return flu.ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Card(
        child: Column(
          children: [
            PageHeader(
              padding: 0,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("IDGames Archive Browser"),
                    ),
                    flu.TextBox(
                      style: TextStyle(fontSize: 16),
                      placeholder: 'Search for pwads here...',
                      onSubmitted: (text) async {
                        if (text.length >= 5) {
                          setState(() {
                            query = text;
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ContentDialog(
                                title: Text("Search error"),
                                content: Text(
                                    "You must at least input a search term major or equal to 5 chars to use the API"),
                                actions: [
                                  FilledButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: CommandBar(
                primaryItems: [
                  CommandBarButton(
                    icon: Icon(mat.Icons.open_in_browser),
                    label: Text(
                      "Open /idgames web frontend",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      ShellExecute(
                        NULL,
                        TEXT('open'),
                        TEXT("https://doomworld.com/idgames"),
                        nullptr,
                        nullptr,
                        SW_SHOWNORMAL,
                      );
                    },
                  ),
                  CommandBarSeparator(),
                  CommandBarButton(
                    icon: Icon(mat.Icons.open_in_browser),
                    label: Text(
                      "Open Doomworld Forum",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      ShellExecute(
                        NULL,
                        TEXT('open'),
                        TEXT("https://doomworld.com/"),
                        nullptr,
                        nullptr,
                        SW_SHOWNORMAL,
                      );
                    },
                  ),
                  CommandBarSeparator(),
                  CommandBarButton(
                    icon: Icon(mat.Icons.code),
                    label: Text(
                      "Open this app GitHub repo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      ShellExecute(
                        NULL,
                        TEXT('open'),
                        TEXT(
                            "https://github.com/cr0ma/idgames_archive_browser"),
                        nullptr,
                        nullptr,
                        SW_SHOWNORMAL,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      content: Acrylic(
        tint: Colors.black,
        tintAlpha: 0.1,
        blurAmount: 0.5,
        child: ListView(
          children: [
            FutureBuilder<Contents>(
              builder: (context, AsyncSnapshot<Contents> snapshot) {
                if (snapshot.hasData) {
                  Contents? data = snapshot.data;
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.content.file.length,
                    itemBuilder: (context, index) {
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
                                            snapshot.data!.content.file[index]
                                                .title,
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
                                            filesize(snapshot
                                                .data!.content.file[index].size
                                                .toString()),
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
                                              snapshot.data!.content.file[index]
                                                  .date,
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
                                            "Rating",
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: RatingBarIndicator(
                                              rating: snapshot.data!.content
                                                  .file[index].rating,
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
                                    overflowBehavior: CommandBarOverflowBehavior
                                        .dynamicOverflow,
                                    compactBreakpointWidth: 768,
                                    primaryItems: [
                                      CommandBarButton(
                                        onPressed: () {
                                          WindowsPlatformCommands().runOpenUrl(
                                              snapshot.data!.content.file[index]
                                                  .url);
                                        },
                                        icon: Tooltip(
                                            message:
                                                "Open on doomworld.com/idgames",
                                            child: Icon(
                                                mat.Icons.open_in_browser)),
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
                                        onPressed: () async {
                                          var idGamesMirrorPath = await prefs
                                              .then((c) => c.getString(
                                                  "idGamesMirrorPath"));
                                          WindowsPlatformCommands()
                                              .runNotepadOnTxtfile(
                                                  idGamesMirrorPath! +
                                                      "\\" +
                                                      snapshot.data!.content
                                                          .file[index].dir +
                                                      snapshot
                                                          .data!
                                                          .content
                                                          .file[index]
                                                          .filename);
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
                                          var idGamesMirrorPath = await prefs
                                              .then((c) => c.getString(
                                                  "idGamesMirrorPath"));
                                          var sourcePortPath = await prefs.then(
                                              (c) => c
                                                  .getString("sourcePortPath"));

                                          var dir = snapshot
                                              .data!.content.file[index].dir;

                                          var filename = snapshot.data!.content
                                              .file[index].filename;

                                          var argsString =
                                              '${Uri.file(idGamesMirrorPath!, windows: true).toFilePath(windows: false).substring(1)}/${dir}${filename}';
                                          log(argsString.toString());
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
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Container(
                      child: Expanded(
                        child: Text(
                          "No results",
                          textScaleFactor: 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Expanded(child: Center(child: ProgressRing()));
              },
              future: ApiService().getListEntry(query),
            ),
          ],
        ),
      ),
    );
  }
}
