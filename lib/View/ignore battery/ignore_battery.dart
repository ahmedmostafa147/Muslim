import 'package:flutter/material.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';

class IgnoreBattery extends StatefulWidget {
  const IgnoreBattery({Key? key}) : super(key: key);

  @override
  _IgnoreBatteryState createState() => _IgnoreBatteryState();
}

class _IgnoreBatteryState extends State<IgnoreBattery> {
  bool isBatteryOptimizationDisabled = false;

  @override
  void initState() {
    super.initState();
    checkBatteryOptimization();
  }

  Future<void> checkBatteryOptimization() async {
    bool? isOptimizationDisabled =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    setState(() {
      isBatteryOptimizationDisabled = !isOptimizationDisabled!;
    });
  }

  void showBatteryOptimizationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تنبيه"),
          content: Text(
              "لتشغيل التطبيق بشكل صحيح، يجب تعطيل تحسينات البطارية. يرجى الانتقال إلى إعدادات الهاتف وتعطيل تحسينات البطارية لتطبيقنا."),
          actions: <Widget>[
            TextButton(
              child: Text("فتح الإعدادات"),
              onPressed: () {
                DisableBatteryOptimization.showDisableAllOptimizationsSettings(
                    "تحسينات البطارية",
                    "اتبع الخطوات التالية لتعطيل تحسينات البطارية لتطبيقنا:",
                    "Your device has additional battery optimization",
                    "Follow the steps and disable the optimizations to allow smooth functioning of this app");
              },
            ),
            TextButton(
              child: Text("إغلاق"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          isBatteryOptimizationDisabled
              ? ElevatedButton(
                  child: Text("تعطيل تحسينات البطارية"),
                  onPressed: () {
                    showBatteryOptimizationDialog();
                  },
                )
              : ElevatedButton(
                  child: Text("فحص تحسينات البطارية"),
                  onPressed: () async {
                    await checkBatteryOptimization();
                  },
                ),
        ],
      ),
    );
  }
}
