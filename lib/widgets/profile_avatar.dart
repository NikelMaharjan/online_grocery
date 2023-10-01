import 'dart:io';

import 'package:flutter/material.dart';

class Avatar extends StatefulWidget {
  File imagePath;
  String url;
  Avatar({Key? key, required this.imagePath, required this.url}) : super(key: key);
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 50,
        backgroundImage:
        widget.url == null
            ? widget.imagePath == null
            ? null : FileImage(widget.imagePath) : NetworkImage(widget.url) as ImageProvider,
        child: widget.imagePath == null
            ? Icon(
                Icons.person,
                size: 50,
                color: Colors.grey,
              )
            : CircleAvatar(backgroundImage: FileImage(widget.imagePath)));
  }
}
