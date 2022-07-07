import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:idgames_archive_browser/pages/config_page.dart';
import 'package:idgames_archive_browser/pages/random_page.dart';
import 'package:idgames_archive_browser/pages/search_page.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late String query;
  int currentView = 0;
  @override
  void initState() {
    super.initState();
    currentView = 0;
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
        debugShowCheckedModeBanner: false,
        home: NavigationView(
          pane: NavigationPane(
            selected: currentView,
            onChanged: (i) => setState(() => currentView = i),
            items: [
              PaneItem(
                icon: Icon(mat.Icons.search),
                title: Text("Search"),
              ),
              PaneItem(
                icon: Icon(mat.Icons.question_mark),
                title: Text("Random"),
              ),
              PaneItem(
                icon: Icon(mat.Icons.settings),
                title: Text("Config"),
              ),
            ],
            displayMode: PaneDisplayMode.top,
          ),
          appBar: NavigationAppBar(
            actions: Row(children: []),
          ),
          content: NavigationBody(
            index: currentView,
            children: [
              SearchPage(),
              RandomEntryPage(),
              ConfigPage(),
            ],
          ),
        ));
  }
}
