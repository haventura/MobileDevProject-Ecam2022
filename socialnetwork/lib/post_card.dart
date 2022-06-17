import 'package:flutter/material.dart';
import 'package:socialnetwork/post_model.dart';
import 'demo_values.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  Post? data;
  PostCard(this.data, {Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6 / 3,
      child: Card(
        elevation: 2,
        child: Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              _Post(data),
              Divider(color: Colors.grey),
              _PostDetails(data),
            ],
          ),
        ),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  Post? data;
  _Post(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(children: <Widget>[_PostImage(data), _PostTitleAndSummary(data)]),
    );
  }
}

class _PostTitleAndSummary extends StatelessWidget {
  Post? data;
  _PostTitleAndSummary(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleTheme = Theme.of(context).textTheme.titleLarge;
    final TextStyle? summaryTheme = Theme.of(context).textTheme.bodyText1;
    final String title = data!.title;
    final String summary = data!.content;

    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(title, style: titleTheme),
            SizedBox(height: 2.0),
            Text(summary, style: summaryTheme),
          ],
        ),
      ),
    );
  }
}

class _PostImage extends StatelessWidget {
  Post? data;
  _PostImage(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(data != null && data!.fileUrl != ""){
      return Expanded(flex: 2, child: Image.network(data!.fileUrl));
    }
    else{
      return Expanded(flex: 2, child: Image.asset(DemoValues.postImage));
    }
  }
}

class _PostDetails extends StatelessWidget {
  Post? data;
  _PostDetails(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _UserImage(),
        _UserNameAndEmail(data),
        _PostTimeStamp(data),
      ],
    );
  }
}

class _UserNameAndEmail extends StatelessWidget {
  Post? data;
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

class _PostTimeStamp extends StatelessWidget {
  Post? data;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  _PostTimeStamp(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? timeTheme = Theme.of(context).textTheme.bodyText1;
    final duration = DateTime.now().difference(data!.time.toDate());
    final timeAgo = DateTime.now().subtract(duration);
    String formattedTime = timeago.format(timeAgo, locale: 'en_short');
    if(formattedTime == "now"){
      formattedTime = "Posted just now";
    }
    else{
      formattedTime = "Posted $formattedTime ago";
    }
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(data!.time.toDate());
    return Expanded(
      flex: 2,
      child: Text(formattedTime, style: timeTheme),
    );
  }
}