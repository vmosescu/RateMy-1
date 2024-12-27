import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PhotoInput extends StatefulWidget {
  const PhotoInput({
    super.key,
    required this.onPickPhoto,
  });

  final void Function(File pickedPhoto) onPickPhoto;

  @override
  State<PhotoInput> createState() {
    return _PhotoInputState();
  }
}

class _PhotoInputState extends State<PhotoInput> {
  File? _selectedPhoto;

  void _selectPhoto() async {
    final imagePicker = ImagePicker();
    final pickedPhoto =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedPhoto == null) {
      return;
    }

    setState(() {
      _selectedPhoto = File(pickedPhoto.path);
    });

    widget.onPickPhoto(_selectedPhoto!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: const Icon(Icons.add_a_photo),
      label: const Text('Select a Photo'),
      onPressed: _selectPhoto,
    );

    if (_selectedPhoto != null) {
      content = GestureDetector(
        onTap: _selectPhoto,
        child: Image.file(
          _selectedPhoto!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary),
      ),
      height: 600,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
