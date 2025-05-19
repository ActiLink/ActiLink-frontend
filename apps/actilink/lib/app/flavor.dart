/// Represents different app environments/flavors
enum Flavor {
  development,
  staging,
  production,
}

/// The current flavor of the app
/// Defaults to production for safety
Flavor currentFlavor = Flavor.production;

/// Initializes the app with the specified flavor
void initFlavor(Flavor flavor) {
  currentFlavor = flavor;
}
