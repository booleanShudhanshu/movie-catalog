import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:movie_catalog/src/ui/authentication/opt_screen.dart';
import 'package:movie_catalog/src/utils/constants.dart';
import 'package:movie_catalog/src/utils/routes.dart';
import 'package:movie_catalog/src/widgets/domino_reveal.dart';

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({Key key}) : super(key: key);
  @override
  _VerifyNumberState createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> with TickerProviderStateMixin {
  final TextEditingController _phoneNumberController = TextEditingController();
  bool isValid;
  validate() async {
    print("in validate : ${_phoneNumberController.text.length}");
    if (_phoneNumberController.text.length > 5) {
      isValid = true;
    } else {
      isValid = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    isValid = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: _body(size),
    );
  }

  Widget _body(Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DominoReveal(child: _enterNumberLabel(size)),
          SizedBox(height: 24),
          DominoReveal(child: _verificationLabel(size)),
          SizedBox(height: 36),
          DominoReveal(child: _mobileNoField(size)),
          SizedBox(height: 24),
          DominoReveal(child: _continueButton(size))
        ],
      ),
    );
  }

  Widget _enterNumberLabel(Size size) {
    return Text("Please enter your phone number",
        style: TextStyle(
            fontSize: 24, color: Colors.white, fontFamily: MONTSERRAT, fontWeight: FontWeight.bold));
  }

  Widget _verificationLabel(Size size) {
    return Text("We'll text you a verification code.",
        style: TextStyle(fontSize: 16, color: Colors.grey[500], fontFamily: MONTSERRAT));
  }

  Widget _mobileNoField(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 6),
      child: TextFormField(
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: MONTSERRAT),
        maxLength: 10,
        keyboardType: TextInputType.phone,
        autovalidateMode: AutovalidateMode.always,
        autocorrect: false,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        validator: (value) {
          return !isValid ? 'Please enter a valid phone number.' : 'Sounds good! ✅';
        },
        controller: _phoneNumberController,
        autofocus: true,
        onChanged: (text) {
          validate();
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          counterText: '',
          enabledBorder: new OutlineInputBorder(
            borderSide: new BorderSide(
              color: Colors.grey[800],
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[800],
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[800],
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[800],
            ),
          ),
          labelText: 'Mobile',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontFamily: MONTSERRAT, fontSize: 16),
          hintStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 16),
          errorStyle: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white, fontFamily: MONTSERRAT),
        ),
      ),
    );
  }

  Widget _continueButton(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: Builder(
        builder: (context) => InkWell(
          borderRadius: BorderRadius.circular(8),
          splashFactory: InkRipple.splashFactory,
          splashColor: isValid ? Colors.red : Colors.black,
          onTap: () {
            if (isValid) {
              Navigator.of(context).push(
                createRoute(OTPScreen(mobileNumber: _phoneNumberController.text),
                    PageTransitionType.slideParallaxLeft),
              );
            } else {
              validate();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                  color: isValid ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[400])),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(isValid ? "Continue" : "Enter number",
                      style: TextStyle(
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isValid ? Colors.black : Colors.white,
                          fontFamily: MONTSERRAT)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
