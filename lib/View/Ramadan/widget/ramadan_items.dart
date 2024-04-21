import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Core/constant/style.dart';

class RamadanItems extends StatelessWidget {
  final String number;
  final String label;

  const RamadanItems({
    super.key,
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          number,
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: TextFontType.arefRuqaaFont,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? ColorsStyleApp.darkBackground
                  : ColorsStyleApp.lightBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: TextFontType.arefRuqaaFont,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
