import 'package:blog_app/data/datasources/remote/db_crud_service/firebase_store_db.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/data/models/user_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

import 'message_card.dart';

class SingleChat extends StatelessWidget {
  const SingleChat({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel user = ModalRoute.of(context)!.settings.arguments as UserModel;
    TextEditingController textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  StarlightUtils.pop();
                },
                icon: const Icon(Icons.chevron_left)),
            const CircleAvatar(
              radius: 20,
              child: Text("NA"),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const Text(
                  "Unable last online time",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(children: [
        Expanded(
            child: StreamBuilder(
                stream: FirebaseStoreDb().getAllMessages(user),
                builder: (_, snap) {
                  switch (snap.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snap.data == null) {
                        return const Center(
                          child: Text("Data is null value"),
                        );
                      } else {
                        final data = snap.data!.docs;
                        List<MessageModel> messages = [];

                        messages = data.map((e) {
                          return MessageModel.fromJson(e.data());
                        }).toList();

                        if (messages.isEmpty) {
                          return const Center(
                            child: Text("Say hi 👋"),
                          );
                        }

                        return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (_, index) {
                              return MessageCard(message: messages[index]);
                            });
                      }
                  }
                })),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: MediaQuery.of(context).size.height * 0.01),
          child: Row(
            children: [
              Expanded(
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.emoji_emotions_outlined),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                              hintText: "Type Here", border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.link_outlined),
                      ),
                    ])),
              ),
              MaterialButton(
                minWidth: 0,
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 10, right: 5),
                shape: const CircleBorder(),
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    FirebaseStoreDb().sendMessage(user, textController.text);
                    textController.text = "";
                  }
                },
                color: const Color.fromARGB(255, 39, 126, 197),
                child: const Icon(Icons.send_outlined),
              ),
            ],
          ),
        )
      ]),
      // bottomSheet: Padding(
      //   padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
      //   child: Container(
      //     height: MediaQuery.of(context).size.height * .07,
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(20),
      //         color: const Color.fromRGBO(221, 225, 228, 1),
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey.withOpacity(0.5),
      //             spreadRadius: 2,
      //             offset: const Offset(0, 3),
      //           )
      //         ]),
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //       child: Row(
      //         children: [
      //           Expanded(
      //             child: TextFormField(
      //               maxLines: 3,
      //               minLines: 1,
      //               decoration: const InputDecoration(
      //                   hintText: "type something", border: InputBorder.none),
      //             ),
      //           ),
      //           const Padding(
      //             padding: EdgeInsets.symmetric(horizontal: 8.0),
      //             child: Icon(
      //               Icons.image_outlined,
      //               size: 30,
      //               color: Color.fromARGB(255, 39, 126, 197),
      //             ),
      //           ),
      //           const Icon(
      //             Icons.send,
      //             color: Color.fromARGB(255, 39, 126, 197),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
