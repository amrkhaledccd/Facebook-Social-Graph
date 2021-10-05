import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/services/association_service.dart';
import 'package:social_graph_app/services/auth_service.dart';
import 'package:social_graph_app/services/post_service.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _textContrller = TextEditingController();
  var _posting = false;

  @override
  Widget build(BuildContext context) {
    final _postService = Provider.of<PostService>(context, listen: false);
    final _scaffoldMessenger = ScaffoldMessenger.of(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      "https://schooloflanguages.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg"),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Amr Khaled",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              onChanged: (value) => setState(() {}),
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
                        final _post = await _postService
                            .createPost(_textContrller.value.text);

                        await AssociationService().createAssociation(
                            AuthService().userId,
                            _post.id,
                            AssociationType.created);

                        await _postService.findUserPosts(AuthService().userId);

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
                        });
                      }
                    },
              child: const Text("Post"),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)))),
            ),
          ),
          _posting ? const LinearProgressIndicator() : const SizedBox()
        ],
      ),
    );
  }
}
