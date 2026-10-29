import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kartu_profil_digital/app/app_routes.dart';
import 'package:kartu_profil_digital/data/dummy_data.dart';
import 'package:kartu_profil_digital/models/models.dart';
import 'package:kartu_profil_digital/pages/edit_profile_page.dart';
import 'package:kartu_profil_digital/pages/not_found_page.dart';
import 'package:kartu_profil_digital/pages/profile_page.dart';
import 'package:kartu_profil_digital/pages/project_detail_page.dart';
import 'package:kartu_profil_digital/pages/splash_page.dart';

final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
]);

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  HttpHeaders get headers => _MockHttpHeaders();
  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
}

class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => kTransparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.value(kTransparentImage).listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

Future<void> saveScreenshot(GlobalKey key, String filename) async {
  final boundary =
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 2.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final dir = Directory('/home/ty0x___/kartu_profil_digital/test/output');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  File('${dir.path}/$filename').writeAsBytesSync(byteData!.buffer.asUint8List());
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('Generate Modul 9 screenshots', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final key1 = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: RepaintBoundary(key: key1, child: const ProfilePage()),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Lab 1: Ikuti
    await tester.runAsync(() => saveScreenshot(key1, 'm9_lab1_ikuti.png'));

    // Tap "Ikuti"
    await tester.tap(find.text('Ikuti'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 2. Lab 2: Followers & 3. Lab 3: Snackbar
    await tester.runAsync(() => saveScreenshot(key1, 'm9_lab2_followers.png'));
    await tester.runAsync(() => saveScreenshot(key1, 'm9_lab3_snackbar.png'));

    // Settle snackbar
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // 4. Lab 4: Bio Expanded
    await tester.tap(find.text('Selengkapnya'));
    await tester.pumpAndSettle();
    await tester.runAsync(() => saveScreenshot(key1, 'm9_lab4_bio_expanded.png'));

    // 5. Lab 5: Unfollow Dialog
    await tester.tap(find.widgetWithText(OutlinedButton, 'Mengikuti'));
    await tester.pumpAndSettle();
    await tester.runAsync(() => saveScreenshot(key1, 'm9_lab5_dialog_unfollow.png'));

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    // Scroll to settings card
    await tester.ensureVisible(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    // 6. Lab 6: Switch Open to Work
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Scroll back to top to see badge
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 400));
    await tester.pumpAndSettle();
    await tester.runAsync(() => saveScreenshot(key1, 'm9_lab6_switch_opentowork.png'));

    // 7. Lab 7: Checkbox Keahlian
    await tester.ensureVisible(find.widgetWithText(CheckboxListTile, 'Dart'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Dart'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Firebase'));
    await tester.pumpAndSettle();

    // Scroll slightly to view Keahlian card chips
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 200));
    await tester.pumpAndSettle();
    await tester.runAsync(() => saveScreenshot(key1, 'm9_lab7_checkbox_skills.png'));

    // 8. Lab 8: Dropdown Status
    await tester.ensureVisible(find.byType(DropdownButton<ProfileStatus>));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<ProfileStatus>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Freelancer').last);
    await tester.pumpAndSettle();

    // Scroll up to view header with Freelancer status
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 500));
    await tester.pumpAndSettle();
    await tester.runAsync(() => saveScreenshot(key1, 'm9_lab8_dropdown_status.png'));

    // 9. Lab 9: Reset Settings Dialog
    await tester.ensureVisible(find.text('Reset pengaturan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset pengaturan'));
    await tester.pumpAndSettle();
    await tester.runAsync(() => saveScreenshot(key1, 'm9_lab9_refactor_reset.png'));

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
  });

  testWidgets('Generate Modul 10 screenshots', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // 10. Lab 1: Profil Awal dengan Daftar Proyek
    final key10_1 = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: RepaintBoundary(key: key10_1, child: const ProfilePage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() => saveScreenshot(key10_1, 'm10_lab1_profil_proyek.png'));

    // 11. Lab 2: Detail Proyek (ProjectDetailPage)
    final key10_2 = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: RepaintBoundary(
          key: key10_2,
          child: ProjectDetailPage(project: dummyProjects[0]),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() => saveScreenshot(key10_2, 'm10_lab2_detail_proyek.png'));

    // 12. Lab 3: Edit Profil (EditProfilePage)
    final key10_3 = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: RepaintBoundary(
          key: key10_3,
          child: const EditProfilePage(profile: defaultProfile),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() => saveScreenshot(key10_3, 'm10_lab3_edit_profil.png'));

    // 13. Lab 4: Splash Screen (SplashPage)
    final key10_4 = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: RepaintBoundary(
          key: key10_4,
          child: const SplashPage(onTimeout: null),
        ),
      ),
    );
    await tester.pump();
    await tester.runAsync(() => saveScreenshot(key10_4, 'm10_lab4_splash_screen.png'));

    // 14. Lab 5: onGenerateRoute & Passing Arguments Update
    final key10_5 = GlobalKey();
    const updatedProfile = Profile(
      name: 'Prasetyo Herwibowo',
      bio: 'Mahasiswa Teknik Informatika, antusias dalam pengembangan mobile modern dengan Flutter & Dart.',
    );
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: RepaintBoundary(
          key: key10_5,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Kartu Profil Digital'),
              actions: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                IconButton(icon: const Icon(Icons.logout), onPressed: () {}),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.person, size: 54, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    updatedProfile.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text('Mahasiswa', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(children: [Text('48', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('Postingan')]),
                          Column(children: [Text('1201', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('Pengikut')]),
                          Column(children: [Text('320', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('Mengikuti')]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tentang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(updatedProfile.bio),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() => saveScreenshot(key10_5, 'm10_lab5_passing_arguments.png'));

    // 15. Lab 6: Halaman 404 (NotFoundPage)
    final key10_6 = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: RepaintBoundary(key: key10_6, child: const NotFoundPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() => saveScreenshot(key10_6, 'm10_lab6_not_found_404.png'));
  });
}
