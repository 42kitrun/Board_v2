import 'package:amine_graph/pages/myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  //앱의 성능을 최적화하려면, 앱이 시작될 때 폰트를 미리 로드
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleFonts.pendingFonts([
    GoogleFonts.roboto(),
  ]);
  runApp(const MyApp());
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '아미타민',
      theme: ThemeData(
        //주요 글씨체
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        // 주요 색
        primaryColor: Color(0xFF26C1D6),
        //입력창 경계색
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF26C1D6)), //선택시 색
        )),
        //
        //elevatedButton색
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Color(0xFF26C1D6);
                  }
                  return Color(0xFFDBF9FD);
                }),
                foregroundColor: WidgetStatePropertyAll(Color(0xFF26C1D6)))),
        //listTile선택시
        listTileTheme: ListTileThemeData(
          selectedTileColor: Color(0xFF26C1D6).withOpacity(0.1),
          selectedColor: Color(0xFF26C1D6),
        ),
        // 스크롤바 scroll_bar 설정
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(true),
          trackVisibility: WidgetStatePropertyAll(true),
          thumbColor: WidgetStateProperty.all(Colors.grey),
        ),
      ),
      scrollBehavior: MyCustomScrollBehavior(),
      home: const MyHomePage(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class CustomTextTheme {
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge:
          _getCustomTextStyle(fontSize: 96, fontWeight: FontWeight.w300),
      displayMedium:
          _getCustomTextStyle(fontSize: 60, fontWeight: FontWeight.w300),
      displaySmall:
          _getCustomTextStyle(fontSize: 48, fontWeight: FontWeight.w400),
      headlineLarge:
          _getCustomTextStyle(fontSize: 40, fontWeight: FontWeight.w400),
      headlineMedium:
          _getCustomTextStyle(fontSize: 34, fontWeight: FontWeight.w400),
      headlineSmall:
          _getCustomTextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge:
          _getCustomTextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      titleMedium:
          _getCustomTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      titleSmall:
          _getCustomTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: _getCustomTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium:
          _getCustomTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: _getCustomTextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge:
          _getCustomTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium:
          _getCustomTextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      labelSmall:
          _getCustomTextStyle(fontSize: 11, fontWeight: FontWeight.w400),
    );
  }

  static TextStyle _getCustomTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    final robotoTextStyle = GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
    );

    return robotoTextStyle.copyWith(
      fontFamilyFallback: [GoogleFonts.notoSansKr().fontFamily!],
    );
  }
}
