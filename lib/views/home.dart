import 'package:docshare/views/receive.dart';
import 'package:docshare/views/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
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
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
                child: Image.asset('assets/logo.png',width: 300,),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
                child: Container(
                  child: Text(
                    'SAFE AND CONVENIENT',
                    style: (TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black.withOpacity(0.2))),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/7),
                padding: EdgeInsets.symmetric(horizontal: 30),
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
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Share(),));
                  },
                  child: Text('SHARE',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/20),
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Receive(),));
                  },
                  child: Text('RECEIVE',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
