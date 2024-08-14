import 'package:blog_app/presentation/routes/route_import.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:velocity_x/velocity_x.dart';

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
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color.fromARGB(255, 13, 146, 69).withOpacity(0.5),
        automaticallyImplyLeading: false,
        leading: const IconButton(
            onPressed: (StarlightUtils.pop),
            icon: Icon(Icons.chevron_left_outlined)),
        title: const Text("Admin DashBoard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .25,
                    child: InkWell(
                      onTap: () {
                        StarlightUtils.pushNamed(RouteNames.readPosts);
                      },
                      child: Card(
                        elevation: 3,
                        shadowColor: const Color.fromARGB(255, 13, 146, 69)
                            .withOpacity(0.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.storage_outlined),
                            const Text("Posts").centered(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .25,
                    child: InkWell(
                      onTap: () {
                        StarlightUtils.pushNamed(RouteNames.readCategories);
                      },
                      child: Card(
                        elevation: 3,
                        shadowColor: const Color.fromARGB(255, 13, 146, 69)
                            .withOpacity(0.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.category_outlined),
                            const Text("Categories").centered(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .25,
              child: InkWell(
                onTap: () {
                  StarlightUtils.pushNamed(RouteNames.readUsers);
                },
                child: Card(
                  elevation: 3,
                  shadowColor:
                      const Color.fromARGB(255, 13, 146, 69).withOpacity(0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_outline_outlined),
                      const Text("Users").centered(),
                    ],
                  ),
                ),
              ),
            ),
            // Expanded(
            //   child: PieChart(
            //     PieChartData(
            //       pieTouchData: PieTouchData(
            //         touchCallback: (FlTouchEvent event, pieTouchResponse) {
            //           setState(() {
            //             if (!event.isInterestedForInteractions ||
            //                 pieTouchResponse == null ||
            //                 pieTouchResponse.touchedSection == null) {
            //               touchedIndex = -1;
            //               return;
            //             }
            //             touchedIndex = pieTouchResponse
            //                 .touchedSection!.touchedSectionIndex;
            //           });
            //         },
            //       ),
            //       borderData: FlBorderData(
            //         show: false,
            //       ),
            //       sectionsSpace: 0,
            //       centerSpaceRadius: 40,
            //       sections: showingSections(),
            //     ),
            //   ),
            // ),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     Indicator(
            //       color: Colors.blue,
            //       text: 'First',
            //       isSquare: true,
            //     ),
            //     SizedBox(
            //       height: 4,
            //     ),
            //     Indicator(
            //       color: Colors.yellow,
            //       text: 'Second',
            //       isSquare: true,
            //     ),
            //     SizedBox(
            //       height: 4,
            //     ),
            //     Indicator(
            //       color: Colors.purple,
            //       text: 'Third',
            //       isSquare: true,
            //     ),
            //     SizedBox(
            //       height: 4,
            //     ),
            //     Indicator(
            //       color: Colors.green,
            //       text: 'Fourth',
            //       isSquare: true,
            //     ),
            //     SizedBox(
            //       height: 18,
            //     ),
            //   ],
            // ),
          ],
        ),
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
