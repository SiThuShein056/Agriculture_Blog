import 'package:blog_app/data/datasources/remote/auth_services/authu_service_import.dart';
import 'package:blog_app/data/models/message_model/message_model.dart';
import 'package:blog_app/injection.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Injection<AuthService>().currentUser!.uid == message.fromId
        ? _greenMessage(context)
        : _blueMessage(context);
  }

  Widget _blueMessage(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * .04),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .04,
                vertical: MediaQuery.of(context).size.height * .01,
              ),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 109, 115, 218),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )),
              child: Text(
                message.message,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(right: MediaQuery.of(context).size.width * .04),
            child: const Text(
              "12:PM",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          )
        ],
      );
  Widget _greenMessage(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .04),
                child: const Icon(
                  Icons.done_all_rounded,
                  color: Color.fromARGB(255, 178, 240, 180),
                ),
              ),
              const Text(
                "12:PM",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * .04),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .04,
                vertical: MediaQuery.of(context).size.height * .01,
              ),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 95, 226, 132),
                  border: Border.all(color: Colors.lightGreen),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )),
              child: Text(
                message.message,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      );
}
