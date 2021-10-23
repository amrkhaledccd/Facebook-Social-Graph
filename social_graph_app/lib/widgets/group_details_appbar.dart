import 'package:flutter/material.dart';
import 'package:social_graph_app/models/group.dart';

class GroupDetailsAppbar extends StatelessWidget {
  final Group group;
  const GroupDetailsAppbar(this.group, {Key? key}) : super(key: key);

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
              image: Image.network(group.imageUrl).image,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              fit: BoxFit.fitWidth),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                group.name,
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
              child:
                  ElevatedButton(onPressed: () {}, child: const Text("Join")),
            )
          ],
        ),
      ),
    );
  }
}
