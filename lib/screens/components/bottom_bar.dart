import 'package:flutter/material.dart';
import 'package:ratemy/screens/feed_screen.dart';
import '../profile_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, this.scaling = 1.0});
  final double iconSize = 30;
  final iconColor = Colors.white;
  final double scaling;

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton(context),
        _buildCalendarButton(),
        _buildButton3(),
        _buildNotificationsButton(),
        _buildProfileButton(context),
      ],
    );
  }

  _buildButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pushNamed(context, FeedScreen.id);
        },
        iconSize: iconSize * scaling,
        icon: const Icon(Icons.local_fire_department), color: iconColor,);
  }


  _buildCalendarButton() {
    return IconButton(
      onPressed: () {},
      iconSize: iconSize * scaling,
      icon: const Icon(Icons.calendar_month), color: iconColor);
  }

  _buildButton3() {
    return IconButton(
        onPressed: () {},
        iconSize: iconSize * scaling,
        icon: const Icon(Icons.outbox_outlined), color: iconColor);
  }

  _buildNotificationsButton() {
    return IconButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        iconSize: iconSize * scaling,
        icon: const Icon(Icons.notifications), color: iconColor);
  }

  _buildProfileButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pushNamed(context, ProfileScreen.id);
        },
        iconSize: iconSize * scaling,
        icon: const Icon(Icons.account_box), color: iconColor);
  }
}