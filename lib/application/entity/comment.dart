import 'package:ratemy/application/entity/user.dart';

class Comment {
  String text;
  User user; 

  Comment({
    required this.text,
    required this.user
  });
}