import 'package:flutter/material.dart';

class ResponseElement extends StatelessWidget {
  final String description;
  final double score;

  ResponseElement({this.description, this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Desciption:'),
                  SizedBox(width: 10.0),
                  Text(
                    '$description',
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Score:'),
                  SizedBox(width: 10.0),
                  Text(
                    '${score.toStringAsFixed(2)}%',
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
