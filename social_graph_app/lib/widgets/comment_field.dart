import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/comment_provider.dart';
import 'package:social_graph_app/services/association_service.dart';

class CommentField extends StatefulWidget {
  final String postId;
  const CommentField({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  final _textContrller = TextEditingController();
  bool _commenting = false;

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    final _associationService =
        Provider.of<AssociationService>(context, listen: false);
    final _commentProvider =
        Provider.of<CommentProvider>(context, listen: false);

    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(_authProvider.currentUser.imageUrl),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _textContrller,
            onChanged: (value) => setState(() {}),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              hintText: "Write a comment...",
              fillColor: Colors.blueGrey[50],
              filled: true,
              focusColor: Colors.grey[550],
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
              suffixIcon: IconButton(
                  onPressed: () {},
                  splashColor: Colors.transparent,
                  splashRadius: 20,
                  icon: Icon(
                    Icons.image_outlined,
                    color: Colors.grey[550],
                  )),
            ),
          ),
        ),
        if (_textContrller.value.text.isNotEmpty)
          _commenting
              ? const CircularProgressIndicator()
              : IconButton(
                  onPressed: () async {
                    if (_textContrller.value.text.isNotEmpty) {
                      setState(() {
                        _commenting = true;
                      });
                      final comment = await _commentProvider
                          .createComment(_textContrller.value.text);
                      await _associationService.createAssociation(
                        _authProvider.currentUser.id,
                        comment.id,
                        AssociationType.created,
                      );
                      await _associationService.createAssociation(
                        widget.postId,
                        comment.id,
                        AssociationType.has,
                      );
                      _commentProvider.countComments(widget.postId);
                      setState(() {
                        _textContrller.clear();
                        _commenting = false;
                      });
                    }
                  },
                  splashRadius: 22,
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                )
      ],
    );
  }
}
