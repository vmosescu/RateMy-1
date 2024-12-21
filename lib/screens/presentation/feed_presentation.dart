import 'dart:math';
import 'dart:ui';
import 'dart:developer' as dev;

import 'package:ratemy/application/entity/post.dart';
import 'package:ratemy/screens/presentation/presentation.dart';

import '../../application/entity/user.dart';

class FeedPresentation extends Presentation {

  @override
  get background => const Color.fromARGB(255, 27, 27, 1);

  List<Post> getTestPosts() {
    User u1 = User(name: 'Alex', profileImage: 'assets/example_profile_image.jpeg');
    User u2 = User(name: 'Alin', profileImage: 'assets/example_profile_image.jpeg');
    User u3 = User(name: 'Marian', profileImage: 'assets/example_profile_image.jpeg');

    return [
      Post(u1, 5.9, 0, 'https://picsum.photos/id/${Random().nextInt(1000)}/400/800'),
      Post(u2, 8.2, 0, 'https://picsum.photos/id/${Random().nextInt(1000)}/400/800'),
      Post(u3, 7.5, 0, 'https://picsum.photos/id/${Random().nextInt(1000)}/400/800'),
      Post(u1, 3.5, 0, 'https://picsum.photos/id/${Random().nextInt(1000)}/400/800'),
      Post(u2, 6.8, 0, 'https://picsum.photos/id/${Random().nextInt(1000)}/400/800'),
      Post(u3, 4.8, 0, 'https://picsum.photos/id/${Random().nextInt(1000)}/400/800'),
    ];
  }

  Future<List<Post>> getRandomPosts(int count) {
    List<Post> res = [];
    for (int i = 0; i < count; i++) {
      res.add(_getRandomPost('User $i'));
    }

    return Future.delayed(const Duration(seconds: 1), () {
      return res;
    });
  }


  Post _getRandomPost(String name) {
    final user = User(name: name, profileImage: 'assets/example_profile_image.jpeg');
    final pictureRating = (100 * Random().nextDouble()).round() / 10;
    const userRating = 0;

    return Post(user, pictureRating, userRating, 'https://picsum.photos/id/${Random().nextInt(1000)}/800/400');
  }
}

class PostView {
  final String image;
  double pictureRating;
  int userRating;

  PostView(Post post):
    image = post.imageUrl,
    pictureRating = post.pictureRating,
    userRating = post.userRating;
}

class PostsEffectiveList {
  final FeedPresentation presentation;
  List<Post> posts = [];
  List<Post> last = [];
  var updateEndOfList = false;

  PostsEffectiveList(this.presentation, [this.posts = const []]);
  
  int get length => posts.length;
  int get updatePoint => posts.length - 2;

  String nextImage(int currentIndex) {
    if (posts.length > currentIndex + 1) {
      return posts[currentIndex + 1].imageUrl;
    } else {
      return posts[0].imageUrl;
    }
  }

  Post at(int index) {
    return posts[index];
  }
  
  bool _atUpdatePoint(int index) {
    return index % posts.length == updatePoint;
  }

  bool _atStartPoint(int index) {
    return index % posts.length == 0;
  }

  Future<void> _updateBeginning() {
    dev.log('Updating beginning of list');
    return presentation.getRandomPosts(posts.length).then((posts) {
      last = [...posts];

      for (int i = 0; i < updatePoint; i++) {
        this.posts[i] = posts[i];
      }

      dev.log('Done updating');
    });
  }
  
  _updateEnd() {
    dev.log('Updating end of list');
    for (int i = updatePoint; i < posts.length; i++) {
      posts[i] = last[i];
    }
  }

  void onPageChanged(int pageViewIndex) {
    // After passing the index when updating the start of the list, need to update the end of the list
    // When reaching the beginning of sequence, update the end of the list
    if (_atStartPoint(pageViewIndex) && updateEndOfList) {
      updateEndOfList = false;
      _updateEnd();
    }


    // Get more elements when approaching the end
    // When reaching the update point change the first half of effective list
    // I also want to prevent updating twice without passing forward
    if (_atUpdatePoint(pageViewIndex) && !updateEndOfList) {
      updateEndOfList = true;
      _updateBeginning();
    }
  }
}