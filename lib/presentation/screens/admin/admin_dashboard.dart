import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              child: Image.asset(
                "assets/images/bg10.jpg",
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 35,
            left: 10,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    StarlightUtils.pop();
                  },
                  icon: const Icon(Icons.chevron_left_outlined),
                ),
                const Text(
                  "Admin Dashboard",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            ),
          ),

          Positioned(
              top: 100,
              left: 10,
              right: 10,
              bottom: 10,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .25,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(2, 1),
                              blurRadius: 2,
                              color: Color.fromARGB(255, 47, 113, 37),
                            )
                          ],
                          gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 197, 246, 190),
                                Color.fromARGB(255, 173, 239, 163),
                                Color.fromARGB(255, 89, 196, 65),
                              ])),
                      child: InkWell(
                        onTap: () {
                          StarlightUtils.pushNamed(RouteNames.readUsers);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.read_more_outlined,
                                      color: Color.fromARGB(255, 36, 158, 61),
                                    ),
                                  ),
                                ),
                              ),
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CircleAvatar(
                                    radius: 80,
                                    backgroundImage:
                                        AssetImage("assets/images/users.png"),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Users",
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.width * .5,
                            // width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(2, 1),
                                    blurRadius: 2,
                                    color: Color.fromARGB(255, 47, 113, 37),
                                  )
                                ],
                                gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color.fromARGB(255, 197, 246, 190),
                                      Color.fromARGB(255, 173, 239, 163),
                                      Color.fromARGB(255, 89, 196, 65),
                                    ])),
                            child: InkWell(
                              onTap: () {
                                StarlightUtils.pushNamed(RouteNames.readPosts);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.read_more_outlined,
                                          color:
                                              Color.fromARGB(255, 36, 158, 61),
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            "assets/images/post1.jpg"),
                                      ),
                                    ),
                                    const Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        "Posts",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.width * .5,
                            // width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(2, 1),
                                    blurRadius: 2,
                                    color: Color.fromARGB(255, 47, 113, 37),
                                  )
                                ],
                                gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color.fromARGB(255, 197, 246, 190),
                                      Color.fromARGB(255, 173, 239, 163),
                                      Color.fromARGB(255, 89, 196, 65),
                                    ])),
                            child: InkWell(
                              onTap: () {
                                StarlightUtils.pushNamed(
                                    RouteNames.readMainCategories);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.read_more_outlined,
                                          color:
                                              Color.fromARGB(255, 36, 158, 61),
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            "assets/images/category.jfif"),
                                      ),
                                    ),
                                    const Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        "Categories",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.width * .5,
                          //   child: InkWell(
                          //     onTap: () {
                          //       StarlightUtils.pushNamed(
                          //           RouteNames.readMainCategories);
                          //     },
                          //     child: Card(
                          //       elevation: 3,
                          //       shadowColor:
                          //           const Color.fromARGB(255, 13, 146, 69)
                          //               .withOpacity(0.5),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           const Icon(Icons.category_outlined),
                          //           const Text("Categories").centered(),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
          // Positioned(
          //   top: 100,
          //   bottom: 0,
          //   child: Column(
          //     children: [
          //       Row(
          //         children: [
          //           Expanded(
          //             child: SizedBox(
          //               height: MediaQuery.of(context).size.height * .25,
          //               child: InkWell(
          //                 onTap: () {
          //                   StarlightUtils.pushNamed(RouteNames.readPosts);
          //                 },
          //                 child: Card(
          //                   elevation: 3,
          //                   shadowColor: const Color.fromARGB(255, 13, 146, 69)
          //                       .withOpacity(0.5),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       const Icon(Icons.storage_outlined),
          //                       const Text("Posts").centered(),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Expanded(
          //             child: SizedBox(
          //               height: MediaQuery.of(context).size.height * .25,
          //               child: InkWell(
          //                 onTap: () {
          //                   StarlightUtils.pushNamed(
          //                       RouteNames.readMainCategories);
          //                 },
          //                 child: Card(
          //                   elevation: 3,
          //                   shadowColor: const Color.fromARGB(255, 13, 146, 69)
          //                       .withOpacity(0.5),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       const Icon(Icons.category_outlined),
          //                       const Text("Categories").centered(),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       SizedBox(
          //         height: MediaQuery.of(context).size.height * .25,
          //         child: InkWell(
          //           onTap: () {
          //             StarlightUtils.pushNamed(RouteNames.readUsers);
          //           },
          //           child: Card(
          //             elevation: 3,
          //             shadowColor: const Color.fromARGB(255, 13, 146, 69)
          //                 .withOpacity(0.5),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 const Icon(Icons.people_outline_outlined),
          //                 const Text("Users").centered(),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   int touchedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 1,
//         shadowColor: const Color.fromARGB(255, 13, 146, 69).withOpacity(0.5),
//         automaticallyImplyLeading: false,
//         leading: const IconButton(
//             onPressed: (StarlightUtils.pop),
//             icon: Icon(Icons.chevron_left_outlined)),
//         title: const Text("Admin DashBoard"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height * .25,
//                     child: InkWell(
//                       onTap: () {
//                         StarlightUtils.pushNamed(RouteNames.readPosts);
//                       },
//                       child: Card(
//                         elevation: 3,
//                         shadowColor: const Color.fromARGB(255, 13, 146, 69)
//                             .withOpacity(0.5),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.storage_outlined),
//                             const Text("Posts").centered(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height * .25,
//                     child: InkWell(
//                       onTap: () {
//                         StarlightUtils.pushNamed(RouteNames.readMainCategories);
//                       },
//                       child: Card(
//                         elevation: 3,
//                         shadowColor: const Color.fromARGB(255, 13, 146, 69)
//                             .withOpacity(0.5),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.category_outlined),
//                             const Text("Categories").centered(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * .25,
//               child: InkWell(
//                 onTap: () {
//                   StarlightUtils.pushNamed(RouteNames.readUsers);
//                 },
//                 child: Card(
//                   elevation: 3,
//                   shadowColor:
//                       const Color.fromARGB(255, 13, 146, 69).withOpacity(0.5),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.people_outline_outlined),
//                       const Text("Users").centered(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // Expanded(
//             //   child: PieChart(
//             //     PieChartData(
//             //       pieTouchData: PieTouchData(
//             //         touchCallback: (FlTouchEvent event, pieTouchResponse) {
//             //           setState(() {
//             //             if (!event.isInterestedForInteractions ||
//             //                 pieTouchResponse == null ||
//             //                 pieTouchResponse.touchedSection == null) {
//             //               touchedIndex = -1;
//             //               return;
//             //             }
//             //             touchedIndex = pieTouchResponse
//             //                 .touchedSection!.touchedSectionIndex;
//             //           });
//             //         },
//             //       ),
//             //       borderData: FlBorderData(
//             //         show: false,
//             //       ),
//             //       sectionsSpace: 0,
//             //       centerSpaceRadius: 40,
//             //       sections: showingSections(),
//             //     ),
//             //   ),
//             // ),
//             // const Row(
//             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //   crossAxisAlignment: CrossAxisAlignment.start,
//             //   children: <Widget>[
//             //     Indicator(
//             //       color: Colors.blue,
//             //       text: 'First',
//             //       isSquare: true,
//             //     ),
//             //     SizedBox(
//             //       height: 4,
//             //     ),
//             //     Indicator(
//             //       color: Colors.yellow,
//             //       text: 'Second',
//             //       isSquare: true,
//             //     ),
//             //     SizedBox(
//             //       height: 4,
//             //     ),
//             //     Indicator(
//             //       color: Colors.purple,
//             //       text: 'Third',
//             //       isSquare: true,
//             //     ),
//             //     SizedBox(
//             //       height: 4,
//             //     ),
//             //     Indicator(
//             //       color: Colors.green,
//             //       text: 'Fourth',
//             //       isSquare: true,
//             //     ),
//             //     SizedBox(
//             //       height: 18,
//             //     ),
//             //   ],
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<PieChartSectionData> showingSections() {
//     return List.generate(4, (i) {
//       final isTouched = i == touchedIndex;
//       final fontSize = isTouched ? 25.0 : 16.0;
//       final radius = isTouched ? 60.0 : 50.0;
//       const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//             color: Colors.blue,
//             value: 40,
//             title: '40%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               shadows: shadows,
//             ),
//           );
//         case 1:
//           return PieChartSectionData(
//             color: Colors.yellow,
//             value: 30,
//             title: '30%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               shadows: shadows,
//             ),
//           );
//         case 2:
//           return PieChartSectionData(
//             color: Colors.purple,
//             value: 15,
//             title: '15%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               shadows: shadows,
//             ),
//           );
//         case 3:
//           return PieChartSectionData(
//             color: Colors.green,
//             value: 15,
//             title: '15%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               shadows: shadows,
//             ),
//           );
//         default:
//           throw Error();
//       }
//     });
//   }
// }

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
