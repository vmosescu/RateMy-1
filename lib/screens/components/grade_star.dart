import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GradeStar extends StatelessWidget {
  const GradeStar({super.key, required this.grade, required this.width});

  final double grade;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (grade > 0) {
      return SizedBox(
        width: width,
        height: width,
        child: Stack(
          children: [
            SvgPicture.asset(
                width: width,
                height: width,
                'assets/grade_v3.svg'
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(grade.toString(), style: const TextStyle(color: Color.fromARGB(
                    255, 80, 80, 80), fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}