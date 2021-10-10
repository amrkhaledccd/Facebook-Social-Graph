import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/services/association_service.dart';
import 'package:social_graph_app/services/auth_service.dart';

class ProfileCard extends StatefulWidget {
  final User user;
  const ProfileCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  var isFriendChecking = false;
  var isLoading = false;
  var isFriend = false;

  @override
  void initState() {
    super.initState();
    final _authService = Provider.of<AuthService>(context, listen: false);
    final _associationService = AssociationService();

    if (_authService.currentUser.id != widget.user.id) {
      setState(() {
        isFriendChecking = true;
      });
      _associationService
          .associationExists(
            _authService.currentUser.id,
            widget.user.id,
            AssociationType.friend,
          )
          .then(
            (value) => setState(() {
              isFriend = value;
            }),
          )
          .whenComplete(() => setState(() {
                isFriendChecking = false;
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context, listen: false);
    final _scaffoldMessenger = ScaffoldMessenger.of(context);

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey[100],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(widget.user.imageUrl),
            ),
          ),
          const SizedBox(height: 10),
          _authService.currentUser.id == widget.user.id
              ? ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[200],
                  ),
                  onPressed: () {
                    _authService.logout();
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.black),
                  ))
              : isFriendChecking
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: isFriend
                            ? Colors.grey[500]
                            : Theme.of(context).primaryColor,
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              final _associationService = AssociationService();
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                if (!isFriend) {
                                  await _associationService.createAssociation(
                                      _authService.currentUser.id,
                                      widget.user.id,
                                      AssociationType.friend);
                                } else {
                                  await _associationService.deleteAssociation(
                                      _authService.currentUser.id,
                                      widget.user.id,
                                      AssociationType.friend);
                                }

                                setState(() {
                                  isFriend = !isFriend;
                                  isLoading = false;
                                });
                              } catch (error) {
                                _scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                      content: Text("unable to create post")),
                                );
                              }
                            },
                      icon: Icon(isFriend ? Icons.close : Icons.add_outlined),
                      label: Text(isLoading
                          ? "Loading..."
                          : isFriend
                              ? "Unfriend"
                              : 'Add friend'),
                    ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
