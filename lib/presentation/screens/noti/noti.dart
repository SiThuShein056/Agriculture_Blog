import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:starlight_utils/starlight_utils.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            StarlightUtils.pop();
          },
        ),
        title: const Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Slidable(
                        endActionPane: ActionPane(
                            extentRatio: .3,
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {},
                                icon: Icons.reply,
                                backgroundColor: Colors.grey[300]!,
                              ),
                              SlidableAction(
                                onPressed: (context) {},
                                icon: Icons.delete,
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red[700]!,
                              ),
                            ]),
                        child: const ListTile(
                          isThreeLine: true,
                          leading: CircleAvatar(
                            radius: 25,
                            child: Text("A"),
                          ),
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Mr.JohnWaiYan",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ]),
                          subtitle: Text(
                            "Please make the presentati friday,the next meeting agenda will bebased onn it",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                "2hr",
                                style:
                                    TextStyle(fontSize: 10, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[400],
                          // indent: size.width * .08,
                          // endIndent: size.width * .08,
                        ),
                    itemCount: 30))
          ],
        ),
      ),
    );
  }
}
