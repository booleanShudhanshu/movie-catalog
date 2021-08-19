import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BaseFirebaseService {
  BaseFirebaseService() {
    db = FirebaseFirestore.instance;
    auth = FirebaseAuth.instance;
    user = FirebaseAuth.instance.currentUser;
  }

  FirebaseAuth auth;
  FirebaseFirestore db;
  User user;
}
