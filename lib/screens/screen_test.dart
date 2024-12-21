import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ratemy/screens/components/bottom_bar.dart';
import 'package:ratemy/screens/components/test_post_widget.dart';
import 'package:ratemy/screens/presentation/feed_presentation.dart';



class TestScreen extends StatefulWidget {
  final FeedPresentation presentation;

  const TestScreen({super.key, required this.presentation});

  static String id = 'test_screen';

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
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

              Container(
                color: Colors.green,
                height: searchBarH,
                child: Center(
                  child: _buildTopSearchBar(),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (int index) {
                    _posts.onPageChanged(index);
                  },
                  itemBuilder: (context, index) {
                    final effectiveIndex = index % _posts.length;
                    log('showing post at index $effectiveIndex');
                    return TestPostWidget(presentation: widget.presentation, post: _posts.at(effectiveIndex));
                  },
                ),
              ),

              Container(
                color: Colors.yellow,
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
            // iconSize: 30,
            icon: const Icon(Icons.search), color: widget.presentation.primary,),

          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            // iconSize: 30,
            icon: const Icon(Icons.send), color: widget.presentation.secondary,)
        ],
      ),
    );
  }
}

