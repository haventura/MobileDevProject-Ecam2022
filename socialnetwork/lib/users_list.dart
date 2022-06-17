import 'package:flutter/material.dart';

import 'header_bar.dart';

class UsersList extends StatelessWidget {
  static const routeName = '/userslist';
  const UsersList({Key? key}) : super(key: key);
   
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar.buildAppBar(context),
      //body: 

    );
  }
}