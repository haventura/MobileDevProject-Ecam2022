import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'header_bar.dart';
import 'user_card.dart';
import 'user_model.dart' as user_model;

class UsersList extends StatelessWidget {
  static const routeName = '/userslist';
  
  UsersList({Key? key}) : super(key: key);
   
  final searchController = TextEditingController(text:"Enter a username...");
  
  static Future<List<user_model.User>> _getData({String? username = ""}) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('users');
    QuerySnapshot eventsQuery;
    if(username != "" && username != "Enter a username..."){
      eventsQuery = await collection.where("username", isEqualTo: username).get();
    }
    else{
      eventsQuery = await collection.get();
    }
    HashMap<String, user_model.User> eventsHashMap = HashMap<String, user_model.User>();
    eventsQuery.docs.forEach((document) {
      eventsHashMap.putIfAbsent(document['uid'].toString(), () => user_model.User(
        uid: document["uid"],
        username: document["username"],
        email: document["email"],
        pictureUrl: document["picture_url"],
      ));
    });
    return eventsHashMap.values.toList();
  }

  
  Future<bool> _ReloadPage(BuildContext context, String searchedName) {
    return Navigator.of(context)
      .pushReplacementNamed('/userslist', arguments : searchedName)
      .then((_) => false);
  }

  

    @override
  Widget build(BuildContext context) {
    String searchedName = "";
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      searchedName = settings.arguments as String;
    }
    return Scaffold(
      appBar: HeaderBar.buildAppBar(context),
      body: Column(
        children:[
          TextField(controller: searchController,),
          ElevatedButton(              
            onPressed: () async { 
              _ReloadPage(context, searchController.text);
            },
            child: const Text('Search'),
          ),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline2!,
                textAlign: TextAlign.center,
                child: FutureBuilder<List<user_model.User>>(
                  future: _getData(username: searchedName), // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<List<user_model.User>> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,  
                          itemBuilder: (BuildContext context, int index) {
                            return UserCard(snapshot.data?[index]);
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
            )
          )
        ]
      )
    ); 
  }  
}

