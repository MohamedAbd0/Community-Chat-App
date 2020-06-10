import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loadingHub(BuildContext context){
  return Center(
    child: Container(
      child: Card(
        color: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 100,
          width: 100,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(backgroundColor: Colors.white,),
                SizedBox(height: 10,),
                Text('loading',style: TextStyle(color: Colors.white),)
              ],
            ),
          ),
        ),

      ),
    ),
  );
}