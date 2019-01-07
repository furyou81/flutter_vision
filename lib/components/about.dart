import 'package:flutter/material.dart';

class About extends StatelessWidget {

  TextStyle _textWhite() {
    return TextStyle(color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Center(
        //child: Card(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Application developped with Flutter', style: _textWhite()),
                Text('Send an API request to the Google Vision API', style: _textWhite()),
                Text('Then display the result', style: _textWhite()),
              ],
            ),
          ),
        //),
      ),
    );
  }
}
