import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
// import 'package:idgames_archive_browser/platform/preferences_platform.dart';
import 'package:path/path.dart' as pat;
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
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
      child: Card(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.zero,
          topEnd: Radius.zero,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Local IDGames mirror path:",
                          style: TextStyle(fontWeight: mat.FontWeight.bold),
                        ),
                      ),
                      FutureBuilder<String?>(
                          future: prefs
                              .then((c) => c.getString('idGamesMirrorPath')),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextBox(
                                    readOnly: true, placeholder: snapshot.data),
                              );
                            } else if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextBox(
                                    readOnly: true, placeholder: "ERROR"),
                              );
                            } else {
                              return Expanded(
                                child: Center(
                                  child: ProgressRing(),
                                ),
                              );
                            }
                          }),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Card(
                            elevation: 1,
                            child: CommandBar(
                              primaryItems: [
                                CommandBarButton(
                                  icon: Tooltip(
                                    message:
                                        "Choose an IGames mirror path (eg. /mirror/pc/games/idgames/)",
                                    child: Icon(mat.Icons.file_copy),
                                  ),
                                  label: Text(
                                    "Choose",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    String? chosenIdGamesMirrorpath =
                                        await FilesystemPicker.open(
                                      title: 'Choose mirror path',
                                      context: context,
                                      rootDirectory: Directory("C:"),
                                      fsType: FilesystemType.folder,
                                      pickText: 'Choose',
                                      folderIconColor: Colors.teal,
                                    );

                                    try {
                                      prefs.then((p) => p.setString(
                                          "idGamesMirrorPath",
                                          chosenIdGamesMirrorpath!));
                                    } on Exception catch (e) {
                                      log(e.toString());
                                    }
                                  },
                                ),
                                CommandBarSeparator(),
                                CommandBarButton(
                                  icon: Tooltip(
                                    message: "Edit the IDGames mirror path",
                                    child: Icon(mat.Icons.edit),
                                  ),
                                  label: Text(
                                    "Edit",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // TODO: Modal to edit by hand?
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Container(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Sourceport (gzdoom) path:",
                                style:
                                    TextStyle(fontWeight: mat.FontWeight.bold),
                              ),
                            ),
                            FutureBuilder<String?>(
                                future: prefs
                                    .then((c) => c.getString('sourcePortPath')),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextBox(
                                          readOnly: true,
                                          placeholder: snapshot.data),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextBox(
                                          readOnly: true, placeholder: "ERROR"),
                                    );
                                  } else {
                                    return Expanded(
                                      child: Center(
                                        child: ProgressRing(),
                                      ),
                                    );
                                  }
                                }),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Card(
                                  elevation: 1,
                                  child: CommandBar(
                                    primaryItems: [
                                      CommandBarButton(
                                        icon: Tooltip(
                                          message:
                                              "Choose the sourceport path (e.g: gzdoom.exe)",
                                          child: Icon(mat.Icons.file_copy),
                                        ),
                                        label: Text(
                                          "Choose",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () async {
                                          String? chosenSourcePortPath =
                                              await FilesystemPicker.open(
                                            title: 'Choose sourceport path',
                                            context: context,
                                            rootDirectory: Directory("C:"),
                                            fsType: FilesystemType.file,
                                            pickText: 'Choose',
                                            allowedExtensions: ['.exe'],
                                            folderIconColor: Colors.teal,
                                          );

                                          try {
                                            prefs.then((p) => p.setString(
                                                "sourcePortPath",
                                                chosenSourcePortPath!));
                                          } on Exception catch (e) {
                                            log(e.toString());
                                          }
                                        },
                                      ),
                                      CommandBarSeparator(),
                                      CommandBarButton(
                                        icon: Tooltip(
                                          message: "Edit the sourceport path",
                                          child: Icon(mat.Icons.edit),
                                        ),
                                        label: Text(
                                          "Edit",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // TODO: Modal to edit by hand?
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
