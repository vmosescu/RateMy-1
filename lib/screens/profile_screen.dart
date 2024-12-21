import 'package:flutter/material.dart';
import 'package:ratemy/screens/presentation/profile_presentation.dart';
import 'components/bottom_bar.dart';
// import 'components/title_row.dart';

class ProfileScreen extends StatefulWidget {
  final ProfilePresentation presentation;

  const ProfileScreen({super.key, required this.presentation});

  static String id = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final sW = MediaQuery.sizeOf(context).width;
    final sH = MediaQuery.sizeOf(context).height;
    final double bottomBarH = sW * .3 > 60 ? 60 : sW * .3;
    final double scalingFactor = sH > 700 ? 1 : sH / 700;

    return Scaffold(
      backgroundColor: widget.presentation.background,
      body: Stack(
        children: [
          // Main content centered
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Centers the content vertically
                crossAxisAlignment: CrossAxisAlignment.center, // Aligns horizontally
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(widget.presentation.user.profileImage),
                    onBackgroundImageError: (_, __) =>
                        const Icon(Icons.person, size: 60),
                  ),
                  const SizedBox(height: 20),
                  // User Name
                  Text(
                    widget.presentation.user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.presentation.user.posts.length.toString(), // Random number
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                          const Text(
                            'Photos',
                            style: const TextStyle(
                              color: Colors.white
                            )
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            widget.presentation.user.followers.toString(), // Random number
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                          const Text('Followers',
                            style: const TextStyle(
                              color: Colors.white
                            )
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            widget.presentation.user.following.toString(), // Random number
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                          const Text('Following',
                            style: const TextStyle(
                              color: Colors.white
                            )
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Number of items in a row
                            crossAxisSpacing: 10, // Space between columns
                            mainAxisSpacing: 10, // Space between rows
                          ),
                          itemCount: widget.presentation.user.posts.length,
                          itemBuilder: (context, index) {
                            final post = widget.presentation.user.posts[index];
                            return Image.network(
                              post.imageUrl,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                ],
              ),
            ),
          ),
          // Bottom bar
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: bottomBarH,
              child: BottomBar(scaling: scalingFactor),
            ),
          ),
        ],
      ),


      
    );
  }
}
