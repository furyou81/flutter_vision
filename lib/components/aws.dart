import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './response_element.dart';

class AWS extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AWSState();
  }
}

class _AWSState extends State<AWS> {
  File _imageFile;
  List<Widget> _responseList = [];

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(
      source: source,
      maxWidth: 1000.0,
    ).then((File image) {
      setState(() {
        _imageFile = image;
      });
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Text('Pick an Image'),
                // SizedBox(height: 5.0,),
                FlatButton(
                  child: Text('Use Camera'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                // SizedBox(height: 5.0,),
                FlatButton(
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  String _convertToBase64() {
    List<int> imageBytes = _imageFile.readAsBytesSync();
    print(imageBytes);
    String base64Image = base64Encode(imageBytes);
    print(base64Image);
    return base64Image;
  }

  void _sendRequestToAPI() {
    _responseList.clear();
    final String url = "http://192.168.1.100:4000/api/aws/analysis";

    http.post(url, body: {
      "image": _convertToBase64(),
    }).then((response) {
      print("RESPONSE VISION");
      print(response.body.toString());
      List<dynamic> j = jsonDecode(response.body);
      setState(() {
        _responseList.add(ResponseElement(
          description: j[0]['people'],
          score: j[0]['confidence'],
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            OutlineButton(
              borderSide: BorderSide(width: 2.0, color: Colors.grey[300]),
              onPressed: () => _openImagePicker(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.camera_alt,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Select an image',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            _imageFile == null
                ? Text('Please pick an image')
                : Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              height: 190,
                              width: 190,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: FileImage(_imageFile),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 25.0,
                            child: RaisedButton(
                              child: Text(
                                "Send API request",
                                style: TextStyle(color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                              color: Colors.orange,
                              onPressed:
                                  _imageFile != null ? _sendRequestToAPI : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        children: _responseList,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
