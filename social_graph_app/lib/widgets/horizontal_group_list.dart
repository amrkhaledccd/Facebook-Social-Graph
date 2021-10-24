import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/group.dart';
import 'package:social_graph_app/screens/group_details.dart';

class HorizontalGroupList extends StatelessWidget {
  final List<Group> _groups;

  const HorizontalGroupList(this._groups, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      width: double.infinity,
      color: Colors.white,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _groups.length,
          itemBuilder: (_, i) => HorizontlGroupItem(_groups[i])),
    );
  }
}

class HorizontlGroupItem extends StatelessWidget {
  final Group _group;
  const HorizontlGroupItem(this._group, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context)
            .pushNamed(GroupDetails.routeName, arguments: _group);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _group.imageUrl.isNotEmpty
                    ? _group.imageUrl
                    : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfA4HU79bnFZF2GXuPt-G-8aW-lA7HtIvWKlrbPdvRqZUsoQSzn_K9II6tX1Xff_5A_Bo&usqp=CAU",
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 130),
                  child: Text(
                    _group.name,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        overflow: TextOverflow.fade),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat.yMMMd().format(_group.date),
                  style: const TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
