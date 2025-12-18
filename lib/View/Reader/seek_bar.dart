import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Core/constant/themes.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;

  const SeekBar({
    super.key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 7),
          ),
          child: Slider(
            thumbColor: Theme.of(context).primaryColor,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Theme.of(context).dividerColor,
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _positionText,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: TextFontType.notoNastaliqUrduFont,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                _durationText,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: TextFontType.notoNastaliqUrduFont,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String get _durationText =>
      "${widget.duration.inHours.toString().padLeft(2, '0')}"
      ":${widget.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}"
      ":${widget.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";

  String get _positionText =>
      "${widget.position.inHours.toString().padLeft(2, '0')}"
      ":${widget.position.inMinutes.remainder(60).toString().padLeft(2, '0')}"
      ":${widget.position.inSeconds.remainder(60).toString().padLeft(2, '0')}";
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0.h,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0.sp)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
