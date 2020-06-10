import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {
  final String uid;
  HomePage(this.uid);
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

  }




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }





   @override
  Widget build(BuildContext context) {



    return new Scaffold(
       // backgroundColor: Colors.white,

     appBar: AppBar(),
      body: Text(widget.uid),
    );
  }




}










