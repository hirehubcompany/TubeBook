import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tubebook/authentication/register.dart';

import '../widgets/constant.dart';
import '../widgets/custom button.dart';
import '../widgets/custom input.dart';



class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _alertDialogBuilder(String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text('Error'),
            content: Container(
              child:  Text(error),
            ),
            actions: [
              ElevatedButton(
                child: Text('Close Dialog'),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<String?> _loginAccount() async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
      return null;
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;

    } catch (e) {
      return e.toString();

    }
  }

  void _submitForm() async{
    setState(() {
      _loginFormLoading = true;
    });

    String? _loginFeedback = await _loginAccount();
    if(_loginFeedback != null){
      _alertDialogBuilder( _loginFeedback);

      setState(() {
        _loginFormLoading = false;
      });
    }

  }


  bool _loginFormLoading = false;

  String _loginEmail = '';
  String _loginPassword = '';

  late FocusNode _passwordFocusNode;
  late FocusNode _emailFocusNode;



  //not yet
  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    _emailFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose;
    _emailFocusNode.dispose;

    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation,deviceType){
      return Scaffold(

        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Text('Welcome User, \n Login to your Account',
                      textAlign: TextAlign.center,
                      style: Constants.boldHeading,
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Column(
                    children: [
                      CustomInput(
                        hintText: 'Email',
                        onChanged: (value) {
                          _loginEmail = value;
                        },
                        textInputAction: TextInputAction.next,
                        isPasswordField: false,
                        onSubmitted: (String) async {
                          _passwordFocusNode;

                        },
                        focusNode: _emailFocusNode,
                      ),

                      CustomInput(
                        hintText: 'Password',
                        onChanged: (value){
                          _loginPassword = value;
                        },
                        isPasswordField: true,
                        focusNode: _passwordFocusNode,
                        onSubmitted: (value){
                          _submitForm();
                        },
                        textInputAction: TextInputAction.next,
                      ),


                      GestureDetector(
                        onTap: (){
                          _submitForm();
                        },

                        child: CustomBtn(
                          text: 'Login',
                          outlineBtn: false,
                          isLoading: _loginFormLoading,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5.h,),
                  Padding(
                    padding: const EdgeInsets.only( bottom: 12.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>const RegisterPage()
                        )
                        );
                      },
                      child: CustomBtn(
                        text: 'Create New Account',

                        outlineBtn: true,
                        isLoading: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}