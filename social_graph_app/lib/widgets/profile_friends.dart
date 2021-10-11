import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/screens/profile_screen.dart';
import 'package:social_graph_app/services/association_service.dart';
import 'package:social_graph_app/services/auth_service.dart';

class ProfileFriends extends StatefulWidget {
  final User user;
  const ProfileFriends({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileFriends> createState() => _ProfileFriendsState();
}

class _ProfileFriendsState extends State<ProfileFriends> {
  List<User> friends = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      loadFriends();
    });

    super.initState();
  }

  Future<void> loadFriends() async {
    final _authService = Provider.of<AuthService>(context, listen: false);
    await _authService
        .findUserFriends(_authService.currentUser.id)
        .then((users) => setState(() {
              friends = users;
            }))
        .catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AssociationService>(context);
    return friends.isEmpty
        ? const SizedBox()
        : Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.black12),
                ),
                color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Friends',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '4 friends',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 7 / 9,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: friends.length,
                    itemBuilder: (ctx, i) =>
                        FriendItem(user: friends[i], onback: loadFriends),
                  )
                ],
              ),
            ),
          );
  }
}

class FriendItem extends StatelessWidget {
  final User user;
  final Function onback;
  const FriendItem({Key? key, required this.user, required this.onback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context)
            .pushNamed(ProfileScreen.routeName, arguments: user.username);
        onback();
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                  child: Image.network(
                    user.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    softWrap: true,
                    maxLines: 2,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
