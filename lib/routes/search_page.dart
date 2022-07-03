import 'dart:ffi';

import 'package:filesize/filesize.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;

import 'package:idgames_archive_browser/service/api.dart';
import 'package:win32/win32.dart';

import 'package:idgames_archive_browser/model/archive_model.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
    return ListView(
      children: [
        Container(
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                                          snapshot
                                              .data!.content.file[index].title,
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
                                        child: Text(filesize(snapshot
                                            .data!.content.file[index].size
                                            .toString())),
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
                                        child: Text(snapshot
                                            .data!.content.file[index].date
                                            .toIso8601String()),
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
                            // SizedBox(
                            //   width: 400,
                            // ),
                            Row(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  flex: 0,
                                  child: new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: IconButton(
                                        onPressed: () {
                                          ShellExecute(
                                              NULL,
                                              TEXT('open'),
                                              TEXT(snapshot.data!.content
                                                  .file[index].url),
                                              nullptr,
                                              nullptr,
                                              SW_SHOWNORMAL);
                                        },
                                        icon: Text(
                                          "View on /idgames",
                                          style: TextStyle(
                                            fontWeight: FontWeight
                                                .bold, /* color: Colors.green */
                                          ),
                                          textScaleFactor: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 0,
                                  child: new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: IconButton(
                                        onPressed: () {
                                          ShellExecute(
                                              0,
                                              TEXT('open'),
                                              TEXT('notepad.exe'),
                                              TEXT(
                                                  "C:/Giochi/DOOM/mirror/pc/games/idgames/${snapshot.data!.content.file[index].dir}/${snapshot.data!.content.file[index].filename.replaceAll(RegExp('zip'), 'txt')}"),
                                              nullptr,
                                              SW_SHOW);
                                        },
                                        icon: Text(
                                          "Read textfile",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaleFactor: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 0,
                                  child: new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: IconButton(
                                        onPressed: () {
                                          ShellExecute(
                                              0,
                                              TEXT('open'),
                                              // TODO: Make the user pick the sourceport
                                              TEXT('C:/Giochi/DOOM/gzdoom.exe'),
                                              TEXT(
                                                  "C:/Giochi/DOOM/mirror/pc/games/idgames/${snapshot.data!.content.file[index].dir}/${snapshot.data!.content.file[index].filename}"),
                                              nullptr,
                                              SW_SHOW);
                                        },
                                        icon: Text(
                                          "Play",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaleFactor: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                )));
              }
              return Expanded(
                  child: Center(child: mat.CircularProgressIndicator()));
            },
            future: ApiService().getListEntry(query),
          ),
        ),
      ],
    );
  }
}
