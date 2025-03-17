import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ratemy/application/entity/post.dart';
import 'package:ratemy/screens/components/rate_button.dart';

import '../presentation/feed_presentation.dart';
import 'grade_star.dart';
import 'package:ratemy/application/entity/comment.dart';
import 'package:ratemy/screens/comments_screen.dart';
import 'package:ratemy/screens/presentation/comments_presentation.dart';
import 'package:ratemy/application/entity/user.dart';

class PostWidget extends StatefulWidget {
  final FeedPresentation presentation;
  final Post post;

  const PostWidget({super.key, required this.presentation, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  double rateButtonWidth = 0;
  double topPositionRateBtn = 0;
  double bottomPositionRateBtn = 0;
  final double profileImageSize = 70;
  final List<String> previousImages = ['https://picsum.photos/id/${Random().nextInt(1000)}/800/800'];
  String imageUrl = '';
  bool loading = false;
  double currentGrade = -1;
  final GlobalKey _imageKey = GlobalKey();
  late PostView post;

  @override
  void initState() {
    // This should be used instead of widget.post
    post = PostView(widget.post);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = _imageKey.currentContext!.findRenderObject() as RenderBox;
      final iH = renderBox.size.height;

      final wH = _getHeight(context);

      rateButtonWidth = MediaQuery.sizeOf(context).width * .13;

      setState(() {
        topPositionRateBtn = iH;
        bottomPositionRateBtn = wH - topPositionRateBtn - 95;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sW = MediaQuery.sizeOf(context).width;
    final sH = MediaQuery.sizeOf(context).height;
    final double scalingFactor = sH > 700 ? 1 : sH / 700;

    return Stack(
      children: [
        Column(
          children: [

            SizedBox(height: 20 * scalingFactor,),

            // IMAGE
            Flexible(
              key: _imageKey,
              child: FractionallySizedBox(
                child: SizedBox(
                  width: sW,
                  height: sW * 1.2,
                  child: _buildImage(widget.post.imageUrl),
                ),
              ),
            ),

            SizedBox(height: 20 * scalingFactor,),

            // TOOLS BUTTONS
            SizedBox(
              height: 50,
              child: Center(
                child: _buildToolsRow(scalingFactor - 0.2),
              ),
            ),

            // PROFILE IMAGE
            SizedBox(
              height: 100,
              child: _buildProfileRow(profileImageSize),
            ),
          ],
        ),

        // RATE BUTTON
        Positioned(
          bottom : bottomPositionRateBtn,
          right: 20,
          child: RateButton(
            presentation: widget.presentation,
            width: rateButtonWidth,
            userRating: post.userRating,
            saveGrade: (grade) {
              setState(() {
                final updatedPictureRating = (widget.post.pictureRating * 10 + grade) / 11;
                setState(() {
                  post.pictureRating = (10 * updatedPictureRating).round() / 10;
                  post.userRating = grade;
                });
              });
            },
          ),
        ),


        // PICTURE RATING
        Positioned(
            top: 30,
            left: 10,
            child: GradeStar(grade: post.pictureRating, width: 70)
        ),
      ],
    );
  }

  Widget _buildImage(String src) {
    return Image.network(
        src,
        gaplessPlayback: true,
        errorBuilder: _onError,
        fit: BoxFit.cover,
      );
  }

  Widget _onError(BuildContext context, Object error, StackTrace? stackTrace) {
    double w = MediaQuery.sizeOf(context).width;
    return Container(
      color: widget.presentation.secondary,
      height: w,
      width: w,
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: widget.presentation.primary,
          size: 50,
        ),
      ),
    );
  }

  double _getHeight(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  Widget _buildToolsRow(double scalingFactor) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 10.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsScreen(
          presentation: CommentsPresentation(
            comments: [
              Comment(
                text: 'Merge joooon',
                user: User(
                  name: 'Stefan',
                  profileImage: 'https://picsum.photos/id/1011/50/50',
                ),
              ),
              Comment(
                text: 'Hai Dinamo',
                user: User(
                  name: 'Dave',
                  profileImage: 'https://picsum.photos/id/1012/50/50',
                ),
              ),
            ],
          ),
        ),
      ),
    );
            },
            iconSize: 40 * scalingFactor,
            icon: const Icon(Icons.insert_comment), color: widget.presentation.primary,),

          const SizedBox(width: 10,),

          IconButton(
            onPressed: () {},
            iconSize: 40 * scalingFactor,
            icon: const Icon(Icons.keyboard_return), color: widget.presentation.primary,),

          const SizedBox(width: 10,),

          IconButton(
            onPressed: () {},
            iconSize: 40 * scalingFactor,
            icon: const Icon(Icons.bookmark), color: widget.presentation.primary,),

          // const RateButton(),
        ],
      ),
    );
  }

  Widget _buildProfileRow(double profileImageSize) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: Row(
        children: [
          Image.asset(
            alignment: Alignment.centerLeft,
            widget.post.user.profileImage,
            width: profileImageSize,
            height: profileImageSize,
          ),
          const SizedBox(width: 10),
          Text(widget.post.user.name, style: const TextStyle(color: Color.fromARGB(255, 225, 225, 225), fontSize: 18,))
        ],
      ),
    );
  }
}