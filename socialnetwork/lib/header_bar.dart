import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widgets/fade_in.dart';

class HeaderBar{
  static AppBar buildAppBar(BuildContext context) {

    final theme = Theme.of(context);

    Future<bool> _goToLogin(BuildContext context) {
      return Navigator.of(context)
        .pushReplacementNamed('/auth')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
    }

    Future<bool> _goToMainFeed(BuildContext context) {
      return Navigator.of(context)
        .pushReplacementNamed('/mainfeed')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
    }

    Future<bool> _goToNewPost(BuildContext context) {
      return Navigator.of(context)
        .pushReplacementNamed('/newpost')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
    }

    Future<bool> _goToUsersList(BuildContext context) {
      return Navigator.of(context)
        .pushReplacementNamed('/userslist', arguments : "")
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
    }

    Future<bool> _goToUserSettings(BuildContext context) {
      return Navigator.of(context)
        .pushReplacementNamed('/usersettings')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
    }

    final menuBtn = PopupMenuButton(
      icon: const Icon(FontAwesomeIcons.bars),
      onSelected: (value) {
        switch (value){
          case 1:
            _goToMainFeed(context);        
            break;

          case 2:
            _goToNewPost(context);
            break;

          case 3:
            _goToUsersList(context);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text("Main feed"),
          value: 1,
        ),
        const PopupMenuItem(
          child: Text("New post"),
          value: 2,
        ),
        const PopupMenuItem(
          child: Text("Search user"),
          value: 3,
        ),
      ]
    );

    final userBtn = PopupMenuButton(
      icon: Image.asset(
            'images/default-user-profile-picture.jpg',
              fit: BoxFit.contain,
              height: 32,
          ),
      onSelected: (value) {
        switch (value){
          case 1:
            _goToUserSettings(context);        
            break;

          case 2:
            _goToLogin(context);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text("User settings"),
          value: 1,
        ),
        const PopupMenuItem(
          child: Text("Sign out"),
          value: 2,
        ),
      ]
    );



    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: theme.colorScheme.secondary,
      onPressed: () => _goToLogin(context),
    );

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/flipper.png',
              fit: BoxFit.contain,
              height: 32,
          ),
          Container(
            padding: const EdgeInsets.all(8.0), child: Text('Flipper')
          )
        ],
      ),
      leading: FadeIn(
        duration: Duration.zero,
        offset: .3,
        fadeDirection: FadeDirection.startToEnd,
        child: menuBtn
      ),
      actions: <Widget>[
        FadeIn(
          duration: Duration.zero,
          offset: .3,
          fadeDirection: FadeDirection.endToStart,
          child: userBtn,
        ),
      ],
    );
  }
}
