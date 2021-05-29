import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<GoogleSignInAccount> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  print(googleUser.email);

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  if (await checkUser(currentUser: googleUser)) {
    await addUser(
      name: googleUser.displayName,
      email: googleUser.email,
      photoUrl: googleUser.photoUrl,
    );
  }
  await FirebaseAuth.instance.signInWithCredential(credential);
  // Once signed in, return the UserCredential
  return googleUser;
}

Future<bool> checkUser({GoogleSignInAccount currentUser}) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  QuerySnapshot temp =
      await users.where("userName", isEqualTo: currentUser.displayName).get();
  if (temp.docs.length == 0) {
    return true;
  } else {
    return false;
  }
}

Future<void> addUser({String name, String email, String photoUrl}) {
  // Call the user's CollectionReference to add a new user
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return users
      .add(
        {
          'userName': name,
          'userEmail': email,
          'photoUrl': photoUrl,
        },
      )
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}
