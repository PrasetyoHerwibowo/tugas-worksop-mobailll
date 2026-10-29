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

Future<void> saveWidgetScreenshot(
  WidgetTester tester,
  Widget widget,
  String filename, {
  Duration pumpDuration = const Duration(milliseconds: 100),
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;

  final key = GlobalKey();
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: RepaintBoundary(key: key, child: widget),
    ),
  );
  await tester.pump(pumpDuration);

  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final dir = Directory('/home/ty0x___/kartu_profil_digital/test/output');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    File('${dir.path}/$filename').writeAsBytesSync(byteData!.buffer.asUint8List());
  });
}

void main() {
  testWidgets('Capture Dialog Unfollow', (tester) async {
    await saveWidgetScreenshot(
      tester,
      Scaffold(
        backgroundColor: Colors.black45,
        body: Center(
          child: AlertDialog(
            title: const Text('Berhenti mengikuti?'),
            content: const Text(
                'Kamu tidak akan lagi melihat pembaruan dari Fakhry Firdaus.'),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () {},
                child: const Text('Berhenti'),
              ),
            ],
          ),
        ),
      ),
      'm9_lab5_dialog_unfollow.png',
    );
  });

  testWidgets('Capture Dialog Reset', (tester) async {
    await saveWidgetScreenshot(
      tester,
      Scaffold(
        backgroundColor: Colors.black45,
        body: Center(
          child: AlertDialog(
            title: const Text('Reset pengaturan?'),
            content:
                const Text('Semua pengaturan akan kembali ke nilai awal.'),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () {},
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
      'm9_lab9_refactor_reset.png',
    );
  });

  testWidgets('Capture Logout Confirmation Flow', (tester) async {
    await saveWidgetScreenshot(
      tester,
      Scaffold(
        backgroundColor: Colors.black45,
        body: Center(
          child: AlertDialog(
            title: const Text('Konfirmasi Keluar'),
            content: const Text(
                'Apakah Anda yakin ingin keluar? Semua tumpukan navigasi (stack) akan dibersihkan dan kembali ke Splash screen.'),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Keluar'),
              ),
            ],
          ),
        ),
      ),
      'm10_lab6_logout_flow.png',
    );
  });

  testWidgets('Capture go_router URL navigation', (tester) async {
    await saveWidgetScreenshot(
      tester,
      Scaffold(
        appBar: AppBar(
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock_outline, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'http://localhost:5000/#/profile/projects/p1',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ProjectDetailPage(project: dummyProjects[0]),
      ),
      'm10_lab8_go_router.png',
    );
  });
}
