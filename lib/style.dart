import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  ThemeData textTheme(BuildContext context) => ThemeData(
        textTheme:
            GoogleFonts.plusJakartaSansTextTheme(Theme.of(context).textTheme),
      );
}
