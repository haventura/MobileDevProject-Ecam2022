import 'package:flutter/material.dart';

import 'header_bar.dart';

class UserSettings extends StatelessWidget {
  static const routeName = '/usersettings';
  const UserSettings({Key? key}) : super(key: key);
   
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar.buildAppBar(context),
      //body: 

    );
  }
}