import 'dart:io';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/data.dart';
import 'package:flutter_whoiswho/ui/AppColors.dart';
import 'package:flutter_whoiswho/ui/game_screen.dart';
import 'package:flutter_whoiswho/widgets/choice_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nice_button/nice_button.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  final String databaseUrl =
      "https://api.github.com/repos/Tantan4321/flutter-whoiswho/contents/database_dir";
  bool isLoading = false;
  double downloadProgress = 0.0;
  Future<List<String>> remoteFiles;

  @override
  void initState() {
    super.initState();
    remoteFiles = _fetchZips();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<String>> _fetchZips() async {
    var response;
    try {
      response = await http.get(databaseUrl);
    } catch (StackTrace) {}

    List<String> remoteDecks = [];

    if (response.statusCode == 200) {
      List<dynamic> responseJson = jsonDecode(response.body);
      responseJson.forEach((json) {
        if (json["name"].endsWith('.zip')) {
          remoteDecks.add(json["name"]);
        }
      });
    }

    // See which remote decks have already been downloaded
    List<String> localDecks = await existingDecks(remoteDecks);
    localDecks.forEach((zipName) {
      if (remoteDecks.contains("$zipName.zip")) {
        remoteDecks[remoteDecks.indexOf("$zipName.zip")] = zipName;
      }
    });

    return remoteDecks;
  }

  Future<List<String>> existingDecks(List<String> remoteDecks) async {
    List<String> existingDecks = new List<String>();

    Stream<FileSystemEntity> entityList =
        (await loadAppDir).list(recursive: false, followLinks: false);
    await for (FileSystemEntity entity in entityList) {
      if (entity is Directory &&
          remoteDecks.contains(
              "${entity.path.substring(entity.path.lastIndexOf("/") + 1)}.zip")) {
        if (FileSystemEntity.typeSync("${entity.path}/data.whoiswho") !=
            FileSystemEntityType.notFound) {
          var finalPath =
              entity.path.substring(entity.path.lastIndexOf('/') + 1);
          existingDecks.add(finalPath);
        }
      }
    }
    return existingDecks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteSmoke,
        body: FutureBuilder<List<String>>(
            future: remoteFiles,
            builder: (context, snapshot) {
              return Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Select an option below to play WhoIsWho!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height / 2.7),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          NiceButton(
                            radius: 40,
                            padding: EdgeInsets.all(15),
                            background: Colors.teal,
                            onPressed: () {
                              startGame(data.jsonData);
                            },
                            text: "Use Default Deck",
                          ),
                          NiceButton(
                            radius: 40,
                            padding: EdgeInsets.all(15),
                            background: Colors.teal,
                            onPressed: () async {
                              File file = await FilePicker.getFile(
                                  type: FileType.ANY,
                                  fileExtension: "whoiswho");
                              if (file.exists() != null) {
                                try {
                                  final parsed = Map<String, dynamic>.from(
                                      json.decode(await file.readAsString()));
                                  startGame(parsed);
                                } on Exception catch (e) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Incorrect format! File must be .whoiswho",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM);
                                }
                              }
                            },
                            text: "Choose From Device",
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Load from Web Database:",
                            style: TextStyle(
                                fontSize: 22.0,
                                color: AppColors.copper,
                                fontWeight: FontWeight.bold),
                          )
                        ])),
                Divider(),
                if (snapshot.hasData && !snapshot.hasError)
                  ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.black,
                          ),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: DataChoiceCard(
                            name: snapshot.data[index],
                            onPressed: () async {
                              Map<String, dynamic> deck =
                                  await getDeck(snapshot.data[index]);
                              startGame(deck);
                            },
                          ),
                        );
                      },
                      itemCount: snapshot.data.length)
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
              ]);
            }));
  }

  Future<Directory> get loadAppDir async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir;
  }

  Future<Map<String, dynamic>> _getDownloadInfo(String url, String name) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> responseJson = jsonDecode(response.body);
      for (int i = 0; i < responseJson.length; i++) {
        Map<String, dynamic> json = responseJson[i];
        if (json["name"] == name) {
          return json;
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: "Fetching data from database failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
      throw Exception();
    }
  }

  Future<Map<String, dynamic>> downloadDeck(String chosenName) async {
    Map<String, dynamic> downloadJson =
        await _getDownloadInfo(this.databaseUrl, chosenName);

    final String path = (await loadAppDir).path;

    Fluttertoast.showToast(
        msg: "Downloading deck...",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);

    Dio dio = new Dio();

    String fileName = downloadJson["name"];
    await dio.download(downloadJson["download_url"], "$path/$fileName",
        onReceiveProgress: (rec, total) {
      downloadProgress = (rec / total);
    });

    // Unzip file and return the deck data
    Map<String, dynamic> ret = await unzip(path, fileName);
    return ret;
  }

  Future<Map<String, dynamic>> unzip(String path, String zipName) async {
    Map<String, dynamic> returnJson;

    final rawFile = File("$path/$zipName").readAsBytesSync();

    String saveDirName =
        "$path/${zipName.substring(0, zipName.lastIndexOf('.zip'))}";

    final archive = ZipDecoder().decodeBytes(rawFile); // Unzip file
    for (final file in archive) {
      final fileName = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$saveDirName/' + fileName)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
        if (file.name == "data.whoiswho") {
          // check that file is in with correct format
          returnJson = await parseJson(File('$saveDirName/' + file.name));
        }
      } else {
        Directory('$saveDirName/' + fileName)..create(recursive: true);
      }
    }
    return returnJson;
  }

  Future<Map<String, dynamic>> parseJson(File file) async {
    String contents = await file.readAsString();
    var jsonify = jsonDecode(contents);
    if (jsonify is Map<String, dynamic>) {
      return jsonify;
    } else {
      return jsonify[0] as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> loadFromLocal(String fileName) async {
    final dir = await loadAppDir;
    final path = dir.path;

    Map<String, dynamic> ret =
        await parseJson(File("$path/$fileName/data.whoiswho"));
    return ret;
  }

  Future<Map<String, dynamic>> getDeck(String inp) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> deck;

    if (inp.endsWith('.zip')) {
      // Deck requested to be downloaded
      deck = await downloadDeck(inp);
    } else {
      // Deck already exists locally
      deck = await loadFromLocal(inp);
    }
    return deck;
  }

  void startGame(Map<String, dynamic> deckJson) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => GameScreen(context, deckJson)));
    setState(() {
      isLoading = false;
    });
  }
}
