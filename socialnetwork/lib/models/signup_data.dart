import 'package:quiver/core.dart';

class FirebaseUserSignupData {
  final String email;
  final String password;
  final String userName;

  FirebaseUserSignupData.fromSignupForm(
      {required this.email,
      required this.password,
      required this.userName});
  /*
  FirebaseUserSignupData.fromProvider({
    required this.additionalSignupData,
    this.termsOfService = const [],
  })  : email = null,
        password = null;
  */
  @override
  bool operator ==(Object other) {
    if (other is FirebaseUserSignupData) {
      return email == other.email &&
          password == other.password &&
          userName == other.userName;
    }
    return false;
  }
  /*
  @override
  int get hashCode => hash3(email, password, userName);
  */
}
