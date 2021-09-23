import 'dart:io';
import 'dart:math';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Success.dart';


class Share extends StatefulWidget {
  const Share({Key? key}) : super(key: key);
  @override
  _ShareState createState() => _ShareState();
}



class _ShareState extends State<Share> {

  bool error  = false;
  String genPass() {
    final length = 20;
    final lc = 'qwertyuiopasdfghjklzxcvbnm';
    final uc = 'QWERTYUIOPASDFGHJKLZXCVBNM';
    final num = '0123456789';

    String chars = '';
    chars += '$uc$lc';
    chars += '$num';

    return List.generate(length, (index){
      final ir = Random.secure().nextInt(chars.length);
      return chars[ir];
    }).join('');
  }

  File? _file;
    String filename = 'no file selected';
  selectFile()async{
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if(result != null) {
        setState(() {
          error = false;
          _file = File(result.files.single.path);
          filename = result.files.single.name;
        });
      }
  }


  String key= '';
  uploadFile() async{
    if(_file != null){
      final ref = await FirebaseStorage.instance.ref().child('files').child(filename);
      await ref.putFile(_file!);
      String down = (await ref.getDownloadURL()).toString();
      setState(() {
        key = genPass();
      });
      await FirebaseFirestore.instance.collection('files').doc().set({'filename': filename,'key': key, 'download Url': down });
    }
    else{
      setState(() {
        error = true;
        filename = 'Please select a file.';
      });
    }

  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.home_filled,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          'DOC SHARE',style: (TextStyle(
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
            )
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 0,top: 70),
                height: 120,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                      'Selected Files',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                        filename,
                        style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color: error? Colors.red:Colors.black),
                      ),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 200),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    color: Colors.lightBlueAccent,
                    boxShadow: [BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 4.0),
                    ),
                    ]
                ),
                child: MaterialButton(
                  onPressed: () async {
                    selectFile();
                    },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Icon(Icons.attach_file,color: Colors.black,),
                        Text('SELECT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                       ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 70),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    color: Colors.lightGreenAccent,
                    boxShadow: [BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 4.0),
                    ),
                    ]
                ),
                child: MaterialButton(
                  onPressed: () async{
                    await uploadFile();
                    if(!error){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Success(passcode: key,),));
                    }

                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Icon(Icons.upload_file,color: Colors.black,),
                        Text('UPLOAD',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      ],
                    ),
                  ),
                 ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





