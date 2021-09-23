import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Success extends StatelessWidget {

  final String passcode;
  const Success({Key? key,required this.passcode}) : super(key: key);

  @override
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
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[SizedBox(
                  height: 200,
                ),
                  Text(
                  'FILE UPLOADED SUCCESSFULLY',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                ),]
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'PASSCODE',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Text(
                    this.passcode,
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: IconButton(onPressed: (){
                      FlutterClipboard.copy(passcode);
                    }, icon: Icon(Icons.copy,size: 37))
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:100),
              child: Text(
                'Copy The Passcode',
                style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.5)),
              ),
            )
          ],
        ),
      ),
    );
  }
}