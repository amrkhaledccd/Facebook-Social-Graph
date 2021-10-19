import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/comment.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/providers/comment_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentView extends StatelessWidget {
  final Comment comment;
  const CommentView({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _commentProvider =
        Provider.of<CommentProvider>(context, listen: false);

    return FutureBuilder(
      future: _commentProvider.findCommentCreator(comment.id),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 3);
        }
        final creator = snapshot.data as User;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(creator.imageUrl),
          ),
          title: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  backgroundColor: Colors.blueGrey[50],
                  labelPadding: const EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        creator.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        comment.text,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text(
                      'Like - Reply - ${timeago.format(comment.date, locale: "en_short")}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
