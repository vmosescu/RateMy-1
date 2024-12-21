import 'package:flutter/material.dart';
import 'package:ratemy/screens/presentation/login_presentation.dart';

import 'feed_screen.dart';



class LoginScreen extends StatefulWidget {
  final LoginPresentation presentation;

  const LoginScreen({super.key, required this.presentation});

  static String id = 'Login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.presentation.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            widget.presentation.gapAboveScreenTitle,

            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('RATE MY')
                  ],
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  color: const Color.fromARGB(255, 225, 223, 223),
                  textColor: const Color.fromARGB(255, 6, 125, 158),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35), // Round corners
                  ),

                  child: const Text('Get Started', style: TextStyle(fontSize: 20)),
                  onPressed: (){
                    Navigator.pushNamed(context, FeedScreen.id);
                  }
                ),
              ],
            ),

            const SizedBox(height: 100,),
          ],
        ),
      ),
    );
  }
}
