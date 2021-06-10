import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as UserClass;
import '../widgets/loading.dart';
import '../widgets/message.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key key, this.user}) : super(key: key);
  static const routeName = '/home';
  final User user;

  Widget _buildProfile(context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        child: CircleAvatar(
            backgroundImage: (user.photoURL == null) ? AssetImage('assets/icon.png') : NetworkImage(user.photoURL),
            //backgroundImage: NetworkImage(user.photoURL),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/profile', arguments: user);
        },
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return widgetLoading();
        print(snapshot.hasData);
        print(snapshot.data.data());
        print(user.uid); // 파이어베이스 등록된 사용자 UID, uFRd17x6skXcPtgjjhGC03I2E3n1
        //print(snapshot.data.id); //위와 동일
        return widgetMessage('환영합니다', Icons.check_circle_outline);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        actions: <Widget>[
          _buildProfile(context),
        ],
      ),
      body: _buildBody(),
    );
  }
}