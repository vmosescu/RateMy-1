import 'package:flutter/material.dart';
import 'package:ratemy/screens/presentation/profile_presentation.dart';

import 'components/title_row.dart';

class UserScreen extends StatefulWidget {
  final ProfilePresentation presentation;

  const UserScreen({super.key, required this.presentation});

  static String id = 'user_screen';

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.presentation.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              widget.presentation.gapAboveScreenTitle,

              TitleRow(
                backAction: () {
                  Navigator.pop(context, false);
                },
                title:'User profile screen',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
