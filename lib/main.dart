import 'package:flutter/material.dart';
import 'package:phanmovies/pages/navigation_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xffff3400),
          primary: Color(0xffff3400),
          secondary: Color(0xff006eff),
          tertiary: Color(0xff00ff84),
          onSurface: Color(0xffffb800)
        ),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xffff0000),
              primary: Color(0xffff0000),
              secondary: Color(0xff0000ff),
              tertiary: Color(0xff00eeff),
              onSurface: Color(0xffffce00)
      ),),
      themeMode: ThemeMode.system,
      home: NavigationPage()
    );
  }
}
