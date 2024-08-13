
import 'dart:io';

import 'package:flutter/material.dart';

class PreviewPage extends StatefulWidget {
  final String? imagePath;
 // ignore: prefer_const_constructors_in_immutables
 PreviewPage({Key? key, this.imagePath}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preview',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: widget.imagePath != null
            ? Image.file(
              File(widget.imagePath!),

              fit: BoxFit.fill,
            )
            : Container(),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(), backgroundColor: Colors.black54, 
                minimumSize: const Size(60, 60), 
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}