import 'package:flutter/material.dart';
import 'pages/splash.dart';
import 'pages/auth.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages/home.dart';
import 'pages/profile.dart';
import 'pages/profile_edit.dart';
import 'package:firebase_core/firebase_core.dart';

//void main() => runApp(MyApp());
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & Firebase',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: SplashPage.routeName,
      routes: {
        AuthPage.routeName: (context) => AuthPage(),
        SignInPage.routeName: (context) => SignInPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
      },
      //라우터 이름에 따라 네비게이팅
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomePage.routeName: {
            return MaterialPageRoute(
                builder: (context) => HomePage(user: settings.arguments)
            );
          } break;

          case ProfilePage.routeName: {
            return MaterialPageRoute(
                builder: (context) => ProfilePage(user: settings.arguments)
            );
          } break;

          case ProfileEditPage.routeName: {
            return MaterialPageRoute(
                builder: (context) => ProfileEditPage(user: settings.arguments)
            );
          } break;

          default: {
            return MaterialPageRoute(
                builder: (context) => SplashPage()
            );
          } break;
        }
      },
    );
  }
}