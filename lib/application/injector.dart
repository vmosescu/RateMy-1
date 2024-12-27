import 'package:ratemy/screens/presentation/add_photo_presentation.dart';
import 'package:ratemy/screens/presentation/login_presentation.dart';
import 'package:ratemy/screens/presentation/profile_presentation.dart';
import 'package:ratemy/application/entity/user.dart';
import 'package:ratemy/application/entity/post.dart';

import '../framework/api_service.dart';
import '../screens/presentation/feed_presentation.dart';

class Injector {
  static final Injector _instance = Injector._internal();

  factory Injector() {
    return _instance;
  }

  Injector._internal();


  // SERVICES
  APIService getAPIService() {
    return APIService();
  }

  // MAPPERS

  // USE CASES

  // PRESENTATION
  LoginPresentation getLoginPresentation() {
    return LoginPresentation();
  }

  FeedPresentation getFeedPresentation() {
    return FeedPresentation();
  }

  ProfilePresentation getProfilePresentation() {
    final user = User(
    name: 'Greg',
    profileImage: 'https://picsum.photos/id/69/200/300',
  );

  user.posts.addAll([
    Post(
      user,
      4.5,
      5,
      'https://picsum.photos/id/1011/200/300',
    ),
    Post(
      user,
      4.7,
      4,
      'https://picsum.photos/id/1012/200/300',
    ),
    Post(
      user,
      3.9,
      3,
      'https://picsum.photos/id/1013/200/300',
    ),
    Post(
      user,
      3.9,
      3,
      'https://picsum.photos/id/1014/200/300',
    ),
  ]);

  return ProfilePresentation(user: user);
  }

  AddPhotoPresentation getAddPhotoPresentation() {
    return AddPhotoPresentation();
  }
}