import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_previewer_aad/link_previewer_aad.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/models/post.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/comment_provider.dart';
import 'package:social_graph_app/providers/user_provider.dart';
import 'package:social_graph_app/services/association_service.dart';
import 'package:social_graph_app/widgets/comment_field.dart';
import 'package:social_graph_app/widgets/likers_dialog.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  var likesText = "";
  var likedByCurrentUser = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setLikesText();
      Provider.of<CommentProvider>(context, listen: false)
          .countComments(widget.post.id);
    });
    super.initState();
  }

  void setLikesText() async {
    final _associationService =
        Provider.of<AssociationService>(context, listen: false);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);

    var likes = await _associationService.countAssociation(
        widget.post.id, AssociationType.liked_by);

    final isLikedByCurrentUser = await _associationService.associationExists(
      _authProvider.currentUser.id,
      widget.post.id,
      AssociationType.liked_by,
    );

    if (likes == 0) {
      return;
    }
    var text = "$likes";

    if (isLikedByCurrentUser) {
      if (likes == 1) {
        text = "You";
      } else if (likes == 2) {
        text = "You and ${likes - 1} more";
      } else {
        text = "You and ${likes - 1} others";
      }
    }

    setState(() {
      likesText = text;
      likedByCurrentUser = isLikedByCurrentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _commentProvider = Provider.of<CommentProvider>(context);
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    final _associationService =
        Provider.of<AssociationService>(context, listen: false);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
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
              widget.post.text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (widget.post.url.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: LinkPreviewerAad(
                link: widget.post.url,
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
                if (likesText.isNotEmpty)
                  TextButton.icon(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => LikersDialog(postId: widget.post.id),
                      );
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          gradient: RadialGradient(colors: [
                            Colors.blue,
                            Theme.of(context).primaryColor,
                          ]),
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle),
                      child: const Icon(
                        Icons.thumb_up,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    label: Text(
                      likesText,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                if (_commentProvider.numOfComments > 0)
                  Text(
                    '${_commentProvider.numOfComments} ${_commentProvider.numOfComments == 1 ? "Comment" : "Comments"}',
                    style: const TextStyle(color: Colors.black54),
                  ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Divider(thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.grey[800]),
                onPressed: () async {
                  if (likedByCurrentUser) {
                    await _associationService.deleteAssociation(
                        _authProvider.currentUser.id,
                        widget.post.id,
                        AssociationType.liked);
                  } else {
                    await _associationService.createAssociation(
                        _authProvider.currentUser.id,
                        widget.post.id,
                        AssociationType.liked);
                  }
                  setLikesText();
                },
                icon: likedByCurrentUser
                    ? Icon(
                        Icons.thumb_up,
                        color: Theme.of(context).primaryColor,
                      )
                    : const Icon(
                        Icons.thumb_up_off_alt,
                        color: Colors.black,
                      ),
                label: Text("Like",
                    style: TextStyle(
                      color: likedByCurrentUser
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    )),
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
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Divider(thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 5,
            ),
            child: CommentField(postId: widget.post.id),
          )
        ],
      ),
    );
  }
}
