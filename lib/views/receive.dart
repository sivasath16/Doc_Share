import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docshare/views/home.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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

  alert(){
    Alert(
        context: context,
        title: '!!HURRAY!!',
        desc: 'File Downloaded Successfully',
        buttons: [
          DialogButton(
              child: Text('Okay',style: TextStyle(fontSize: 20),),
              onPressed: (){
              },
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]
              )
          )
        ]
    ).show();
  }
  
  Map<String,dynamic>? details;
  isavailable(String key)async{
    await FirebaseFirestore.instance
        .collection('files')
        .where('key',isEqualTo: key)
        .get()
        .then((QuerySnapshot<Map<String,dynamic>> snapshot) => {
          if(snapshot.docs.single.exists){
            setState((){
              isav = true;
              details = snapshot.docs.single.data();
            }),
          }
        });
  }
  
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.home_filled,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Image.asset('assets/logo.png',width: 50,),
              Text(
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
            )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: form,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: TextFormField(
                      validator: (val){
                        if(val == null || val.isEmpty){
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
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height-650),
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        color: Colors.lightBlueAccent,
                        boxShadow: [BoxShadow(
                          color: Colors.black45,
                          blurRadius: 2.0,
                          offset: Offset(0.0, 4.0),
                        ),
                        ]
                    ),
                    child: MaterialButton(
                      onPressed: ()async{
                        isavailable(password.text);
                        if(form.currentState!.validate() && isav){
                          alert();
                          print(details?['download Url']);
                        }
                        final status  = await Permission.storage.request();

                        if(status.isGranted){

                          final externalDir = await getExternalStorageDirectory();

                          final id = await FlutterDownloader.enqueue(
                              url: "",
                              savedDir: externalDir!.path,
                            fileName: "download",
                            showNotification: true,
                            openFileFromNotification: true,
                          );
                        }else{
                          print("permission Denied");
                        }

                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17.0),
                        child: Row(
                          children: [
                            Icon(Icons.file_download,color: Colors.black,),
                            Text('DOWNLOAD',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          ],
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


