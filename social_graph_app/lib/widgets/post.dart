import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_previewer_aad/link_previewer_aad.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/models/post.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/user_provider.dart';
import 'package:social_graph_app/services/association_service.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    final _associationService =
        Provider.of<AssociationService>(context, listen: false);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(_userProvider.user!.imageUrl),
            ),
            title: Text(_userProvider.user!.name),
            subtitle: Text(DateFormat.yMMMd().format(DateTime.now())),
            trailing: const Icon(Icons.more_horiz),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5, left: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              post.text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (post.url.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: LinkPreviewerAad(
                link: post.url,
                direction: ContentDirection.horizontal,
                borderColor: Colors.black12,
                borderRadius: 8,
                bodyTextColor: Colors.black54,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Ahmed, Ali and 9 others",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                Text(
                  "1 Comment",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              thickness: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.grey[800]),
                onPressed: () async {
                  await _associationService.createAssociation(
                      _authProvider.currentUser.id,
                      post.id,
                      AssociationType.liked);
                },
                icon: const Icon(Icons.thumb_up_off_alt_outlined),
                label: const Text("Like"),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.grey[800]),
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined),
                label: const Text("Comment"),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.grey[800]),
                onPressed: () {},
                icon: const Icon(Icons.share),
                label: const Text("Share"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
