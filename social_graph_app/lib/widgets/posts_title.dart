import 'package:flutter/material.dart';

class PostsTitle extends StatelessWidget {
  const PostsTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.black12))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Posts",
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list_alt),
                  label: const Text("Filters")),
            ],
          ),
        ));
  }
}
