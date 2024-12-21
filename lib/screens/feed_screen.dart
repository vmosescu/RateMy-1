import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:ratemy/screens/presentation/feed_presentation.dart';

import 'components/bottom_bar.dart';
import 'components/post_widget.dart';

class FeedScreen extends StatefulWidget {
  final FeedPresentation presentation;

  const FeedScreen({super.key, required this.presentation,});

  static String id = 'feed_screen';

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  double rateButtonWidth = 0;
  double bottomPositionRateBtn = 100;
  late PostsEffectiveList _posts;
  bool updateEndOfList = false;

  @override
  void initState() {
    _posts = PostsEffectiveList(widget.presentation, widget.presentation.getTestPosts());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      rateButtonWidth = MediaQuery.sizeOf(context).width * .13;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sW = MediaQuery.sizeOf(context).width;
    final sH = MediaQuery.sizeOf(context).height;
    final double searchBarH = sW * .2 > 50 ? 50 : sW * .2;
    final double bottomBarH = sW * .3 > 60 ? 60 : sW * .3;
    final double scalingFactor = sH > 700 ? 1 : sH / 700;

    return Scaffold(
      backgroundColor: widget.presentation.background,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              widget.presentation.gapAboveScreenTitle,

              // SEARCH BAR
              SizedBox(
                height: searchBarH,
                child: _buildTopSearchBar(),
              ),


              // IMAGE + TOOLS + PROFILE
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (int index) {
                    _posts.onPageChanged(index);
                    precacheImage(NetworkImage(_posts.nextImage(index)), context);
                  },
                  itemBuilder: (context, index) {
                    final effectiveIndex = index % _posts.length;
                    dev.log('showing post at index $effectiveIndex');
                    return PostWidget(presentation: widget.presentation, post: _posts.at(effectiveIndex));
                  },
                ),
              ),


              // BOTTOM TOOLBAR
              SizedBox(
                height: bottomBarH,
                child: BottomBar(scaling: scalingFactor,),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildTopSearchBar() {
    return Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 20.0),
        child: Row(
          children: [
            const Expanded(child: Text('RATE MY', style: TextStyle(color: Colors.white))),

            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(Icons.search), color: widget.presentation.primary,),

            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(Icons.send), color: widget.presentation.secondary,)
          ],
        ),
      );
  }
}

