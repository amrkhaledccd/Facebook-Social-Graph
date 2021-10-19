import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/providers/comment_provider.dart';
import 'package:social_graph_app/widgets/comment_view.dart';

class CommentList extends StatelessWidget {
  final String postId;
  const CommentList({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _commentProvider = Provider.of<CommentProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (_commentProvider.comments.isEmpty)
          TextButton(
            child: Text(
              'View ${_commentProvider.numOfComments} comments...',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onPressed: () async {
              await _commentProvider.loadPostComments(postId);
            },
          ),
        if (_commentProvider.comments.isNotEmpty)
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _commentProvider.comments.length,
              itemBuilder: (_, i) =>
                  CommentView(comment: _commentProvider.comments[i]))
      ],
    );
  }
}
