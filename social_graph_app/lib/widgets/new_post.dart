import 'package:flutter/material.dart';
import 'package:link_previewer_aad/link_previewer_aad.dart';
import 'package:provider/provider.dart';

import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/post_provider.dart';
import 'package:social_graph_app/services/association_service.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _textContrller = TextEditingController();
  var _posting = false;
  var _detectedUrl = "";

  @override
  void dispose() {
    super.dispose();
    _textContrller.dispose();
    _detectedUrl = "";
  }

  void _detectUrl(String value) {
    if (_detectedUrl.isNotEmpty) {
      return;
    }
    try {
      final exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
      final match = exp.allMatches(value).first;

      setState(() {
        _detectedUrl = value.substring(match.start, match.end);
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    final _postProvider = Provider.of<PostProvider>(context, listen: false);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    final _associationService =
        Provider.of<AssociationService>(context, listen: false);

    final _scaffoldMessenger = ScaffoldMessenger.of(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage(_authProvider.currentUser.imageUrl),
                ),
                const SizedBox(width: 10),
                Text(
                  _authProvider.currentUser.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              minLines: 2,
              maxLines: 100,
              controller: _textContrller,
              onChanged: (value) {
                _detectUrl(value);
                setState(() {});
              },
              decoration: const InputDecoration(
                hintText: "What is on your mind?",
                hintStyle: TextStyle(fontSize: 18),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
          if (_detectedUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: LinkPreviewerAad(
                link: _detectedUrl,
                direction: ContentDirection.horizontal,
                borderColor: Colors.black12,
                borderRadius: 8,
                bodyTextColor: Colors.black54,
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: _textContrller.value.text.isEmpty || _posting
                  ? null
                  : () async {
                      setState(() {
                        _posting = true;
                      });
                      try {
                        final _post = await _postProvider.createPost(
                            _textContrller.value.text, _detectedUrl);

                        await _associationService.createAssociation(
                            _authProvider.currentUser.id,
                            _post.id,
                            AssociationType.created);

                        await _postProvider
                            .findUserPosts(_authProvider.currentUser.id);

                        setState(() {
                          _textContrller.clear();
                        });
                      } catch (error) {
                        _scaffoldMessenger.showSnackBar(
                          const SnackBar(
                              content: Text("unable to create post")),
                        );
                      } finally {
                        setState(() {
                          _posting = false;
                          _detectedUrl = "";
                        });
                      }
                    },
              child: const Text("Post"),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
          _posting ? const LinearProgressIndicator() : const SizedBox()
        ],
      ),
    );
  }
}
