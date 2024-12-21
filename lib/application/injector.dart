import 'package:ratemy/screens/presentation/login_presentation.dart';
import 'package:ratemy/screens/presentation/profile_presentation.dart';
import 'package:ratemy/application/entity/user.dart';
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
    return ProfilePresentation(
      user: User(
        name: 'Greg',
        profileImage: 'assets/example_profile_image.jpeg',
      )
    );
  }
}