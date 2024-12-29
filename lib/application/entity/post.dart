import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ratemy/application/entity/user.dart';

class Post {
  final User user;
  final double pictureRating;
  final int userRating;
  final String imageUrl;
  final Timestamp? postTimestamp;
  final String? postId;
  final int? raintingsNo;

  Post(this.user, this.pictureRating, this.userRating, this.imageUrl,
      {this.postTimestamp, this.postId, this.raintingsNo});

  Post copyWith({double? pictureRating}) {
    return Post(
      user,
      pictureRating ?? this.pictureRating,
      userRating,
      imageUrl,
    );
  }
}
