import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';

Route createRoute(route, PageTransitionType pageTransitionType) {
  return PageRouteBuilder(
    pageBuilder:
        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
            route,
    transitionDuration: const Duration(milliseconds: 420),
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return effectMap[pageTransitionType](Curves.easeIn, animation, secondaryAnimation, child);
    },
  );
}
