import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ratemy/application/entity/post.dart';
import 'package:ratemy/screens/components/rate_button.dart';

import '../presentation/feed_presentation.dart';
import 'grade_star.dart';

class TestPostWidget extends StatefulWidget {
  final FeedPresentation presentation;
  final Post post;

  const TestPostWidget({super.key, required this.presentation, required this.post});

  @override
  State<TestPostWidget> createState() => _TestPostWidgetState();
}

class _TestPostWidgetState extends State<TestPostWidget> {
  double rateButtonWidth = 0;
  double topPositionRateBtn = 0;
  double bottomPositionRateBtn = 0;
  final double profileImageSize = 70;
  final List<String> previousImages = ['https://picsum.photos/id/${Random().nextInt(1000)}/800/800'];
  String imageUrl = '';
  bool loading = false;
  double currentGrade = -1;
  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
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
                child: Container(
                  width: sW,
                  height: sW,
                  color: Colors.blue,
                  child: const Center(child: Text('Image')),
                ),
              ),
            ),

            SizedBox(height: 20 * scalingFactor,),

            // TOOLS BUTTONS
            Container(
              color: Colors.lightBlueAccent,
              height: 50,
              child: Center(
                child: _buildToolsRow(scalingFactor - 0.2),
              ),
            ),

            // PROFILE IMAGE
            Container(
              color: Colors.red,
              height: 100,
              child: Center(child: Text('Profile ${widget.post.user.name}')),
            ),
          ],
        ),

        // RATE BUTTON
        Positioned(
          // top: topPositionRateBtn,
          bottom : bottomPositionRateBtn,
          right: 20,
          child: RateButton(
            presentation: widget.presentation,
            width: rateButtonWidth,
            saveGrade: (grade) {},
          ),
        ),


        // CURRENT GRADE
        Positioned(
            top: 30,
            left: 10,
            child: GradeStar(grade: widget.post.pictureRating, width: 70)
        ),
      ],
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
            onPressed: () {},
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
}