import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ratemy/application/entity/post.dart';
import 'package:ratemy/application/entity/user.dart';
import 'package:ratemy/screens/components/postmy_widget.dart';
import 'package:ratemy/screens/presentation/feed_presentation.dart';

import 'components/bottom_bar.dart';

import 'dart:developer' as dev;

class FeedmyScreen extends StatefulWidget {
  final FeedPresentation presentation;

  const FeedmyScreen({
    super.key,
    required this.presentation,
  });

  static String id = 'feedmy_screen';

  @override
  State<FeedmyScreen> createState() => _FeedmyScreenState();
}

class _FeedmyScreenState extends State<FeedmyScreen> {
  double rateButtonWidth = 0;
  double bottomPositionRateBtn = 100;
  bool _isLoadingPost = true;
  int _index = -1;
  Post? _post;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rateButtonWidth = MediaQuery.sizeOf(context).width * .13;
    });
    super.initState();
  }

  void _loadPost(Map<String, dynamic> photoMeta, int index) async {
    if (_index == index) {
      return;
    }
    setState(() {
      _isLoadingPost = true;
    });
    String imageUrl = await photoMeta['photo'];
    final userPostId = await photoMeta['userId'];
    final userPost = await FirebaseFirestore.instance
        .collection('users')
        .doc(userPostId)
        .get();

    final user = User(
      name: userPost.get('username'),
      profileImage: userPost.get('image_url'),
    );
    _post = Post(user, 4.5, 4, imageUrl);
    setState(() {
      _index = index;
      _isLoadingPost = false;
    });
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
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('photos')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (ctx, photoSnapshot) {
                    if (photoSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!photoSnapshot.hasData ||
                        photoSnapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No photos found.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    if (photoSnapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Something is wrong with the backend!',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final loadedPhotosMeta = photoSnapshot.data!.docs;
                    dev.log('loaded ${loadedPhotosMeta.length} photos meta');

                    return PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: loadedPhotosMeta.length,
                      itemBuilder: (ctx, index) {
                        final photoMeta = loadedPhotosMeta[index].data();
                        dev.log('loading meta at position $index');
                        _loadPost(photoMeta, index);
                        return _isLoadingPost
                            ? const Center(child: CircularProgressIndicator())
                            : PostmyWidget(
                                presentation: widget.presentation,
                                post: _post!);
                      },
                    );
                  },
                ),
              ),

              // BOTTOM TOOLBAR
              SizedBox(
                height: bottomBarH,
                child: BottomBar(
                  scaling: scalingFactor,
                ),
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
          const Expanded(
              child: Text('RATE MY', style: TextStyle(color: Colors.white))),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: widget.presentation.primary,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: const Icon(Icons.send),
            color: widget.presentation.secondary,
          )
        ],
      ),
    );
  }
}
