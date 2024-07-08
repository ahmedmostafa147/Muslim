import 'package:flutter/material.dart';
import 'package:muslim/Core/constant/images.dart';

class Basmallah extends StatefulWidget {
  const Basmallah({
    super.key,
  });

  @override
  State<Basmallah> createState() => _BasmallahState();
}

class _BasmallahState extends State<Basmallah> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      child: Padding(
        padding: EdgeInsets.only(
            left: (screenSize.width * .2),
            right: (screenSize.width * .2),
            top: 8,
            bottom: 2),
        child: Image.asset(
          Assets.imagesBasmala,
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width * .4,
        ),
      ),
    );
  }
}
