import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  final String buttonText;
  final Color color;
  final double height;
  final VoidCallback onPressed;

  const CustomMaterialButton({
    super.key,
    required this.buttonText,
    required this.color,
    required this.height,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(buttonText),
      ),
    );
  }
}
