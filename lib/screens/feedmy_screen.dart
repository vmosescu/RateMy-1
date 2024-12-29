import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ratemy/application/entity/post.dart';
import 'package:ratemy/application/entity/user.dart';
import 'package:ratemy/screens/components/postmy_widget.dart';
import 'dart:async';

import 'package:ratemy/screens/presentation/feed_presentation.dart';

import 'components/bottom_bar.dart';
import 'components/post_widget.dart';
import 'dart:developer' as dev;

FirebaseFirestore db = FirebaseFirestore.instance;

class FeedmyScreen extends StatefulWidget {
  final FeedPresentation presentation;

  const FeedmyScreen({
    super.key,
    required this.presentation,
  });

  static String id = 'feed_screen';

  @override
  State<FeedmyScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedmyScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final StreamController<List<dynamic>> _dataStreamController =
      StreamController<List<dynamic>>();
  Stream<List<dynamic>> get dataStream => _dataStreamController.stream;
  final List<Post> _currentPosts = [];
  int _currentIndex = -2;
  Timestamp? _postTimestamp;
  bool _isFetchingData = false;

  double rateButtonWidth = 0;
  double bottomPositionRateBtn = 100;
  late PostsEffectiveList _posts;
  bool updateEndOfList = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rateButtonWidth = MediaQuery.sizeOf(context).width * .13;
    });

    _posts = PostsEffectiveList(
        widget.presentation, widget.presentation.getTestPosts());

    _fetchPosts();
    dev.log('finish first fetch');
    _pageController.addListener(() {
      dev.log(
          'add listener crtIndex=$_currentIndex size=${_currentPosts.length}');
      if (_currentIndex >= _currentPosts.length - 1) {
        dev.log('time to fetch');
        _fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _dataStreamController.close();
    _pageController.dispose();
    //we do not have control cover the _scrollController so it should not be disposed here
    // _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    dev.log('fetch posts $_currentIndex');
    if (_isFetchingData) {
      // Avoid fetching new data while already fetching
      return;
    }

    try {
      _isFetchingData = true;
      _postTimestamp ??= Timestamp.now();
      QuerySnapshot<Map<String, dynamic>> photos = await db
          .collection('photos')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .where('createdAt', isLessThan: _postTimestamp)
          .get();

      dev.log('returns ${photos.docs.length}');
      if (photos.docs.isEmpty) {
        _dataStreamController.close();
        return Future(() => null);
      }

      Set<String> userIds = {};
      for (var doc in photos.docs) {
        userIds.add(doc.get('userId'));
      }
      dev.log('users ${userIds.length}');

      Map<String, User> users = {};

      QuerySnapshot<Map<String, dynamic>> dbUsers = await db
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      for (var doc in dbUsers.docs) {
        dev.log('user ${doc.get('username')}');
        users.putIfAbsent(
            doc.id,
            () => User(
                name: doc.get('username'), profileImage: doc.get('image_url')));
      }

      dev.log('users ${users.length}');

      for (var doc in photos.docs) {
        User user = users[doc.get('userId')]!;
        Post post = Post(user, 5.9, 0, doc.get('photo'),
            postTimestamp: doc.get('createdAt'));
        _currentPosts.add(post);
      }
      dev.log('1');

      _dataStreamController.add(_currentPosts);
      dev.log('2');
    } catch (e) {
      dev.log('Error on fetching: $e');
      _dataStreamController.addError(e);
    } finally {
      _isFetchingData = false;
    }
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
                  stream: dataStream,
                  builder: (ctx, photoSnapshot) {
                    if (photoSnapshot.hasError) {
                      dev.log('Error: ${photoSnapshot.error}');
                      return const Center(
                        child: Text(
                          'Something is wrong with the backend!',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    if (photoSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (photoSnapshot.connectionState ==
                        ConnectionState.done) {
                      return const Center(
                        child: Text(
                          'No more photos.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    if (!photoSnapshot.hasData) {
                      return const Center(
                        child: Text(
                          'No photos found.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }

                    return PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        _currentIndex = index;
                        Post post = _currentPosts[index];
                        _postTimestamp = post.postTimestamp;
                        final effectiveIndex = index % _posts.length;
                        dev.log('showing post at index $effectiveIndex');
                        return PostmyWidget(
                            presentation: widget.presentation, post: post);
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
