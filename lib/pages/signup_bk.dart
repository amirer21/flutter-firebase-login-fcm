import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../methods/validators.dart';
import '../methods/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import '../widgets/message.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);
  static const routeName = '/signup';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController = TextEditingController();
  TextEditingController lastNameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController confirmPasswordInputController = TextEditingController();
  bool _loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
  }

  _googleSignIn () async {
    final bool isSignedIn = await GoogleSignIn().isSignedIn();
    GoogleSignInAccount googleUser;
    if (isSignedIn) googleUser = await GoogleSignIn().signInSilently();
    else googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final User user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    return user;
  }

  Widget _loadingWidget () {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _formWidget () {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'First name*',
                      hintText: 'Hong',
                      border: OutlineInputBorder(),
                    ),
                    controller: firstNameInputController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a valid first name.';
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Last name*',
                      hintText: 'Gil dong',
                      border: OutlineInputBorder(),
                    ),
                    controller: lastNameInputController,
                    validator: (value) {
                      if (value.length < 1) return 'Please enter a valid last name.';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Email*',
                  hintText: "abc@gmail.com",
                  border: OutlineInputBorder()
              ),
              controller: emailInputController,
              keyboardType: TextInputType.emailAddress,
              validator: emailValidator,
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Password*',
                  hintText: "********",
                  border: OutlineInputBorder()
              ),
              controller: passwordInputController,
              obscureText: true,
              validator: passwordValidator,
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Confirm password*',
                  hintText: "********",
                  border: OutlineInputBorder()
              ),
              controller: confirmPasswordInputController,
              obscureText: true,
              validator: passwordValidator,
            ),
            SizedBox(height: 10,),
            SignInButtonBuilder(
              text: '이메일 아이디로 가입하기',
              icon: Icons.email,
              backgroundColor: Colors.blueGrey[700],
              onPressed: () async {
                print("등록"+ emailInputController.text);
                //아이디
                print("아이디"+ emailInputController.text);
                //비밀번호
                print("비번"+ passwordInputController.text);
                //mysql 아이디/비번 저장 시작
                var uri = Uri.parse('https://52.78.200.86/flutter_register.php');
                try {
                  final ioc = new HttpClient();
                  ioc.badCertificateCallback =
                      (X509Certificate cert, String host, int port) => true;
                  final http = new IOClient(ioc);
                  http.post(uri, body: {"email": emailInputController.text, "password": passwordInputController.text}).then(
                          (response) {
                        print("Reponse status : ${response.statusCode}");
                        print("Response body : ${response.body}");
                        var myresponse = jsonDecode(response.body);
                        String token = myresponse["token"];
                      });
                } catch (e) {
                  print(e.toString());
                }
                //mysql 아이디/비번 저장 끝
                if (!_formKey.currentState.validate()) return;
                if (passwordInputController.text != confirmPasswordInputController.text) {
                  toastError(_scaffoldKey, PlatformException(code: 'signup', message: 'Please check your password again.'));
                  return;
                }
                try {
                  setState(() => _loading = true);
                  final r = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailInputController.text,
                      password: passwordInputController.text
                  );

/*
                  final userInfo = UserUpdateInfo();
                  userInfo.photoUrl = 'https://ssl.gstatic.com/ui/v1/icons/mail/rfr/logo_gmail_lockup_default_1x.png';
                  userInfo.displayName = firstNameInputController.text + ' ' + lastNameInputController.text;
                  await r.user.updateProfile(userInfo);
                  await r.user.reload();
                  await r.user.sendEmailVerification();
*/
                  await FirebaseAuth.instance.currentUser.updateProfile(
                    photoURL: 'https://ssl.gstatic.com/ui/v1/icons/mail/rfr/logo_gmail_lockup_default_1x.png',
                  );
                  await r.user.updateProfile(displayName: firstNameInputController.text + ' ' + lastNameInputController.text);
                  await r.user.reload();
                  await r.user.sendEmailVerification();
                  //await FirebaseFirestore.instance.collection('users').add({ 'email': emailInputController.text, 'uid': "test123123" });
                  Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
                  print("완료");
                } catch (e) {
                  toastError(_scaffoldKey, e);
                  print(e);
                } finally {
                  if (mounted) setState(() => _loading = false);
                }
              },
            ),
            // SizedBox(height: 10,),
            Text('or'),
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                try {
                  setState(() => _loading = true);
                  await _googleSignIn();
                  Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
                } catch (e) {
                  toastError(_scaffoldKey, e);
                } finally {
                  setState(() => _loading = false);
                }
              },
            ),
            SizedBox(height: 20,),
            Text("이미 계정이 있으신가요?"),
            FlatButton(
              child: Text('로그인'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: _loading ? _loadingWidget() : _formWidget()
      ),
    );
  }
}