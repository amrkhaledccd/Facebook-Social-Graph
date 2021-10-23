import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_graph_app/models/group.dart';
import 'package:social_graph_app/screens/group_details.dart';

class VerticleGroupList extends StatelessWidget {
  final List<Group> _groups;
  const VerticleGroupList(this._groups, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: _groups.length,
        itemBuilder: (_, i) => ListTile(
          onTap: () {
            Navigator.of(context)
                .pushNamed(GroupDetails.routeName, arguments: _groups[i]);
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              _groups[i].imageUrl.isNotEmpty
                  ? _groups[i].imageUrl
                  : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfA4HU79bnFZF2GXuPt-G-8aW-lA7HtIvWKlrbPdvRqZUsoQSzn_K9II6tX1Xff_5A_Bo&usqp=CAU",
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            _groups[i].name,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.fade),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.left,
          ),
          subtitle: Text(DateFormat.yMMMd().format(_groups[i].date)),
        ),
      ),
    );
  }
}
