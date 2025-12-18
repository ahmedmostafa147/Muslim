import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Quran/favourit_bookmark/bookmark.dart';
import '../../Quran/favourit_bookmark/fav.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 15.w),
        children: [
          DrawerRow(
              title: ListTile(
            title: const Text("الانتقال إلي العلامة"),
            leading: const Icon(Icons.bookmark),
            onTap: () {
              Get.to(
                () => const BookmarkListScreen(),
              );
            },
          )),
          const Divider(),
          DrawerRow(
              title: ListTile(
            title: const Text("المفضلة"),
            leading: const Icon(Icons.favorite),
            onTap: () {
              Get.to(
                () => const FavoriteListScreen(),
              );
            },
          )),
          const Divider(),
          DrawerRow(
              title: ListTile(
            title: const Text("تغير الوضع"),
            leading: Get.isDarkMode
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light_mode),
            onTap: () {
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          )),
          // const Divider(),
          // DrawerRow(
          //   title: ListTile(
          //     title: const Text("عن المطور"),
          //     leading: const Icon(Icons.info),
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //   ),
          // ),
          // const Divider(),
          // DrawerRow(
          //     title: ListTile(
          //   title: const Text("تواصل معنا"),
          //   leading: const Icon(Icons.contact_mail),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // )),
          // const Divider(),
          // DrawerRow(
          //   title: ListTile(
          //     title: const Text("مشاركة التطبيق"),
          //     leading: const Icon(Icons.share),
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //   ),
          // ),
          // const Divider(),
          // DrawerRow(
          //   title: ListTile(
          //     title: const Text("التقييم"),
          //     leading: const Icon(Icons.star),
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //   ),
          // ),
          // const Divider(),
          // DrawerRow(
          //     title: ListTile(
          //   title: const Text("عن التطبيق"),
          //   leading: const Icon(Icons.info),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ))
        ],
      ),
    );
  }
}

class DrawerRow extends StatelessWidget {
  const DrawerRow({super.key, required this.title});
  final ListTile title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: title),
          const Icon(Icons.arrow_forward_ios),

          // Wrap title with Expanded
        ],
      ),
    );
  }
}
