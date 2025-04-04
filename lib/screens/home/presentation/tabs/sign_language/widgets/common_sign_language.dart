import 'package:flutter/material.dart';

class CommonSignLanguage extends StatefulWidget {
  const CommonSignLanguage({super.key});

  @override
  State<CommonSignLanguage> createState() => _CommonSignLanguageState();
}

class _CommonSignLanguageState extends State<CommonSignLanguage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Common Sign Language", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),

        const SizedBox(height: 10),

        Row(children: [

          Expanded(child: Column(
            children: [
              Image.asset("assets/images/everything_is_fine.png"),
              const SizedBox(height: 5,),
              Text("Everything is fine", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          )),

          const SizedBox(width: 10),

          Expanded(child: Column(
            children: [
              Image.asset("assets/images/I_dont_know.png"),
              const SizedBox(height: 5,),
              Text("I don't know", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ))

        ]),

        const SizedBox(height: 20),

        Row(children: [
          Expanded(child: Column(
            children: [
              Image.asset("assets/images/all_is_good.png"),
              const SizedBox(height: 5,),
              Text("All is good", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          )),

          const SizedBox(width: 10),

          Expanded(child: Column(
            children: [
              Image.asset("assets/images/point_of_objection.png"),
              const SizedBox(height: 5,),
              Text("Point of Objection", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ))
        ]),
      ],
    );
  }
}
