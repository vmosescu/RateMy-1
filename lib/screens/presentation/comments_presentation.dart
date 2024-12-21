import 'package:ratemy/screens/presentation/presentation.dart';
import 'package:ratemy/application/entity/comment.dart';

class CommentsPresentation extends Presentation {
  List<Comment> comments;

  CommentsPresentation({
    required this.comments
  });
}