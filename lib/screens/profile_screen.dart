import 'package:flutter/material.dart';
import 'package:ratemy/screens/presentation/profile_presentation.dart';

// import 'components/title_row.dart';

class ProfileScreen extends StatefulWidget {
  final ProfilePresentation presentation;

  const ProfileScreen({super.key, required this.presentation});

  static String id = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(widget.presentation.profilePictureUrl),
              onBackgroundImageError: (_, __) =>
                  const Icon(Icons.person, size: 60),
            ),
            const SizedBox(height: 20),
            // User Name
            Text(
              widget.presentation.userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
