import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  const LoadingWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.waveDots(
        size: 25.h,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
