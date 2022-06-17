import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'header_bar.dart';
import 'widgets/fade_in.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

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
  late DropzoneViewController imageController;
  final contentController = TextEditingController(text:"Tell us how you feel");
  
  String title = "";
  String content = "";
  Uint8List? myFile;
  String fileName = "";
  String uid = "";
  String email = "";
  String dropText = "Drop a picture here";

  changeText() {
 
    setState(() {
     dropText = fileName; 
    });
    
  }

  Future<bool> _goToMainFeed(BuildContext context) {
    return Navigator.of(context)
      .pushReplacementNamed('/mainfeed')
      // we dont want to pop the screen, just replace it completely
      .then((_) => false);
  }

  Future<String> getImageFileUrl() async {
    final storageRef = FirebaseStorage.instance.ref("${DateTime.now().toString()}/$fileName");
    await storageRef.putData(myFile!);
    var fileUrl = await storageRef.getDownloadURL();
    return fileUrl;
  }

  @override
  Widget build(BuildContext context) {

    // Build a Form widget using the _formKey created above.~
    return Scaffold(
      appBar: HeaderBar.buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(       
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
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        String? username = "Anonymous";
                        
                        if (FirebaseAuth.instance.currentUser != null) {
                          uid = FirebaseAuth.instance.currentUser?.uid as String;
                        }
                        if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser?.displayName != null) {
                          username = FirebaseAuth.instance.currentUser?.displayName;
                        }
                        
                        if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser?.email != null) {
                          email = FirebaseAuth.instance.currentUser?.email as String;
                        }
                        String url = "";
                        if(myFile != null){
                          url = await getImageFileUrl();
                        }                                       
                        final post = <String, dynamic>{
                          "title": titleController.text,
                          "content": contentController.text,
                          "uid": uid,
                          "username": username, 
                          "email": email,                    
                          "image": "an image",
                          "date": DateTime.now(),
                          "file_url": url,
                        };
                        
                        FirebaseFirestore.instance.collection("posts").add(post).then((DocumentReference doc) =>
                          print('DocumentSnapshot added with ID: ${doc.id}'));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        _goToMainFeed(context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),              
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                buildZone(context),
                Center(child: Text(dropText)),
              ],
            ),
          ),
        ]
      )    
    );
  }

  Widget buildZone(BuildContext context) => Builder(
    builder: (context) => DropzoneView(
        operation: DragOperation.copy,
        cursor: CursorType.grab,
        onCreated: (DropzoneViewController ctrl) => imageController = ctrl,
        onLoaded: () => print('Zone loaded'),
        onError: (String? ev) => print('Error: $ev'),
        onHover: () => print('Zone hovered'),
        onDrop: (ev) async {
            print('Drop: ${ev.name}');
            fileName = ev.name;
            myFile = await imageController.getFileData(ev);
            changeText();
          },
        onLeave: () => print('Zone left'),
    )
  );
}