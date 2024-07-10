import 'package:muslim/Core/constant/themes.dart';import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Models/reader_load_data.dart';

class ReaderCustomTile extends StatefulWidget {
  const ReaderCustomTile({super.key, required this.reader, required this.onTap});

  final Reader reader;
  final VoidCallback onTap;

  @override
  State<ReaderCustomTile> createState() => _ReaderCustomTileState();
}

class _ReaderCustomTileState extends State<ReaderCustomTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.reader.arabicName != null) {
      return GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color:Theme.of(context).primaryColor,
                      width: 1.5),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Text(
                              widget.reader.arabicName ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      onTap: widget.onTap,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            widget.reader.name ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Theme.of(context).primaryColor,
                              fontFamily: TextFontType.notoNastaliqUrduFont,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
