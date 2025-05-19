import 'package:flutter/services.dart';

/// Represents different app environments/flavors
enum Flavor {
  development,
  staging,
  production,
}

/// The current flavor of the app
/// Sketchy way because dart has very limited
/// support for compile-time constants.
const Flavor? currentFlavor = appFlavor == null
    ? null
    : appFlavor == 'development'
        ? Flavor.development
        : appFlavor == 'staging'
            ? Flavor.staging
            : appFlavor == 'production'
                ? Flavor.production
                : null;
