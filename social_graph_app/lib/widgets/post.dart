import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostWidget extends StatelessWidget {
  final String postText;

  const PostWidget({Key? key, required this.postText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  "https://schooloflanguages.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg"),
            ),
            title: const Text("Amr Khaled"),
            subtitle: Text(DateFormat.yMMMd().format(DateTime.now())),
            trailing: const Icon(Icons.more_horiz),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 5, left: 10),
                child: Text(
                  postText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Ahmed, Ali and 9 others",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                Text(
                  "1 Comment",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              thickness: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.grey[800]),
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_off_alt_outlined),
                label: const Text("Like"),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.grey[800]),
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined),
                label: const Text("Comment"),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.grey[800]),
                onPressed: () {},
                icon: const Icon(Icons.share),
                label: const Text("Share"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}