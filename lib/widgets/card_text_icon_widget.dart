
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardTextIconWidget extends StatelessWidget {
  const CardTextIconWidget({super.key, required this.text, required this.icon,required this.onTap});
  final String text;
  final String icon;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0XFFD4A331)
            : Colors.teal,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 22.sp,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 30.r,
                backgroundColor: const Color.fromARGB(39, 44, 43, 43),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ImageIcon(AssetImage(icon),
                        size: 30.r, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
