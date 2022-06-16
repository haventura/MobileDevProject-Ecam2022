import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'header_bar.dart';
import 'widgets/fade_in.dart';

// Create a Form widget.
class NewPost extends StatefulWidget {
  static const routeName = '/newpost';

  const NewPost({Key? key}) : super(key: key);

  @override
  NewPostState createState() => NewPostState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewPostState extends State<NewPost> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController(text:"An interesting title");
  
  final contentController = TextEditingController(text:"Tell us how you feel");
  String? title;
  String? content;
  @override
  Widget build(BuildContext context) {

    // Build a Form widget using the _formKey created above.~
    return Scaffold(
      appBar: HeaderBar.buildAppBar(context),
      body: Form(       
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              // The validator receives the text that the user has entered.
              controller: titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: contentController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    String? username = "Anonymous";
                    if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser?.displayName != null) {
                      username = FirebaseAuth.instance.currentUser?.displayName;
                    }
                    String? email = "";
                    if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser?.email != null) {
                      email = FirebaseAuth.instance.currentUser?.email;
                    }
                    final post = <String, dynamic>{
                      "title": titleController.text,
                      "content": contentController.text,
                      "username": username, 
                      "email": email,                    
                      "image": "an image",
                      "date": DateTime.now()
                    };
                    FirebaseFirestore.instance.collection("posts").add(post).then((DocumentReference doc) =>
                      print('DocumentSnapshot added with ID: ${doc.id}'));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      )
    );
  }
}