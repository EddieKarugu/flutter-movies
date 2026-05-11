import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:phanmovies/pages/navigation_page.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Web‑only imports – they are safe because they are guarded by kIsWeb
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

void main() {
  // Register custom HTML elements for web
  if (kIsWeb) {
    registerWebViewFactories();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xfff5f5f5),        // off-white
            secondary: Color(0xff00b884),      // deeper green for light mode
            tertiary: Color(0xff0088cc),
            surface: Colors.white,
            background: Color(0xfffafafa),
            error: Color(0xffb00020),
            onPrimary: Colors.black87,
            onSecondary: Colors.white,
            onSurface: Colors.black87,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xfffafafa),
        ),
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xff25e305),        // deep navy/black for app bars
            secondary: Color(0xff00e5a0),      // neon greenish accent (OnStream style)
            tertiary: Color(0xff00b8ff),       // bright blue for additional accents
            surface: Color(0xff2a2a3a),        // card background
            background: Color(0xff0f0f1a),     // main background
            error: Color(0xffcf6679),
            onPrimary: Colors.white,
            onSecondary: Colors.black,         // black text on green buttons (good contrast)
            onSurface: Colors.white70,         // secondary text
            onBackground: Colors.white,
            brightness: Brightness.dark,
          ),
          // Optional: add custom gradients or shadows
          scaffoldBackgroundColor: const Color(0xff0f0f1a),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff1e1e2f),
            elevation: 0,
          )),
      themeMode: ThemeMode.system,
      home: const NavigationPage(),
    );
  }
}

/// Registers custom HTML tags so that `HtmlElementView` can use them.
void registerWebViewFactories() {
  // Register <div-placeholder> (used in your web player)
  ui_web.platformViewRegistry.registerViewFactory(
    'div-placeholder',
        (int viewId) {
      return html.document.createElement('div-placeholder') as html.HtmlElement;
    },
  );

  // Register <videasy-player> (the cleaner alternative)
  ui_web.platformViewRegistry.registerViewFactory(
    'videasy-player',
        (int viewId) {
      return html.document.createElement('videasy-player') as html.HtmlElement;
    },
  );
}
