import 'package:ratemy/application/entity/user.dart';

class Post {
  final User user;
  final double pictureRating;
  final int userRating;
  final String imageUrl;

  const Post(this.user, this.pictureRating, this.userRating, this.imageUrl);

  Post copyWith({double? pictureRating}) {
    return Post(
      user,
      pictureRating ?? this.pictureRating,
      userRating,
      imageUrl,
    );
  }
}