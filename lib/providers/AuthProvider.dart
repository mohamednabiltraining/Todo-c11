import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_c11/database/collections/UsersCollection.dart';
import 'package:todo_c11/database/models/AppUser.dart';

class AppAuthProvider extends ChangeNotifier{
  UsersCollection usersCollection = UsersCollection();

  User? authUser;
  AppUser? appUser;

  AppAuthProvider(){
    authUser = FirebaseAuth.instance.currentUser;
    if(authUser!=null){
      signInWithUid(authUser!.uid);
    }
  }
  void signInWithUid(String uid)async {
    appUser = await usersCollection.readUser(uid);
    notifyListeners();
  }
  bool isLoggedIn(){
    return authUser != null;
  }
  void login(User newUser){
    authUser = newUser;
  }
  void logout(){
    authUser = null;
    FirebaseAuth.instance.signOut();
  }

  Future<AppUser?> createUserWithEmailAndPassword(
      String email,
      String password,
      String fullName
      )async{

    UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if(credential.user !=null){
      login(credential.user!);
      // insert user to fire store
      appUser = AppUser(
        authId: credential.user?.uid,
        fullName: fullName,
        email: email
      );
      var result = await usersCollection.createUser(appUser!);// check if user created or there is an error
      return appUser!;
    }
    return null;
  }

  Future<AppUser?> signInWithEmailAndPassword(
      String email,
      String password
      )async{

    UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if(credential.user !=null){
      login(credential.user!);
      //read user from database
      appUser = await usersCollection.readUser(credential.user!.uid);

    }
    return appUser;
  }


}