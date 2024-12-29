import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ratemy/application/entity/user.dart';

class Post {
  final User user;
  final double pictureRating;
  final int userRating;
  final String imageUrl;
  final Timestamp? postTimestamp;

  Post(this.user, this.pictureRating, this.userRating, this.imageUrl, {this.postTimestamp}) ;

  Post copyWith({double? pictureRating}) {
    return Post(
      user,
      pictureRating ?? this.pictureRating,
      userRating,
      imageUrl,
    );
  }
}