import 'dart:ffi';

import 'package:filesize/filesize.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:get_time_ago/get_time_ago.dart';

import 'package:idgames_archive_browser/service/api.dart';
import 'package:win32/win32.dart';

import 'package:idgames_archive_browser/model/archive_model.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../platform/windows_platform_commands.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String query;
  void initState() {
    super.initState();
    query = "";
  }

  @override
  Widget build(BuildContext context) {
    return Acrylic(
      tint: Colors.black,
      tintAlpha: 0.1,
      blurAmount: 0.5,
      child: ListView(
        children: [
          Card(
            elevation: 1.5,
            child: Container(
              child: mat.Material(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: mat.TextField(
                    onSubmitted: (text) async {
                      if (text.length >= 5) {
                        setState(() {
                          query = text;
                        });
                      }
                    },
                    decoration: mat.InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      isDense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15.0),
                      /* -- Text and Icon -- */
                      hintText: "Search for pwads...",
                      hintStyle: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFFB3B1B1),
                      ), // TextStyle
                      suffixIcon: const Icon(
                        mat.Icons.search,
                        size: 26,
                        color: mat.Colors.black54,
                      ), // Icon
                      /* -- Border Styling -- */
                      border: mat.OutlineInputBorder(
                        borderRadius: BorderRadius.circular(45.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: Color(0xFFFF0000),
                        ), // BorderSide
                      ), // mat.OutlineInputBorder
                      enabledBorder: mat.OutlineInputBorder(
                        borderRadius: BorderRadius.circular(45.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: mat.Colors.grey,
                        ), // BorderSide
                      ), // mat.OutlineInputBorder
                      focusedBorder: mat.OutlineInputBorder(
                        borderRadius: BorderRadius.circular(45.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: mat.Colors.grey,
                        ), // BorderSide
                      ), // mat.OutlineInputBorder
                    ), // InputDecoration
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: FutureBuilder<Contents>(
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
                                      CommandBarButton(
                                        onPressed: () {
                                          WindowsPlatformCommands()
                                              .runNotepadOnTxtfile(
                                                  "C:/Giochi/DOOM/mirror/pc/games/idgames/" +
                                                      snapshot.data!.content
                                                          .file[index].url +
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
                                      CommandBarButton(
                                        onPressed: () {
                                          WindowsPlatformCommands().runDoom(
                                              "C:/Giochi/DOOM/gzdoom.exe",
                                              "C:/Giochi/DOOM/mirror/pc/games/idgames/" +
                                                  snapshot.data!.content
                                                      .file[index].dir +
                                                  snapshot.data!.content
                                                      .file[index].filename);
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
                    child: Expanded(
                      child: Text(
                        "No results",
                        textScaleFactor: 2,
                      ),
                    ),
                  );
                }
                return Expanded(child: Center(child: ProgressRing()));
              },
              future: ApiService().getListEntry(query),
            ),
          ),
        ],
      ),
    );
  }
}
