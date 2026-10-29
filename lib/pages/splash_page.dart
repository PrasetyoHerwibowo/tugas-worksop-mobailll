import 'package:flutter/material.dart';
import '../app/app_routes.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback? onTimeout;
  const SplashPage({super.key, this.onTimeout});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _goToProfile);
  }

  void _goToProfile() {
    if (!mounted) return;
    if (widget.onTimeout != null) {
      widget.onTimeout!();
      return;
    }
    Navigator.pushReplacementNamed(context, AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.badge, size: 72, color: Colors.indigo),
            SizedBox(height: 16),
            Text(
              'Kartu Profil Digital',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
