import 'package:flutter/material.dart';
import 'package:movie_catalog/src/utils/constants.dart';

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[_error(), SizedBox(height: 8), _retryButton()],
      ),
    );
  }

  Widget _error() {
    return Text(
      errorMessage,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: MONTSERRAT,
        color: Colors.grey[300],
        fontSize: 16,
      ),
    );
  }

  Widget _retryButton() {
    return InkWell(
      splashFactory: InkRipple.splashFactory,
      splashColor: Colors.white,
      child: Container(
          height: 36,
          width: 72,
          child: Center(
              child: Text('Retry', style: TextStyle(color: Colors.grey, fontFamily: MONTSERRAT)))),
      onTap: () async {
        await Future.delayed(Duration(seconds: 1));
        onRetryPressed();
      },
    );
  }
}
