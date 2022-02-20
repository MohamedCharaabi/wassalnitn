import 'package:permission_handler/permission_handler.dart';

void locationPermissionHandler() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    print('done');
  } else if (status.isDenied) {
    locationPermissionHandler();
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}
