import 'package:flutter/material.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ratemy/screens/auth.dart';
import 'package:ratemy/screens/splash.dart';
import 'firebase_options.dart';

import 'package:ratemy/screens/profile_screen.dart';
import 'package:ratemy/screens/feed_screen.dart';
import 'package:ratemy/screens/login_screen.dart';
import 'package:ratemy/screens/presentation/app_theme.dart';
import 'package:ratemy/screens/user_screen.dart';

import 'application/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Injector injector = Injector();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String initialRoute = LoginScreen.id;

    return MaterialApp(
      title: 'RateMy',
      // initialRoute: initialRoute,
      routes: {
        LoginScreen.id: (context) =>
            LoginScreen(presentation: injector.getLoginPresentation()),
        UserScreen.id: (context) => UserScreen(
              presentation: injector.getProfilePresentation(),
            ),
        ProfileScreen.id: (context) => ProfileScreen(
              presentation: injector.getProfilePresentation(),
            ),
        FeedScreen.id: (context) => FeedScreen(
              presentation: injector.getFeedPresentation(),
            ),
      },
      theme: AppTheme.getAppTheme(),
      // onGenerateRoute: (settings) {
      //   // All Routes definitions that require parameters
      //   if(settings.name == FeedScreen.id) {
      //     return MaterialPageRoute(builder: (context) {
      //       return FeedScreen(presentation: injector.getFeedPresentation(),);
      //     });
      //   }

      //   return MaterialPageRoute(builder: (context) {
      //     return LoginScreen(presentation: injector.getLoginPresentation());
      //   });
      // },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return FeedScreen(
              presentation: injector.getFeedPresentation(),
            );
          }
          return const AuthScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
