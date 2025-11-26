// Example: In a settings screen or an AppBar action
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ThemeSwitcherWidget extends StatelessWidget {
  const ThemeSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(AdaptiveTheme.of(context).mode.isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () {
        if (AdaptiveTheme.of(context).mode.isDark) {
          AdaptiveTheme.of(context).setLight();
        } else {
          AdaptiveTheme.of(context).setDark();
        }
      },
      tooltip: AdaptiveTheme.of(context).mode.isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
    );
  }
}

// Or, for more options (Light, Dark, System):
class FullThemeOptionsWidget extends StatelessWidget {
  const FullThemeOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AdaptiveThemeMode>(
      onSelected: (mode) => AdaptiveTheme.of(context).setThemeMode(mode),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: AdaptiveThemeMode.light,
          child: Text('Light'),
        ),
        const PopupMenuItem(
          value: AdaptiveThemeMode.dark,
          child: Text('Dark'),
        ),
        const PopupMenuItem(
          value: AdaptiveThemeMode.system,
          child: Text('System Default'),
        ),
      ],
      icon: const Icon(Icons.brightness_6), // Or any icon you prefer
      tooltip: 'Change Theme',
    );
  }
}

// IconButton(
// icon: Icon(
// // Check the current brightness of the effective theme
// // AdaptiveTheme.of(context).mode is the saved preference (light, dark, system)
// // AdaptiveTheme.of(context).theme.brightness gives the actual current brightness
// AdaptiveTheme.of(context).theme.brightness == Brightness.dark
// ? Icons.light_mode // If dark, show icon to switch to light
//     : Icons.dark_mode, // If light, show icon to switch to dark
// color: Theme.of(context).appBarTheme.foregroundColor ?? // Use AppBar's icon color
// (AdaptiveTheme.of(context).theme.brightness == Brightness.dark ? Colors.white : Colors.black),
// ),
// tooltip: AdaptiveTheme.of(context).theme.brightness == Brightness.dark
// ? 'Switch to Light Theme'
//     : 'Switch to Dark Theme',
// onPressed: () {
// // Get the current effective brightness
// final currentBrightness = AdaptiveTheme.of(context).theme.brightness;
//
// if (currentBrightness == Brightness.dark) {
// // If current theme is dark, switch to light mode
// AdaptiveTheme.of(context).setLight();
// } else {
// // If current theme is light, switch to dark mode
// AdaptiveTheme.of(context).setDark();
// }
// },
// );
