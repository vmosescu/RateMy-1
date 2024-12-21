import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ratemy/screens/presentation/feed_presentation.dart';

class RateButton extends StatefulWidget {
  const RateButton({super.key, required this.presentation, required this.saveGrade, required this.width, this.userRating = 0, });

  final FeedPresentation presentation;
  final Function(int) saveGrade;
  final double width;
  final int userRating;

  @override
  State<RateButton> createState() => _RateButtonState();
}

class _RateButtonState extends State<RateButton> {
  final GlobalKey _rateContainerKey = GlobalKey();
  bool showGrades = false;
  int selectedGrade = 0;

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () {
        setState(() {
          showGrades = false;
        });
      },
      onVerticalDragStart: (details) {
        setState(() {
          showGrades = true;
        });
      },
      onVerticalDragEnd: (details) {
        setState(() {
          widget.saveGrade(selectedGrade);
          showGrades = false;
          selectedGrade = 0;
        });
      },
      onVerticalDragUpdate: (details) {
        // final renderBox = _rateContainerKey.currentContext!.findRenderObject() as RenderBox;
        //
        // log('Cursor Y=${details.localPosition.dy} in box height ${renderBox.size.height}', name: 'RATE BAR');

        setState(() {
          selectedGrade = 0;
        });

        if (details.localPosition.dy < -35 ) {
          setState(() {
            selectedGrade = 1;
          });
        }

        if (details.localPosition.dy < -1 * (2 * widget.width - widget.width * 0.2) ) {
          setState(() {
            selectedGrade = 2;
          });
        }

        if (details.localPosition.dy < -1 * (3 * widget.width) ) {
          setState(() {
            selectedGrade = 3;
          });
        }

        if (details.localPosition.dy < -1 * (4 * widget.width)  ) { // 240
          setState(() {
            selectedGrade = 4;
          });
        }

        if (details.localPosition.dy < -1 * (5 * widget.width + 20) ) {
          setState(() {
            selectedGrade = 5;
          });
        }
      },
      child: Container(
        key: _rateContainerKey,
        decoration: const BoxDecoration(
          color: Color.fromARGB(152, 120, 120, 120), // Background color of the column
          borderRadius: BorderRadius.all(Radius.circular(70)),
        ),
        child: Column(
          children: [
            _grades(widget.width),
            _rateBtn(),
          ],
        ),
      ),
    );
  }

  Widget _grades(double width) {
    const double margin = 10;

    if (showGrades) {
      return Column(
        children: [
          _grade(5, selectedGrade >= 5, width),
          const SizedBox(height: margin,),
          _grade(4, selectedGrade >= 4, width),
          const SizedBox(height: margin,),
          _grade(3, selectedGrade >= 3, width),
          const SizedBox(height: margin,),
          _grade(2, selectedGrade >= 2, width),
          const SizedBox(height: margin,),
          _grade(1, selectedGrade >= 1, width),
          const SizedBox(height: margin,),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  _grade(int no, bool selected, double widgetWidth) {
    return Container(
      height: widgetWidth,
      width: widgetWidth,
      decoration: BoxDecoration(
        color: selected ? Colors.green : const Color.fromARGB(255, 225, 225, 225), // Background color of the container
        shape: BoxShape.circle, // Makes the container circular
      ),
      child: Center(child: Text(no.toString(), style: const TextStyle(fontSize: 20, color: Colors.black),)),
    );
  }

  Widget _rateBtn() {
    if (widget.userRating > 0) {
      return Container(
        width: widget.width,
        height: widget.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
            child: Text(widget.userRating.toString(), style: widget.presentation.rateBtnStyle)),
      );
    } else {
      return SvgPicture.asset(
          width: widget.width,
          'assets/rate_btn.svg'
      );
    }
  }
}