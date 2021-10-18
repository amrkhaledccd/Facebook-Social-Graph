import 'package:flutter/material.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/providers/post_provider.dart';
import 'package:social_graph_app/screens/profile_screen.dart';

class LikersDialog extends StatelessWidget {
  final String postId;
  const LikersDialog({Key? key, required this.postId}) : super(key: key);

  Widget likeIcon(context, double? iconSize) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            gradient: RadialGradient(colors: [
              Colors.blue,
              Theme.of(context).primaryColor,
            ]),
            shape: BoxShape.circle),
        child: Icon(
          Icons.thumb_up,
          color: Colors.white,
          size: iconSize,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PostProvider().findPostLikers(postId),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data as List<User>;

        return Dialog(
          child: Container(
            constraints: const BoxConstraints(minHeight: 200),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    likeIcon(context, 14),
                    const SizedBox(width: 5),
                    Text(
                      '${data.length}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black54),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (ctx, i) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () => Navigator.of(context).pushNamed(
                                ProfileScreen.routeName,
                                arguments: data[i].username),
                            contentPadding: const EdgeInsets.all(0),
                            leading: Stack(
                              children: [
                                const SizedBox(
                                  height: 45,
                                  width: 45,
                                ),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      NetworkImage(data[i].imageUrl),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: likeIcon(context, 10))
                              ],
                            ),
                            title: Text(data[i].name),
                          ),
                          if (i < data.length - 1)
                            const Padding(
                              padding: EdgeInsets.only(left: 60),
                              child: Divider(color: Colors.black26),
                            )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
