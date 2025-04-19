import 'package:flutter/material.dart';

class Chooseplan extends StatefulWidget {
  const Chooseplan({super.key});

  @override
  State<Chooseplan> createState() => _ChooseplanState();
}

class _ChooseplanState extends State<Chooseplan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(60), child: getAppBar()),

    body: Column(
      children: [
          const Text("Choose Plans",
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),),
        const Text("Unlock all features with premium Plan",
          style: TextStyle(
            fontSize: 22,
            color: Colors.grey,
          ),),

      ],
    ),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(onPressed: () {}, icon: Icon(
        Icons.arrow_back_ios_new,color: Colors.black,size: 22,)),
      title: Text("Choose PLan",
      style: TextStyle(
        fontSize: 18,
        color: Colors.black
      ),),
    );
  }
}
