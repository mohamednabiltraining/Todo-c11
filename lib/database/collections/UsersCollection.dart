import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_c11/database/models/AppUser.dart';

class UsersCollection{

  CollectionReference<AppUser> getUsersCollection(){
    var db = FirebaseFirestore.instance;
    return db.collection("users")
        .withConverter(
        fromFirestore: (snapshot, options) {
          return AppUser.fromFirestore(snapshot.data());
        },
        toFirestore: (obj, options) {
          return obj.toFirestore();
        });
  }
  Future<void> createUser(AppUser user){
    // write user in users collection
    return getUsersCollection()
        .doc(user.authId)
        .set(user);


  }

  Future<AppUser?> readUser(String uid) async{
    var doc = getUsersCollection()
        .doc(uid);
    var docSnapshot = await doc.get();
    return docSnapshot.data();
  }
}