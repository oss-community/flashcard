import 'package:flutter/widgets.dart';

/// True on a narrow screen such as a phone: navigation moves to the bottom
/// and screens use a compact layout.
bool isCompact(BuildContext context) => MediaQuery.sizeOf(context).width < 640;
