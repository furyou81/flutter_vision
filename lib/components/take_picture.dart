import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './response_element.dart';

class TakePicture extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TakePictureState();
  }
}

class _TakePictureState extends State<TakePicture> {
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
    final String url =
        "https://vision.googleapis.com/v1/images:annotate?key=YOUR_API_KEY";

    http
        .post(url,
            body: jsonEncode({
              "requests": [
                {
                  "image": {"content": _convertToBase64()},
                  "features": [
                    {"type": "LABEL_DETECTION", "maxResults": 5}
                  ]
                }
              ]
            }))
        .then((response) {
      print("RESPONSE VISION");
      print(response.body.toString());
      Map<String, dynamic> j = jsonDecode(response.body);
      List<dynamic> res = j['responses'];
      List<dynamic> ress = res[0]['labelAnnotations'];

      setState(() {
        ress.forEach((e) {
          _responseList.add(ResponseElement(
            description: e['description'],
            score: e['score'],
          ));
        });
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
