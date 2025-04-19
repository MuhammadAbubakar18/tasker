import 'package:flutter/material.dart';
import 'package:tasker_by_team_dsa/Dashboard/dashboard.dart';

class ChoosePlan extends StatefulWidget {
  const ChoosePlan({Key? key}) : super(key: key);

  @override
  State<ChoosePlan> createState() => _ChoosePlanState();
}

class _ChoosePlanState extends State<ChoosePlan> {
  bool isselected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: getAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Choose Plans",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Unlock all features with a premium Plan",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlanCard(
                  planName: "It's free",
                  price: "For Team \n from 1-5\n members",
                  icon: "🥳",
                ),
                SizedBox(width: 6),
                PlanCard(
                  planName: "It's Premium",
                  price: "For Team \n from 1-10\n members",
                  icon: "💎",
                ),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardScreen()), // Navigate to LoginScreen
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [


                      Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 22,
        ),
      ),
      title: const Text(
        "Choose Plan", // Corrected the typo
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      centerTitle: true,
    );
  }
}

class PlanCard extends StatelessWidget {
  final String planName;
  final String price;
  final String icon;

  const PlanCard({
    Key? key,
    required this.planName,
    required this.price,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width*0.45,
      height: 210,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:  Color(0xFFFAF6F3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8), // Increased space
          Text(
            planName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8), // Increased space
          Text(
            price,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

        ],
      ),
    );
  }
}
