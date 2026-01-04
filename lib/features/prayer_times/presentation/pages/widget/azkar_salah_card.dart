import 'package:muslim/core/constants/images.dart';


import 'package:flutter/material.dart';

class AzkarSalahCard extends StatelessWidget {
  const AzkarSalahCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardTextIconWidget(
      onTap: () {},
      text: "أذكار الصلاة",
      icon: Assets.imagesRadio,
    );
  }
}
