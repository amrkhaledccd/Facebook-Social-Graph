import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/models/group.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/group_provider.dart';
import 'package:social_graph_app/services/association_service.dart';

class GroupDetailsAppbar extends StatefulWidget {
  final Group group;
  const GroupDetailsAppbar(this.group, {Key? key}) : super(key: key);

  @override
  State<GroupDetailsAppbar> createState() => _GroupDetailsAppbarState();
}

class _GroupDetailsAppbarState extends State<GroupDetailsAppbar> {
  bool _loading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final _group = ModalRoute.of(context)!.settings.arguments as Group;
      final _authProvider = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<GroupProvider>(context, listen: false)
          .checkIfJoinedByCurrentUser(_authProvider.currentUser.id, _group.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      collapsedHeight: 100,
      pinned: true,
      flexibleSpace: Container(
        padding: const EdgeInsets.all(10),
        height: 200,
        width: double.infinity,
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          color: const Color(0xFF090F13),
          image: DecorationImage(
              image: Image.network(widget.group.imageUrl).image,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              fit: BoxFit.fitWidth),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                widget.group.name,
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 1,
              child: Consumer<GroupProvider>(
                builder: (_, _groupProvider, _ch) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: _groupProvider.currentUserJoined
                          ? Colors.grey[500]
                          : Theme.of(context).primaryColor,
                    ),
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() {
                              _loading = true;
                            });
                            final _authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            final _associationService =
                                Provider.of<AssociationService>(context,
                                    listen: false);

                            if (_groupProvider.currentUserJoined) {
                              await _associationService.deleteAssociation(
                                  _authProvider.currentUser.id,
                                  widget.group.id,
                                  AssociationType.joined);
                            } else {
                              await _associationService.createAssociation(
                                  _authProvider.currentUser.id,
                                  widget.group.id,
                                  AssociationType.joined);
                            }

                            await _groupProvider.checkIfJoinedByCurrentUser(
                                _authProvider.currentUser.id, widget.group.id);

                            await _groupProvider.findMemberOfGroups(
                                _authProvider.currentUser.id);

                            setState(() {
                              _loading = false;
                            });
                          },
                    child: Text(_loading
                        ? "Loading.."
                        : _groupProvider.currentUserJoined
                            ? "Leave"
                            : "Join")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
