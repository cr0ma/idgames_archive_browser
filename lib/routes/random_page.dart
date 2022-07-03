import 'dart:ffi';
import 'dart:math';

import 'package:filesize/filesize.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:idgames_archive_browser/service/api.dart';
import 'package:idgames_archive_browser/service/api_sync.dart';
import 'package:win32/win32.dart';

import 'package:idgames_archive_browser/model/archive_model.dart';

class RandomEntryPage extends StatefulWidget {
  RandomEntryPage({Key? key}) : super(key: key);
  int? id;
  @override
  State<RandomEntryPage> createState() => _RandomEntryPageState();
}

class _RandomEntryPageState extends State<RandomEntryPage> {
  @override
  void initState() {
    super.initState();
  }

  int random(min, max) {
    return min + Random().nextInt(max - min);
  }

  Future<FileElement> _genEntryRandomId() {
    setState(() {
      ApiServiceUtil().getRandomEntryId();
    });
    return ApiService().getEntry(random(1, ApiServiceUtil().randomEntryId));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: IconButton(
              icon: Text(
                "Get Random pwad",
                textScaleFactor: 2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _genEntryRandomId();
              },
            ),
          ),
        ),
        FutureBuilder<FileElement>(
            future: _genEntryRandomId(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
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
                                      child: Text(filesize(
                                          snapshot.data!.size.toString())),
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
                                      child: Text(snapshot.data!.date
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
                          SizedBox(
                            width: 399,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
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
                                            TEXT(snapshot.data!.url),
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
                                        textScaleFactor: 2,
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
                                                "C:/Giochi/DOOM/mirror/pc/games/idgames/${snapshot.data!.dir}/${snapshot.data!.filename.replaceAll(RegExp('zip'), 'txt')}"),
                                            nullptr,
                                            SW_SHOW);
                                      },
                                      icon: Text(
                                        "Read textfile",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textScaleFactor: 2,
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
                                                "C:/Giochi/DOOM/mirror/pc/games/idgames/${snapshot.data!.dir}/${snapshot.data!.filename}"),
                                            nullptr,
                                            SW_SHOW);
                                      },
                                      icon: Text(
                                        "Play",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textScaleFactor: 2,
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
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Expanded(
                        child: Text(
                  "No data from API, try again",
                  textScaleFactor: 2,
                )));
              }
              return Expanded(
                  child: Center(child: mat.CircularProgressIndicator()));
            }),
      ],
    );
  }
}
