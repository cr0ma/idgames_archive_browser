import 'dart:developer';
import 'dart:ffi';

import 'package:win32/win32.dart';

class WindowsPlatformCommands {
  runOpenUrl(String url) {
    ShellExecute(
      NULL,
      TEXT('open'),
      TEXT(url),
      nullptr,
      nullptr,
      SW_SHOWNORMAL,
    );
  }

  runNotepadOnTxtfile(String txtfilePath) {
    ShellExecute(0, TEXT('open'), TEXT('notepad.exe'),
        TEXT(txtfilePath.replaceAll(RegExp('zip'), 'txt')), nullptr, SW_SHOW);
    log(txtfilePath);
  }

  runDoom(String sourceport, String pwadPath) {
    ShellExecute(
        0, TEXT('open'), TEXT(sourceport), TEXT(pwadPath), nullptr, SW_SHOW);
  }
}
