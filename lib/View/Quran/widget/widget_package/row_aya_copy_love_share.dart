import 'package:Muslim/Core/constant/doe_verser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class RowAyaCopyShareShare extends StatelessWidget {
  final String surahName;
  final String verseNumber;
  final String verseText;

  const RowAyaCopyShareShare({
    super.key,
    required this.surahName,
    required this.verseNumber,
    required this.verseText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.teal, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("نسخ"),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: verseText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("تم نسخ الآية"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0XFFD4A331)
                      : Colors.teal,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("شارك"),
                IconButton(
                  onPressed: () {
                    Share.share("$verseText\n$surahName, الآية $verseNumber");
                  },
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

class RowDoaCopyShareShare extends StatelessWidget {
  final String doaText;

  const RowDoaCopyShareShare({super.key, required this.doaText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.teal, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("نسخ"),
                IconButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: doaText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("تم نسخ الدعاء"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0XFFD4A331)
                      : Colors.teal,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("شارك"),
                IconButton(
                  onPressed: () async {
                    await Share.share(doaText);
                  },
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
