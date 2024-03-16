
import 'notification_service.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void zekr() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await NotificationService.zekr();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}


