// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.storage,
    //   Permission.camera,
    // ].request();

    if (await Permission.storage.request().isGranted &&
        await Permission.camera.request().isGranted) {
      final picker = ImagePicker();
      final imageFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
      if (imageFile == null) {
        return;
      }
      setState(() {
        _storedImage = File(imageFile.path);
      });
      final appDirectory = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(_storedImage.path);
      final savedImage =
          await _storedImage.copy('${appDirectory.path}/${fileName}');
      widget.onSelectImage(savedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  "No Image Taken",
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextButton.icon(
            onPressed: _takePicture,
            label: Text("Take Picture"),
            icon: Icon(Icons.camera),
          ),
        ),
      ],
    );
  }
}
