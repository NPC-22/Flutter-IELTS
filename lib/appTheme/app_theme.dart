import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData buildLightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      brightness: Brightness.light,
      primaryColor: Color(0xFFe93e33),
      textTheme: TextTheme(
        displayLarge:
            TextStyle(fontFamily: 'UberMove', fontWeight: FontWeight.w400),
        displayMedium:
            TextStyle(fontFamily: 'UberMove', fontWeight: FontWeight.w700),
        displaySmall:
            TextStyle(fontFamily: 'UberMove', fontWeight: FontWeight.w400),
        headlineLarge:
            TextStyle(fontFamily: 'UberMove', fontWeight: FontWeight.w400),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blue; // Fill color when checked in light mode
          }
          return Colors.grey; // Fill color when unchecked in light mode
        }),
        side: BorderSide(
          width: 2,
          color: Colors.grey,
        ),
      ),
    );
  }

  static ThemeData buildDarkTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      brightness: Brightness.dark,
      primaryColor: Color(0xFFe93e33),
      textTheme: TextTheme(
        displayLarge:
            TextStyle(fontFamily: 'UberMove', fontWeight: FontWeight.w400),
        displayMedium:
            TextStyle(fontFamily: 'UberMove', fontWeight: FontWeight.w700),
        displaySmall:
            TextStyle(fontFamily: 'UberMove', fontWeight: FontWeight.w400),
        headlineLarge:
            TextStyle(fontFamily: 'UberMove', fontWeight: FontWeight.w400),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.orange; // Fill color when checked in dark mode
          }
          return Colors.grey[700]!; // Fill color when unchecked in dark mode
        }),
        side: BorderSide(
          width: 2,
          color: Colors.grey,
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData buildLightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      brightness: Brightness.light,
      primaryColor: Color(0xFFe93e33),
      textTheme: TextTheme(
        headline6: GoogleFonts.workSans(),
        headline1: GoogleFonts.workSans(),
        bodyText1: GoogleFonts.gabriela(),
        bodyText2: GoogleFonts.gabriela(),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blue; // Fill color when checked in light mode
          }
          return Colors.grey; // Fill color when unchecked in light mode
        }),
        side: BorderSide(
          width: 2,
          color: Colors.grey
        )
      ),
    );
  }

  static ThemeData buildDarkTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(

      brightness: Brightness.dark,
      primaryColor: Color(0xFFe93e33),
      textTheme: TextTheme(
        headline6: GoogleFonts.workSans(),
        headline1: GoogleFonts.workSans(),
        bodyText1: GoogleFonts.gabriela(),
        bodyText2: GoogleFonts.gabriela(),

      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.orange; // Fill color when checked in dark mode
          }
          return Colors.grey[700]!; // Fill color when unchecked in dark mode
        }),

          side: BorderSide(
              width: 2,
              color: Colors.grey
          )
      ),
    );
  }
}

 */
