import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TitleRow extends StatelessWidget {
  final Function() backAction;
  final String title;

  const TitleRow({super.key, required this.backAction, required this.title});


  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        GestureDetector(
          onTap: () {
            backAction();
          },
          child: SvgPicture.asset(
              height: 50,
              'assets/back-arrow.svg'
          ),
        ),

        Expanded(child: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,)
        ),

        // This is to make the title centered. Has the same with as the back arrow
        const SizedBox(width: 50,)
      ],
    );
  }

}
