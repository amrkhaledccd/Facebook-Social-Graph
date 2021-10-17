import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/user_provider.dart';
import 'package:social_graph_app/screens/profile_screen.dart';

class ProfileFriends extends StatefulWidget {
  const ProfileFriends({Key? key}) : super(key: key);

  @override
  State<ProfileFriends> createState() => _ProfileFriendsState();
}

class _ProfileFriendsState extends State<ProfileFriends> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final _userProvider = Provider.of<UserProvider>(context, listen: false);
      final _authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (_userProvider.user!.id == _authProvider.currentUser.id) {
        _userProvider.loadUserFriends(_authProvider.token);
        _userProvider.countUserFriends(_authProvider.token);
      } else {
        _userProvider.loadMutualFriends(
            _authProvider.currentUser.id, _authProvider.token);
        _userProvider.countMutualFriends(
            _authProvider.currentUser.id, _authProvider.token);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);

    return _userProvider.friends.isEmpty
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
                    '${_userProvider.friendsCount} ${_userProvider.user!.id == _authProvider.currentUser.id ? "friends" : "mutual friends"}',
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
                    itemCount: _userProvider.friends.length,
                    itemBuilder: (ctx, i) =>
                        FriendItem(user: _userProvider.friends[i]),
                  )
                ],
              ),
            ),
          );
  }
}

class FriendItem extends StatelessWidget {
  final User user;
  const FriendItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context)
            .pushNamed(ProfileScreen.routeName, arguments: user.username);
        final _userProvider = Provider.of<UserProvider>(context, listen: false);
        final _authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (_authProvider.currentUser.id == _userProvider.user!.id) {
          _userProvider.loadUserFriends(_authProvider.token);
          _userProvider.countUserFriends(_authProvider.token);
        } else {
          _userProvider.loadMutualFriends(
              _authProvider.currentUser.id, _authProvider.token);
          _userProvider.countMutualFriends(
              _authProvider.currentUser.id, _authProvider.token);
        }
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
