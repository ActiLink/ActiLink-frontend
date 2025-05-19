import 'dart:io';

import 'package:actilink/app/app.dart';
import 'package:actilink/app/flavor.dart';
import 'package:actilink/bootstrap.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  initFlavor(Flavor.development);
  bootstrap(() => const App());
}
