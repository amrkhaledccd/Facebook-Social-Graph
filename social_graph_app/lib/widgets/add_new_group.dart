import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/groups_provider.dart';
import 'package:social_graph_app/services/association_service.dart';

class AddNewGroup extends StatefulWidget {
  const AddNewGroup({Key? key}) : super(key: key);

  @override
  _AddNewGroupState createState() => _AddNewGroupState();
}

class _AddNewGroupState extends State<AddNewGroup> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _urlFocusNode = FocusNode();
  String _groupImg = "";
  var loading = false;

  @override
  void initState() {
    super.initState();
    _urlFocusNode.addListener(() {
      if (!_urlFocusNode.hasFocus) {
        setState(() {
          _groupImg = _urlController.value.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _navigator = Navigator.of(context);
    final _associationService =
        Provider.of<AssociationService>(context, listen: false);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Create New Group",
            style: TextStyle(
                color: Colors.black54,
                fontSize: 28,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.black54,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _urlController,
            onChanged: (value) => setState(() {}),
            onSubmitted: (value) => setState(() {
              _groupImg = value;
            }),
            focusNode: _urlFocusNode,
            decoration: InputDecoration(
              hintText: "Image URL",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.black54,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            constraints: const BoxConstraints(maxHeight: 120),
            child: Image.network(
              _groupImg.isNotEmpty
                  ? _groupImg
                  : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfA4HU79bnFZF2GXuPt-G-8aW-lA7HtIvWKlrbPdvRqZUsoQSzn_K9II6tX1Xff_5A_Bo&usqp=CAU",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _nameController.value.text.isEmpty
                        ? null
                        : () async {
                            setState(() {
                              loading = true;
                            });
                            final name = _nameController.value.text;
                            String imageUrl = _urlController.value.text;
                            final _groupProvider = Provider.of<GroupsProvider>(
                                context,
                                listen: false);
                            final _group = await _groupProvider.createGroup(
                                name, imageUrl);

                            await _associationService.createAssociation(
                                _authProvider.currentUser.id,
                                _group.id,
                                AssociationType.created);

                            setState(() {
                              loading = false;
                            });
                            await _groupProvider
                                .findUserGroups(_authProvider.currentUser.id);
                            _navigator.pop();
                          },
                    child: const Text(
                      "Create",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
