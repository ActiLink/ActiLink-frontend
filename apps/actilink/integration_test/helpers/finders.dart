import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

// Finder for AppTextField by its label string
Finder findAppTextFieldByLabel(String label) {
  return find.byWidgetPredicate(
    (widget) => widget is AppTextField && widget.label == label,
  );
}
