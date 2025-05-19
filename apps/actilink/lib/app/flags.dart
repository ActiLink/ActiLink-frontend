import 'package:actilink/app/flavor.dart';

/// A constant that is true if the application is running in development mode.
///
/// This can be used to conditionally execute code
/// only when the application is running in development environment.
bool get kIsDev => currentFlavor == Flavor.development;
