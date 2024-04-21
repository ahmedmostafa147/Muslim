import 'package:flutter/material.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text("الانتقال إلي العلامة"),
            leading: const Icon(Icons.bookmark),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("الوضع الليلي"),
            leading: const Icon(Icons.dark_mode),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("عن المطور"),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("تواصل معنا"),
            leading: const Icon(Icons.contact_mail),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("مشاركة التطبيق"),
            leading: const Icon(Icons.share),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("التقييم"),
            leading: const Icon(Icons.star),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("عن التطبيق"),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
