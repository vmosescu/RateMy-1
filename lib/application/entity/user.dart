import 'package:ratemy/application/entity/post.dart';

class User {
  String name;
  String profileImage;
  int postsNumber;
  int following;
  int followers;
  List<Post> posts;
   
  User({
    required this.name,
    required this.profileImage,
    this.postsNumber = 0,
    this.followers = 0,
    this.following = 0,
    List<Post>? posts,
  }) : posts = posts ?? [];
}