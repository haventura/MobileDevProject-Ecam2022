import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'transition_route_observer.dart';
import 'widgets/fade_in.dart';
import 'constants.dart';
import 'widgets/animated_numeric_text.dart';
import 'widgets/round_button.dart';
import 'post_card.dart';
   
class MainFeed extends StatelessWidget {
  static const routeName = '/dashboard';

  const MainFeed({Key? key}) : super(key: key);

  
    @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/auth')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
    }
    final menuBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.bars),
      onPressed: () {},
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: theme.colorScheme.secondary,
      onPressed: () => _goToLogin(context),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Flipper"),
        leading: FadeIn(
          duration: Duration.zero,
          offset: .3,
          fadeDirection: FadeDirection.startToEnd,
          child: menuBtn,
        ),
        actions: <Widget>[
          FadeIn(
            duration: Duration.zero,
            offset: .3,
            fadeDirection: FadeDirection.endToStart,
            child: signOutBtn,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return PostCard();
        },
      ),
    );
  }
}