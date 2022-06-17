import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'custom_route.dart';
import 'dashboard_screen.dart';
import 'main_feed.dart';
    
class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';
  String? newUsername;
  LoginScreen({Key? key}) : super(key: key);

  //Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(LoginData data) async {
    try {
      print("2 $newUsername");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data.name, password: data.password).then((value) async => 
              newUsername != null? await FirebaseAuth.instance.currentUser?.updateDisplayName(newUsername):false
            );
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    if (data.name != null && data.password != null) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data.name!,
          password: data.password!
        ).then((value) => newUsername = data.additionalSignupData!["Username"]);
        print("1 $newUsername");
        return _loginUser(LoginData(name: data.name!, password: data.password!));
      } on FirebaseAuthException catch (e) {
        return e.code;
      } catch (e) {
        return e.toString();
      }
    }
    return null;
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> _signupConfirm(String error, LoginData data) {
    return _loginUser(data);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: Constants.appName,
      logo: const AssetImage('images/flipper.png'),
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      loginAfterSignUp: true,
      additionalSignupFields: const [
      UserFormField(
          keyName: 'Username', icon: Icon(FontAwesomeIcons.user))
      ],
      initialAuthMode: AuthMode.login,
      userValidator: (value) {
        if (!value!.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'Password is empty';
        }
        if (value.length < 6) {
          return 'Password is too short';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name: ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('Name: ${signupData.name}');
        debugPrint('Password: ${signupData.password}');

        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
          if(key == "Username"){

          }
        });
        if (signupData.termsOfService.isNotEmpty) {
          debugPrint('Terms of service: ');
          for (var element in signupData.termsOfService) {
            debugPrint(
                ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}');
          }
        }
        return _signupUser(signupData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => MainFeed(),
        ));
      },
      
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons: true,
    );
  }
}
