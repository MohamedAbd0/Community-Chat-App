import 'dart:async';
import 'package:community_chat_app/helper/string_helper.dart';
import 'package:community_chat_app/widigets/loadingHub.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:community_chat_app/text_style/text_style.dart';
import 'package:code_input/code_input.dart';
import 'package:community_chat_app/ui/home.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  String phoneNo;
  String smsCode;
  String verificationId;
  bool loading = false;
  TextEditingController _phoneController =new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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

  Future<void> verifyPhone() async {


    try{

      phoneNo =_phoneController.text;


      if(_formKey.currentState.validate()){
        setState(() {
          loading = true;
        });
        phoneNo ='+20'+phoneNo;
        print(phoneNo);

          final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
            this.verificationId = verId;
          };

          final PhoneCodeSent smsCodeSent = (String verId,
              [int forceCodeResend]) {
            this.verificationId = verId;
            smsCodeDialog(context);
          };

          final PhoneVerificationFailed verificationFailed = (AuthException authException){

            print('${authException.message}');

            EdgeAlert.show(context, title: 'alert', description:authException.message , gravity: EdgeAlert.TOP , backgroundColor:Colors.red,duration: 5);

            setState(() {
              loading = false;
            });

          };

        final PhoneVerificationCompleted verificationCompleted =
            (AuthCredential phoneAuthCredential) {

              FirebaseAuth.instance.currentUser().then((user){
                loginStep(user);

              });



            };


          await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: this.phoneNo,
              codeAutoRetrievalTimeout: autoRetrieve,

              codeSent: smsCodeSent,
              timeout: const Duration(seconds: 5),
              verificationCompleted: verificationCompleted,
              verificationFailed: verificationFailed);

      }
    }
    catch(e){
      //print(e);
    }
  }


  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            backgroundColor: AppColor,
            title: Text('Enter a send code',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            content: Container(
              height: 100,
              child: Center(
                child: CodeInput(
                  length: 6,
                  keyboardType: TextInputType.number,
                  builder: CodeInputBuilders.rectangle(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                      textStyle: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),
                      emptySize: Size(25.0, 30.0),
                      totalSize: Size(30.0, 30.0)),

                  onFilled: (codeValue){
                    this.smsCode = codeValue;
                    Navigator.pop(context);
                    signIn();
                  },
                  onChanged: (codeValue){
                    this.smsCode = codeValue;

                  },
                ),
              ),
            ),

          );
        });
  }


  signIn() {

    setState(() {
      loading = true;
    });
    //Navigator.pop(context);
    //Navigator.of(context, rootNavigator: true).pop('dialog');

    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((user) {
      loginStep(user.user);

    }).catchError((e) {

      if(e.toString().contains('Cannot create PhoneAuthCredential without either verificationProof, sessionInfo, ortemprary proof., null') || e.toString().contains('The sms verification code used to create the phone auth credential is invalid')){

        EdgeAlert.show(context, title: 'alert', description:e.toString(), gravity: EdgeAlert.TOP , backgroundColor:Colors.red );

        smsCodeDialog(context);
      }

      setState(() {
        loading = false;
      });
      print(e);
    });
  }

  loginStep(FirebaseUser user){

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => HomePage(user.uid)),
      ModalRoute.withName('/'),
    );
    EdgeAlert.show(context, title: 'Done', description: 'Login Success', gravity: EdgeAlert.TOP , backgroundColor:Colors.green);



  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);


    return
      Scaffold(
        // backgroundColor: Colors.amber,
          body: ModalProgressHUD(
            inAsyncCall: loading,
            progressIndicator: loadingHub(context),
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: new SingleChildScrollView(
                  child: Column( children: <Widget>[

                    Container(
                        height: MediaQuery.of(context).size.height*0.50,
                        child: Center(

                          child: Container(
                            height: MediaQuery.of(context).size.height*0.30,
                            child: Image.asset("assets/images/logo.png")
                          ),
                        )

                    ),

                    Container(
                      height: MediaQuery.of(context).size.height*0.50,
                      padding: EdgeInsets.all(20),
                      child:Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.center,
                            style: defaultTextStyleDark,
                            controller: _phoneController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: BorderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: BorderColor),
                                ),
                                suffixIcon: Icon(Icons.phone,color: IconColor),


                                hintText: "Enter phone number",
                                hintStyle:defaultTextStyleOpacity

                            ),

                            validator: (String arg) {
                              if(!validateMobile(_phoneController.text))
                                return "invalid phone number" ;
                              else
                                return null;
                            },

                          ),

                          SizedBox(height: 50.0),
                          FlatButton(
                            color: AppColor,
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                            child: Container(
                                padding: EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
                                child: Text("Login",style: defaultTextStyleBigSizeLight,)
                            ),
                            onPressed: ()=>verifyPhone(),
                          )

                        ],
                      ) ,

                    )
                  ],
                  )
              ),
            ),
          )

      );

  }




}
















