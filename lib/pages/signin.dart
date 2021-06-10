import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../methods/toast.dart';
import '../methods/validators.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);
  static const routeName = '/signin';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _googleSignIn () async {
    //GoogleSignIn 신원정보 가져오기 시작
    final bool isSignedIn = await GoogleSignIn().isSignedIn();
    GoogleSignInAccount googleUser;
    //이전에 인증된 사용자 정보가 있다면 해당 사용자로 로그인 시도
    if (isSignedIn) googleUser = await GoogleSignIn().signInSilently();
    //현재 로그인 사용자가 없는 경우
    //currentUser == null 인 경우에만 인증 프로세스가 진행
    else googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    //접근토큰, id 토큰
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //최종 인증 결과가져오기
    final User user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    // print("signed in " + user.displayName);
    return user;
  }

  _buildLoading() {
    return Center(child: CircularProgressIndicator(),);
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'eg) abc@xxx.com',
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
              ),
              // Container(height: 10,),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'eg) very hard key',
                  border: OutlineInputBorder(),
                ),
                controller: passwordController,
                obscureText: true,
                validator: passwordValidator,
              ),
              SizedBox(height: 10,),
              SignInButton(
                Buttons.Email,
                onPressed: () async {
                  if (!_formKey.currentState.validate()) return;
                  try {
                    setState(() => _loading = true);
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    Navigator.pushReplacementNamed(context, '/auth');
                  } catch (e) {
                    toastError(_scaffoldKey, e);
                  } finally {
                    setState(() => _loading = false);
                  }
                },
              ),
              Text('or'),
              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  try {
                    setState(() => _loading = true);
                    await _googleSignIn();
                    // Navigator.pushReplacementNamed(context, '/');
                    Navigator.pushReplacementNamed(context, '/auth');
                    // Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    toastError(_scaffoldKey, e);
                  } finally {
                    setState(() => _loading = false);
                  }
                },
              ),
              SizedBox(height: 20,),
              Text("계정이 없으신가요?"),
              FlatButton(
                child: Text('회원가입'),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Sign in'), ),
        body: _loading ? _buildLoading() : _buildBody()
    );
  }
}