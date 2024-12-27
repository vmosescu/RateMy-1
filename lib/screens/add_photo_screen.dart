import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ratemy/screens/presentation/add_photo_presentation.dart';
import 'package:ratemy/screens/widgets/photo_input.dart';
import 'components/bottom_bar.dart';

class AddPhotoScreen extends StatefulWidget {
  final AddPhotoPresentation presentation;

  const AddPhotoScreen({super.key, required this.presentation});

  static String id = 'add_photo_screen';

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  File? _selectedPhoto;
  var _isUploading = false;

  void _addPhoto() async {
    if (_selectedPhoto == null) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      final uuid = DateTime.now().millisecondsSinceEpoch;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('photos')
          .child('${user.uid}-$uuid.jpg');

      await storageRef.putFile(_selectedPhoto!);
      final photoUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('photos').add({
        'userId': user.uid,
        'username': userData.data()!['username'],
        'createdAt': Timestamp.now(),
        'photo': photoUrl,
      });

      Navigator.of(context).pop();

    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Upload photo failed.')));
    }
    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sW = MediaQuery.sizeOf(context).width;
    final sH = MediaQuery.sizeOf(context).height;
    final double bottomBarH = sW * .3 > 60 ? 60 : sW * .3;
    final double scalingFactor = sH > 700 ? 1 : sH / 700;

    return Scaffold(
      backgroundColor: widget.presentation.background,
      body: Stack(
        children: [
          // Main content centered
          SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 12, top: 30, right: 12, bottom: 12),
            child: Column(
              children: [
                PhotoInput(
                  onPickPhoto: (pickedPhoto) {
                    _selectedPhoto = pickedPhoto;
                  },
                ),
                const SizedBox(height: 16),
                if (_isUploading) const CircularProgressIndicator(),
                if (!_isUploading)
                  ElevatedButton.icon(
                    onPressed: _addPhoto,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add Photo',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
              ],
            ),
          ),
          // Bottom bar
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: bottomBarH,
              child: BottomBar(scaling: scalingFactor),
            ),
          ),
        ],
      ),
    );
  }
}
