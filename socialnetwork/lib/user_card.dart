import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'demo_values.dart';
import 'user_model.dart' as user_model;
import 'package:intl/intl.dart';

class UserCard extends StatelessWidget {
  user_model.User? data;
  UserCard(this.data, {Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6 / 1,
      child: Card(
        elevation: 2,
        child: Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              _UserDetails(data),            
            ],
          ),
        ),
      ),
    );
  }
}

class _UserDetails extends StatelessWidget {
  user_model.User? data;
  _UserDetails(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _UserImage(),
        _UserNameAndEmail(data),
        _UserFollowButton(data)
      ],
    );
  }
}

class _UserNameAndEmail extends StatelessWidget {
  user_model.User? data;
  _UserNameAndEmail(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? nameTheme = Theme.of(context).textTheme.subtitle1;
    final TextStyle? emailTheme = Theme.of(context).textTheme.bodyText1;

    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(data!.username, style: nameTheme),
            SizedBox(height: 2.0),
            Text(data!.email, style: emailTheme),
          ],
        ),
      ),
    );
  }
}

class _UserImage extends StatelessWidget {
  const _UserImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: CircleAvatar(
        backgroundImage: AssetImage(DemoValues.userImage),
      ),
    );
  }
}

class _UserFollowButton extends StatelessWidget {

  static void _followUser(String uid) async {
    if(uid == "" || auth.FirebaseAuth.instance.currentUser == null || uid == auth.FirebaseAuth.instance.currentUser?.uid){
      print(uid);
      return;
    }
    CollectionReference collection = FirebaseFirestore.instance.collection('users');
    int count;
    await collection.doc(auth.FirebaseAuth.instance.currentUser?.uid).collection("follows").where("uid", isEqualTo: uid).get().then(
      (value) {if(value.size == 0){
        print("ok for follow");
        collection.doc(auth.FirebaseAuth.instance.currentUser?.uid).collection("follows").doc(uid).set({"uid" : uid});
      }else{print("not ok for follow");}});
  }

  user_model.User? data;
  _UserFollowButton(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Expanded(
      flex: 2,
      child: ElevatedButton(
        onPressed: () async { 
          _followUser(data!.uid);
        },
        child: const Text("Follow"),
        ),
    );
  }
}