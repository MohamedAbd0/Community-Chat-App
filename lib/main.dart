import 'package:community_chat_app/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'auth/root/auth.dart';
import 'auth/root/auth_provider.dart';
import 'auth/root/root.dart';

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AppPage());
}

class AppPage extends StatefulWidget {

  @override
  _AppPageState createState() => new _AppPageState();

}



class _AppPageState extends State<AppPage> {

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',

        theme: ThemeData(
          fontFamily: 'Quicksand',
          primaryColor:AppColor,

        ),

        home: RootPage(),

        routes: <String, WidgetBuilder> {

          '/root': (BuildContext context) => new RootPage(),

        },

      ),

    );

  }



}