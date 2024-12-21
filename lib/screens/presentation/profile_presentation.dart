import 'dart:ui';

import 'package:ratemy/screens/presentation/presentation.dart';
import 'package:ratemy/application/entity/user.dart';

class ProfilePresentation extends Presentation {
  User user;

  @override
  get background => const Color.fromARGB(255, 27, 27, 1);

  ProfilePresentation({
    required this.user
  });
}