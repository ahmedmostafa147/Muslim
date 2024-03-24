import '../../../Core/constant/images.dart';
import '../../../widgets/card_text_icon_widget.dart';
import 'package:flutter/material.dart';

class AzkarSalahCard extends StatelessWidget {
  const AzkarSalahCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardTextIconWidget(
      onTap: () {
        
      },
      text: "أذكار الصلاة",
      icon: Assets.images14703159,
    );
  }
}
