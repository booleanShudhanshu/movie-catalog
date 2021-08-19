import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:movie_catalog/src/ui/movie/movie_list.dart';
import 'package:movie_catalog/src/utils/constants.dart';
import 'package:movie_catalog/src/utils/dialog_utils.dart';
import 'package:movie_catalog/src/utils/routes.dart';
import 'package:movie_catalog/src/widgets/domino_reveal.dart';

import 'otp_input.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;

  OTPScreen({
    Key key,
    @required this.mobileNumber,
  })  : assert(mobileNumber != null),
        super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Control the input text field.
  TextEditingController _pinEditingController = TextEditingController();

  /// Decorate the outside of the Pin.
  PinDecoration _pinDecoration = UnderlineDecoration(
    enteredColor: Colors.white,
    hintText: '******',
    color: Colors.white,
  );

  bool isCodeSent;
  String _verificationId;

  @override
  void initState() {
    super.initState();
    _onVerifyCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 60),
            child: Column(
              children: <Widget>[
                _otpsentlabel(),
                SizedBox(height: 36),
                _description(),
                SizedBox(height: 36),
                if (_verificationId != null) ...[
                  DominoReveal(child: _pinInput()),
                  SizedBox(height: 18),
                  DominoReveal(child: resendCode()),
                  SizedBox(height: 18),
                  DominoReveal(child: _submitButton()),
                  SizedBox(height: 36),
                ]
              ],
            ),
          ),
        ));
  }

  Widget _otpsentlabel() {
    return Text("OTP Verification",
        style: TextStyle(
            letterSpacing: 0.6,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            fontFamily: MONTSERRAT));
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text("Check your SMS messages. we've sent you a 6-digit code at  ${widget.mobileNumber}",
          textAlign: TextAlign.center,
          style: TextStyle(
              letterSpacing: 0.4,
              height: 1.5,
              fontSize: 15,
              color: Colors.white,
              fontFamily: MONTSERRAT)),
    );
  }

  Widget _pinInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PinInputTextField(
        pinLength: 6,
        decoration: _pinDecoration,
        controller: _pinEditingController,
        autoFocus: true,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            height: 54,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text("Submit",
                    style: TextStyle(
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: MONTSERRAT)),
              ),
            ),
          ),
        ),
        onTap: () {
          if (_pinEditingController.text.length == 6) {
            _onFormSubmitted();
          } else {
            Constants.showToast("Invalid OTP! Please enter the correct OTP");
          }
        },
      ),
    );
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {
      _firebaseAuth.signInWithCredential(phoneAuthCredential).then((UserCredential value) async {
        if (value.user != null) {
          Constants.showToast("Login Successful");
        } else {
          Constants.showToast("Error validating OTP, try again");
        }
      }).catchError((error) {
        // Constants.showToast(error.toString());
        Constants.showToast("Invalid number");
      });
    };
    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
      Constants.showToast("Invalid number");
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
      Constants.showToast("OTP Sent");
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      _verificationId = verificationId;

      if (mounted) {
        setState(() {
          _verificationId = verificationId;
        });
      }
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${widget.mobileNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);

    _firebaseAuth.signInWithCredential(_authCredential).then((UserCredential value) async {
      if (value.user != null) {
        Constants.showToast("Login Successful");
        Navigator.of(context).pushAndRemoveUntil(
            createRoute(MovieList(), PageTransitionType.slideParallaxLeft), (route) => false);
      } else {
        Constants.showToast("Error validating OTP, try again!");
      }
    }).catchError((error) {
      DialogUtils.errorDialog(context, error.code, error.message);
    });
  }

  Widget resendCode() {
    return Container(
      height: 40,
      width: 120,
      child: OutlinedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            // elevation: MaterialStateProperty.all(8),
            backgroundColor: MaterialStateProperty.all(Colors.white)),
        onPressed: () {
          _verificationId = null;
          _pinEditingController.clear();
          setState(() {});
          _onVerifyCode();
        },
        child: Center(
          child: Text(
            "Resend OTP",
            style: TextStyle(
                letterSpacing: 0.4,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black,
                fontFamily: MONTSERRAT),
          ),
        ),
      ),
    );
  }
}
