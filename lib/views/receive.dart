import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docshare/views/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Receive extends StatefulWidget {
  const Receive({Key? key}) : super(key: key);

  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  bool isav = false;
  final form = GlobalKey<FormState>();

  TextEditingController password = new TextEditingController();

  alert() {
    Alert(
        context: context,
        title: '!!HURRAY!!',
        desc: 'File Downloaded Successfully',
        buttons: [
          DialogButton(
              child: Text(
                'Okay',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {},
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]))
        ]).show();
  }

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }


  Map<String, dynamic>? details;
  Future<QuerySnapshot<Map<String, dynamic>?>> isavailable(String key) async {
    return await FirebaseFirestore.instance
        .collection('files')
        .where('key', isEqualTo: key)
        .get();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.home_filled,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/logo.png',
            width: 50,
          ),
          Text(
            'DOC SHARE',
            style: (TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Oleo',
              fontSize: 25,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.grey,
                  offset: Offset(0.0, 3.0),
                ),
              ],
            )),
          ),
        ]),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.white,
            Colors.lightBlueAccent,
          ],
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: form,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Enter Your Password";
                        }
                      },
                      controller: password,
                      decoration: InputDecoration(
                        fillColor: Colors.black45.withOpacity(0.1),
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'PASSWORD',
                        hintText: 'Enter your Password',
                      ),
                    ),
                    //height: 60,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height - 650),
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        color: Colors.lightBlueAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 2.0,
                            offset: Offset(0.0, 4.0),
                          ),
                        ]),
                    child: MaterialButton(
                        onPressed: () async {
                          if (form.currentState!.validate()) {
                            isavailable(password.text).then((docsData) async {
                              details = docsData.docs.first.data();

                              final status = await Permission.storage.request();

                              if (status.isGranted) {
                                // FlutterDownloader.enqueue(url: url, savedDir: savedDir)
                                _findLocalPath().then((path) {
                                  FlutterDownloader.enqueue(
                                    url: details!["download Url"],
                                    savedDir: path!,
                                    showNotification:
                                        true, // show download progress in status bar (for Android)
                                    openFileFromNotification:
                                        true, // click on notification to open downloaded file (for Android)
                                  );
                                });

                                // ImageDownloader.downloadImage(
                                //   details!["download Url"],
                                //   destination:
                                //       AndroidDestinationType.directoryDownloads
                                //         ..subDirectory(details!["filename"]),
                                // );
                                alert();
                              } else {
                                print("permission Denied");
                              }
                            });
                          } else {}
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 17.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.file_download,
                                color: Colors.black,
                              ),
                              Text(
                                'DOWNLOAD',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }
}
