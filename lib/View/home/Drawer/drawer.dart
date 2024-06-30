import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              Navigator.pop(context);
            },
          )),
          const Divider(),
          DrawerRow(
              title: ListTile(
            title: const Text("المفضلة"),
            leading: const Icon(Icons.favorite),
            onTap: () {
              Navigator.pop(context);
            },
          )),
          const Divider(),
          DrawerRow(
            title: ListTile(
              title: const Text("الوضع الليلي"),
              leading: const Icon(Icons.dark_mode),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Divider(),
          DrawerRow(
            title: ListTile(
              title: const Text("عن المطور"),
              leading: const Icon(Icons.info),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Divider(),
          DrawerRow(
              title: ListTile(
            title: const Text("تواصل معنا"),
            leading: const Icon(Icons.contact_mail),
            onTap: () {
              Navigator.pop(context);
            },
          )),
          const Divider(),
          DrawerRow(
            title: ListTile(
              title: const Text("مشاركة التطبيق"),
              leading: const Icon(Icons.share),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Divider(),
          DrawerRow(
            title: ListTile(
              title: const Text("التقييم"),
              leading: const Icon(Icons.star),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Divider(),
          DrawerRow(
              title: ListTile(
            title: const Text("عن التطبيق"),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.pop(context);
            },
          ))
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
