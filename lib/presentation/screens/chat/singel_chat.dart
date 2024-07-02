import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SingleChat extends StatelessWidget {
  const SingleChat({super.key});

  @override
  Widget build(BuildContext context) {
    String userName = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //       StarlightUtils.pop();
        //     },
        //     icon: const Icon(Icons.chevron_left)),
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
            Text(
              userName,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
      body: ListView(),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
        child: Container(
          height: MediaQuery.of(context).size.height * .07,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromRGBO(221, 225, 228, 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: "type something", border: InputBorder.none),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.image_outlined,
                    size: 30,
                    color: Color.fromARGB(255, 39, 126, 197),
                  ),
                ),
                const Icon(
                  Icons.send,
                  color: Color.fromARGB(255, 39, 126, 197),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
