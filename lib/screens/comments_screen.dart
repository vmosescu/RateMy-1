import 'package:flutter/material.dart';
import 'package:ratemy/screens/presentation/comments_presentation.dart';

class CommentsScreen extends StatelessWidget {
  final CommentsPresentation presentation;

  const CommentsScreen({Key? key, required this.presentation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: presentation.comments.length,
        itemBuilder: (context, index) {
          final comment = presentation.comments[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(comment.user.profileImage),
            ),
            title: Text(comment.user.name),
            subtitle: Text(comment.text),
          );
        },
      ),
    );
  }
}