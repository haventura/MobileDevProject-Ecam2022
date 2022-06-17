import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'header_bar.dart';
import 'post_model.dart';
import 'transition_route_observer.dart';
import 'widgets/fade_in.dart';
import 'constants.dart';
import 'widgets/animated_numeric_text.dart';
import 'widgets/round_button.dart';
import 'post_card.dart';
import 'dart:collection';
   
class MainFeed extends StatelessWidget {
  static const routeName = '/mainfeed';
  MainFeed({Key? key}) : super(key: key);
  
  static Future<List<Post>> _getData() async {
    CollectionReference collection = FirebaseFirestore.instance.collection('posts');
    QuerySnapshot eventsQuery = await collection.orderBy('date', descending: true).get();

    HashMap<String, Post> eventsHashMap = new HashMap<String, Post>();

    eventsQuery.docs.forEach((document) {
      eventsHashMap.putIfAbsent(document['date'].toString(), () => Post(
        uid: document["uid"],
        username: document["username"],
        email: document["email"],
        title: document["title"],
        content: document["content"],
        image: document["image"],
        time: document["date"],
        fileUrl: document["file_url"],
      ));
    });

  return eventsHashMap.values.toList();
}
  
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar.buildAppBar(context),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.headline2!,
        textAlign: TextAlign.center,
        child: FutureBuilder<List<Post>>(
          future: _getData(), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,  
                  itemBuilder: (BuildContext context, int index) {
                    return PostCard(snapshot.data?[index]);
                  })];
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }
            return Center(
              child: ListView (
                children: children,
              ),
            );
          },
        ),
      )
    );
  }
}