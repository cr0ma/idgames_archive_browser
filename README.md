# IDgames Archive Browser

A Flutter application that can search the idgames API and display data about levels.
With a local mirror (at the moment not automatically generated) of files, can also view textfile, and play it with (at the moment hardcoded) gzdoom.exe.

# Purpose

Learn flutter. In particular, the API calls and the UI. If you have any suggestion well feel free to suggest so. 

# Screenshot

![Search](https://i.imgur.com/wn29iYs.jpeg)

# How can I generate a mirror of /idgames?

With ftpgrab (or maybe another application), do this config:

```
db:
  path: ftpgrab.db

server:
  ftp:
    host: ftp.fu-berlin.de
    port: 21
    sources:
      - /pc/games/idgames/levels/doom/
      - /pc/games/idgames/levels/doom2/
    username: USER
    password: PASS
    timeout: 5s

download:
  output: ./
  retry: 3
  hideSkipped: false
  createBaseDir: true
```

And wait a couple of hours, the archive is approximately about 17,8 in GB.


You can also sync it with this silly batch call:

```
.\ftpgrab.exe --config .\config.yml
```

And maybe modify the win32 calls in the app to reflect your preferences.

# This app is utter garbage

I'm sorry. :(