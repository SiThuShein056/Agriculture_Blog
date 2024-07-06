import 'package:flutter/material.dart';

class CircleProfile extends StatelessWidget {
  final String name;
  final double radius;
  const CircleProfile({
    super.key,
    // this.url,
    this.name = "A",
    this.radius = 17,
  })
  // : assert((name == null && (url != null || url != "")) ||
  //           (name != null && (url == null || url == "")))
  ;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      // backgroundImage: (url != null || url != "") ? NetworkImage(url!) : null,
      child:
          // name == null
          //     ? const SizedBox()
          //     :
          Text(
        // name ?? "NA",
        name,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
