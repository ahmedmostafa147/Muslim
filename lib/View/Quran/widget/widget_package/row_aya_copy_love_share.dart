import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowAyaCopyShareShare extends StatelessWidget {
  const RowAyaCopyShareShare({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(8.0.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.teal, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding:  EdgeInsets.symmetric(horizontal: 30.w, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.white, width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("نسخ"),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.copy),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0XFFD4A331)
                      : Colors.teal,
                ),
              ],
            ),
          ),
          Container(
            padding:  EdgeInsets.symmetric(horizontal: 30.w, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.white, width: 1.0),
            ),
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("شارك"),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0XFFD4A331)
                      : Colors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
