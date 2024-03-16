import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class DateRowClass extends StatefulWidget {
  const DateRowClass({super.key});

  @override
  State<DateRowClass> createState() => _DateRowClassState();
}

class _DateRowClassState extends State<DateRowClass> {
  var formattedDate = DateFormat('hh:mm a').format(DateTime.now());
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        formattedDate = DateFormat('hh:mm ,  a').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HijriCalendar.setLocal('ar');
    var hijri = HijriCalendar.now();
    var day = DateTime.now();
    var format = DateFormat(' d MMM yyyy', "ar");
    var formatted = format.format(day);
    var forrmmat = DateFormat('hh:mm EEE', 'ar');
    var formattedDate = forrmmat.format(DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          hijri.toFormat(
            "dd MMMM yyyy",
          ),
          style: TextStyle(
            fontSize: 15.sp,
          ),
        ),
        Text(
          formattedDate,
          style: TextStyle(
            fontSize: 15.sp,
          ),
        ),
        Text(
          formatted,
          style: TextStyle(
            fontSize: 15.sp,
          ),
        )
      ],
    );
  }
}
