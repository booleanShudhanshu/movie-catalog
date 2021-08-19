import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_catalog/src/utils/constants.dart';
import 'package:recase/recase.dart';

class DialogUtils {
  static Future<void> showNoInternetDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.grey[900],
                content: Text(
                    "Sorry, we can't load your account settings at the moment, please check your internet connection or try again later.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 14,
                      fontFamily: MONTSERRAT,
                    ))),
          );
        });
  }

  static Future<void> showOnRetryDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.grey[900],
                content: Text(
                    "Sorry, we're unable to connnect the app to GOS Servers. Please check your internet connection or try again later! ",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.grey[100], fontSize: 14, fontFamily: MONTSERRAT))),
          );
        });
  }

  static Future<void> errorDialog(BuildContext context, String title, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.grey[900],
                title: Text(ReCase(title).titleCase,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 16,
                        fontFamily: MONTSERRAT,
                        fontWeight: FontWeight.bold)),
                content: Text(message,
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.grey[100], fontSize: 14, fontFamily: MONTSERRAT))),
          );
        });
  }
}
