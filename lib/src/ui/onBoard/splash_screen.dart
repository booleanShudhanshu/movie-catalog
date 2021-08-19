import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:movie_catalog/src/ui/authentication/verify_number.dart';
import 'package:movie_catalog/src/ui/movie/movie_list.dart';
import 'package:movie_catalog/src/utils/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _firebaseUser;

  _getFirebaseUser() async {
    _firebaseUser = _firebaseAuth.currentUser;
    if (_firebaseUser != null) {
      Navigator.of(context)
          .pushReplacement(createRoute(MovieList(), PageTransitionType.slideParallaxLeft));
    } else {
      Navigator.of(context)
          .pushReplacement(createRoute(VerifyNumber(), PageTransitionType.slideParallaxLeft));
    }
  }

  @override
  void initState() {
    //This is done to display rsplash screen for 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      _getFirebaseUser();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Center(child: _body()));
  }

  Widget _body() {
    return Container(
        child: Image.asset('assets/icons/splash.png',
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.8));
  }
}
